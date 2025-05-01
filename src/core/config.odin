package core;

import "core:fmt"
import "core:strings"
import "core:os"
import "core:encoding/json"

general_types: []string = {"name", "type", "description", "license"}

writeToConfig :: proc(data: map[string]string) {
  path: string = "./valkyrie.json"
  //TODO: Rename function, no one would get what its doing
  if checkForConfig() == false {
    //read file then write to it
  } else {
    //file, err := os.open("valkyrie.json", os.O_WRONLY | os.O_TRUNC, 0o644)
    //defer(os.close(file))
    
    //if err != nil && err != os.ERROR_NONE {
      //os.exit(1)
    //}

    json_data, json_err := json.marshal(data, {
      pretty = true
    })
    if json_err != nil {
      fmt.eprintln("Error serializing JSON: ", json_err)
      os.exit(1)
    }

    write_err := os.write_entire_file_or_err(path, json_data)
    if write_err != nil {
      fmt.eprintln("Error writing to configuration file: ", write_err)
      os.exit(1)
    }

  }
}

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
