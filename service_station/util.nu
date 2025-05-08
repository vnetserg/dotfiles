def parse-path [ args: list<string> ] {
  for i in 0..<($args | length) {
    if ($args | get $i) == "-selectedItemURLs" {
      return ($args | get ($i + 1))
    }
  }
  return null
}
