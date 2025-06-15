source themes/nord.nu

$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.cursor_shape = {
  vi_insert: line
  vi_normal: block
}
$env.config.history.max_size = 1000000

# Environment variables
$env.EDITOR = "hx"
$env.HELIX_RUNTIME = "~/code/contrib/helix/runtime" | path expand
$env.PATH = $env.PATH | append [
  ~/bin
  ~/.cargo/bin
  ~/.local/bin
  /usr/local/bin
  /opt/homebrew/bin
]

def --env yy [...args] {
  let tmp = mktemp -t "yazi-cwd.XXXXXX"
  yazi ...$args $"--cwd-file=($tmp)"
  cd (open $tmp)
  rm -f $tmp
}

def za [] {
  let pids = ps -l | where name == zellij and command =~ "attach main" | get pid
  if ($pids | length) > 0 {
    kill -f ...$pids
  }
  zellij attach main -c
}

def hollow [path] {
  let atime = stat -c %X $path
  let mtime = stat -c %Y $path
  truncate -s 0 $path
  touch -a -d $"@($atime)" -m -d $"@$($mtime)" $path
}


def claude [] {
  $env.HTTP_PROXY = "http://localhost:3128"
  ^claude
}


alias fzf-preset = fzf --scheme=history --read0 --layout=reverse --preview='echo {..}' --preview-window='bottom:3:wrap' --bind alt-up:preview-up,alt-down:preview-down --height=70% --preview='echo {} | nu --stdin -c "nu-highlight | str trim"'

# Keybindings
$env.config.keybindings = [
  {
    name: fuzzy_history_fzf
    modifier: control
    keycode: char_r
    mode: [emacs vi_normal vi_insert]
    event: {
      send: executehostcommand
      cmd: "commandline edit --replace (
        history
          | get command
          | reverse
          | uniq
          | str join (char -i 0)
          | fzf-preset -q (commandline)
          | decode utf-8
          | str trim
      )"
    }
  }
  {
    name: fuzzy_file_fzf
    modifier: control
    keycode: char_f
    mode: [emacs vi_normal vi_insert]
    event: {
      send: executehostcommand
      cmd: "commandline edit --insert (
        fd --follow
          | lines
          | str join (char -i 0)
          | fzf-preset
      )"
    }
  }
  {
    name: quicknav
    modifier: control
    keycode: char_u
    mode: [emacs vi_normal vi_insert]
    event: {
      send: executehostcommand
      cmd: "quicknav-hotkey"
    }
  }
  {
    name: yazi
    modifier: control
    keycode: char_y
    mode: [emacs vi_normal vi_insert]
    event: {
      send: executehostcommand
      cmd: "yy"
    }
  }
]

#
# Prompt customization
#

$env.PROMPT_INDICATOR = $"(ansi green_bold)➜(ansi reset) "
$env.PROMPT_INDICATOR_VI_INSERT = $"(ansi green_bold)➜(ansi reset) "
$env.PROMPT_INDICATOR_VI_NORMAL = $"(ansi green_bold)➜(ansi reset) "
$env.PROMPT_COMMAND_RIGHT = ""

$env.PROMPT_COMMAND = {
  mut components = []

  # Path
  let is_root = (^whoami) == "root"
  if $is_root {
    $components = $components | append {
      text: (pwd)
      color: "red_bold"
    }
  } else {
    $components = $components | append {
      text: (pwd | str replace $nu.home-path '~')
      color: "cyan_bold"
    }
  }

  # Hostname
  let host_name = (sys host | get hostname | split row "." | get 0)
  let host_color = if $host_name == "se4min-dev" {
    "yellow_bold"
  } else if $host_name == "se4min-osx" {
    "green_bold"
  } else if $host_name == "ariel" {
    "magenta_bold"
  } else {
    "white_bold"
  }
  $components = $components | append {
    text: $host_name
    color: $host_color
  }

  # Yandex-specific
  if "ENV_NAME" in $env {
    $components = $components | append {
      text: $"[($env.ENV_NAME)]"
      color: blue_bold
    }
  }
  if "K8S_CONTEXT" in $env {
    $components = $components | append {
      text: $"[($env.K8S_CONTEXT)]"
      color: blue_bold
    }
  }

  mut prompt = ""
  mut len = -1
  let term_width = term size | get columns
  for comp in $components {
    if $len + ($comp.text | str length) + 1 > $term_width and not ($prompt | is-empty) {
      break
    }
    $prompt = $prompt + $" (ansi $comp.color)($comp.text)(ansi reset)" | str trim
    $len += ($comp.text | str length) + 1
  }

  $prompt + "\n"
}

#
# Quick navigation module
#

module quicknav {
  const FILES_DB_PATH = "~/.config/nushell/files_db.txt" | path expand
  const FILES_DB_SIZE = 10000

  def pre-exec-hook [] {
    let entries = commandline
      | split row " "
      | where { $in | path exists }
      | path expand

    let old_history = try {
      open $FILES_DB_PATH | lines
    } catch {
      []
    }
    let history_filtered = $old_history
      | where { |old_entry| not ($entries | any { |entry| $entry == $old_entry } ) }
    let new_history = $entries ++ $history_filtered | take $FILES_DB_SIZE

    let tmp = mktemp files_db.tmp.XXXXXX -p ($FILES_DB_PATH | path dirname)
    $new_history | str join "\n" | save -f $tmp
    mv -f $tmp $FILES_DB_PATH
  }

  export-env {
    $env.config.hooks.pre_execution = $env.config.hooks.pre_execution | append { pre-exec-hook }
  }

  export def --env quicknav-hotkey [] {
    let words = commandline | split row " "
    let cursor = (commandline get-cursor)
    let word_index = find-word $words $cursor
    let is_leading = $words | take $word_index | all { $in | str trim | is-empty }
    if $is_leading {
      let path = fuzzy-cd-path (commandline)
      cd $path
    } else {
      mut arg = fuzzy-file-path ($words | get -i $word_index | default "")
      if ($arg | str contains " ") {
        $arg = $"`($arg)`"
      }

      let new_words = $words | update $word_index $arg
      commandline edit --replace ($new_words | str join " ")
      commandline set-cursor (position-after-word $new_words $word_index)
    }
  }

  def find-word [ words: list<string>, cursor: int ] {
    mut current = -1
    for item in ($words | enumerate) {
      let len = $item.item | str length
      $current = $current + $len + 1
      if $cursor <= $current {
        return $item.index
      }
    }
    return ($words | length)
  }

  def fuzzy-cd-path [ query: string ] {
    zoxide query -l ""
      | lines
      | where { $in != $env.PWD }
      | str replace $nu.home-path ~
      | str join (char -i 0)
      | fzf-preset -q $query
  }

  def fuzzy-file-path [ query: string ] {
    let paths = try {
      open $FILES_DB_PATH | lines
    } catch {
      []
    }
    $paths
      | where { $in | path exists }
      | str replace $nu.home-path ~
      | str join (char -i 0)
      | fzf-preset -q $query
  }

  def position-after-word [ words: list<string>, index: int ] {
    mut current = -1
    for item in ($words | enumerate) {
      let len = $item.item | str length
      $current = $current + $len + 1
      if $index == $item.index {
        return $current
      }
    }
    return [0 $current] | math max
  }
}

use quicknav *

# Zoxide
source zoxide.nu

# Yandex-specific settings
source ya.nu
