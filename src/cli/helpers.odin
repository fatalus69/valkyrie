package cli;

import "core:fmt"
import "core:strings"
import "core:os"

getUserInput :: proc() -> (string) {
  buf: [256]byte
  n, err := os.read(os.stdin, buf[:])
  
  if err != nil {
    if err == os.ERROR_EOF {
      return ""
    }

    fmt.eprintln("Error reading: ", err)
    os.exit(1)
  }
  
  return strings.trim_space(strings.clone(string(buf[:n])))
}
