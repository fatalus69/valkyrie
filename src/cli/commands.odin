package cli;

import "core:fmt"
import "core:os"
import "core:strings"
import "core:encoding/ansi"
import "../core"

Command :: struct {
    name: string,
    requires_argument: bool,
    handler: proc(arg: string),
    description: string,
}

StringMapper :: struct {
  type: string,
  value: string,
}

commands :: []Command {
  Command{"init", false, init, "Initialize a project"},
  Command{"help", false, help, "Display all commands"}, 
  Command{"engrave", true, engrave, "Install a package from source"},
  Command{"forge", false, forge, "Install packages from config"}
}

help :: proc(_: string) {
  //Looks shit here, I know but it actually looks good when printed 
  logo: string = `           _ _               _      
           | | |             (_)     
__   ____ _| | | ___   _ _ __ _  ___ 
\ \ / / _  | | |/ / | | | '__| |/ _ \
 \ V / (_| | |   <| |_| | |  | |  __/
  \_/ \__,_|_|_|\_\\__, |_|  |_|\___|
                    __/ |            
                   |___/  
`
  fmt.println(ansi.CSI + ansi.FG_MAGENTA + ansi.SGR, logo, ansi.CSI + ansi.RESET + ansi.SGR)
  fmt.println("Available commands:")
  
  for cmd in commands {
    fmt.println(" ", ansi.CSI + ansi.FG_GREEN + ansi.SGR, cmd.name, ansi.CSI + ansi.RESET + ansi.SGR, " - ", cmd.description)
  }
}

init :: proc(_: string) {
  fmt.println("This Command will help you create your valkyrie.json configuration.")
  user_input: string
  if os.exists("valkyrie.json") {
    fmt.printf("Configuration already exists. Want to overwrite it? [y, n] (n) ")
    
    user_input = getUserInput()

    if user_input == "" || user_input == "n" {
      os.exit(1)
    }

    fmt.println("Proceeding with Configuration...")
  }

  //TODO: use a versatile directory seperator since windows uses backslashes and unix forward slashes
  current_dir: []string = strings.split(os.get_current_directory(), "/")
  project_name: string = strings.trim_space(current_dir[len(current_dir) - 1])

  fmt.printf("Enter name of the project: (%[0]s) ", project_name,)
  user_input = getUserInput()

  if len(user_input) > 0 {
    project_name = user_input
  }

  project_type: string = ""
  fmt.printf("Enter a package type: ")

  user_input = getUserInput()

  if len(user_input) > 0 {
    project_type = user_input
  }
  config_data := make(map[string]string)

  config_data["type"] = project_type
  config_data["name"] = project_name 

  core.writeToConfig(config_data)
}

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

engrave :: proc(pkg: string) {
  core.writeDependency(pkg) 
}

forge :: proc(_: string) {

}

