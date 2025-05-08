#!/opt/homebrew/bin/nu

source util.nu

def --wrapped main [ ...args: string ] {
  let path = parse-path $args

  /opt/homebrew/bin/wezterm -e /Users/se4min/.cargo/bin/yazi $path
}
