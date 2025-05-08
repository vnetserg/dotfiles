#!/opt/homebrew/bin/nu

source util.nu

def --wrapped main [ ...args: string ] {
  mut path = parse-path $args

  if (not ($path | path exists)) {
    $path = $nu.home-path
  } else if (($path | path type) != "dir") {
    $path = $path | path dirname
  }

  /opt/homebrew/bin/wezterm start --cwd $path
}
