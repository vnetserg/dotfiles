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

alias fzf-preset = fzf --scheme=history --read0 --tiebreak=chunk --layout=reverse --preview='echo {..}' --preview-window='bottom:3:wrap' --bind alt-up:preview-up,alt-down:preview-down --height=70% --preview='echo -n {} | nu --stdin -c nu-highlight'

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
    name: fuzzy_cd_history_fzf
    modifier: control
    keycode: char_u
    mode: [emacs vi_normal vi_insert]
    event: {
      send: executehostcommand
      cmd: "cd (
        zoxide query -l ''
          | lines
          | where { |x| $x != $env.PWD }
          | str replace $nu.home-path ~
          | str join (char -i 0)
          | fzf-preset
      )"
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

# Zoxide
source zoxide.nu

# Yandex-specific settings
source ya/ya.nu
