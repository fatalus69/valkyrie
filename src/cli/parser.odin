package cli;

import "core:os"
import "core:fmt"
import "core:strings"

main :: proc() {
  if len(os.args) == 1 {
    help("")
    return
  }

  command: string = strings.trim_space(os.args[1])
  arguments: string = ""
  
  if len(os.args) > 2 {
    arguments = strings.trim_space(os.args[2])
  }

  for cmd in commands {
    if cmd.name == command {
      if cmd.requires_argument && arguments == "" {
        fmt.println(command, "Requires at least one argument")
        return
      }
      cmd.handler(arguments)
      return
    }
  }

  fmt.println("Unknown command: ", command)
  help("")
}
