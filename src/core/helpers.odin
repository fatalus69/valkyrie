package core;

import "core:fmt"
import "core:os"
import "core:strings"

// Return false if config exists  
checkForConfig :: proc() -> (bool) {
  filename: string = "valkyrie.json"
  if os.exists(filename) {
    return false
  }
  
  file, err := os.open(filename, os.O_WRONLY | os.O_CREATE | os.O_TRUNC, 0o644)
  defer(os.close(file))

  if err != nil && err != os.ERROR_NONE {
    fmt.eprintln("Failed to create ", filename, ":", err)
    os.exit(1)
  }

  return true
}

//Should also detect commit hashes.
//TODO: Verify this:x
getNameAndVersion :: proc (pkg: string) -> (string, string, string) {
  name, branch, type, rest: string
  patterns : []string ={"/-", "/tree", "/blob"}
  
  for pattern in patterns {
    if strings.contains(pkg, pattern) {
      name = strings.trim_space(strings.split(pkg, pattern)[0])
      break
    }
  }

  name_part, _ := strings.remove(pkg, name, -1)
  rest = strings.trim_space(name_part)

  if strings.contains(pkg, "git") {
    type = "vsc"
    if strings.contains(rest, "tree") {
      //get branch if present in url
      branch = strings.split(strings.split(rest, "tree/")[1], "/")[0]
      //remove params and bookmarks in url if existing
      if strings.contains(branch, "?") {
        branch = strings.trim_space(strings.split(branch, "?")[0])
      }
      if strings.contains(branch, "#") {
        branch = strings.trim_space(strings.split(branch, "#")[0])
      }
    }
  }
  return name, branch, type 
}
