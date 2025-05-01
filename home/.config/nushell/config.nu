# config.nu
#
# Installed by:
# version = "0.103.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.cursor_shape = {
  vi_insert: line
  vi_normal: block
}

# Environment variables
$env.EDITOR = "hx"
$env.HELIX_RUNTIME = "~/code/contrib/helix/runtime" | path expand
$env.PATH = $env.PATH | append ["~/bin" "~/.cargo/bin", "~/.local/bin"]

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
  zellij attach main
}

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
          | fzf --scheme=history --read0 --tiebreak=chunk --layout=reverse --preview='echo {..}' --preview-window='bottom:3:wrap' --bind alt-up:preview-up,alt-down:preview-down --height=70% -q (commandline) --preview='echo -n {} | nu --stdin -c \'nu-highlight\''
          | decode utf-8
          | str trim
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
