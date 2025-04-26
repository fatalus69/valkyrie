package core;

import "core:fmt"
import "core:strings"
import "core:os"

writeToConfig :: proc(data: map[string]string) {
 checkIfConfigExists()
}

checkIfConfigExists :: proc() {
  filename: string = "valkyrie.toml"
  if os.exists(filename) {
    return
  }
  
  file, err := os.open(filename, os.O_CREATE)
  if err != nil && err != os.ERROR_NONE {
    fmt.eprintln("Failed to create ", filename, ":", err)
  }
}
