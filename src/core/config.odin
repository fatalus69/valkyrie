package core;

import "core:fmt"
import "core:strings"
import "core:os"
import "core:encoding/json"

general_types: []string = {"name", "type", "description", "license"}
filename: string = "valkyrie.json"

writeToConfig :: proc(data: map[string]string) {
  if checkForConfig() == false {
    //read file then write to it
  } else {
    json_data, json_err := json.marshal(data, {
      pretty = true
    })
    if json_err != nil {
      fmt.eprintln("Error serializing JSON: ", json_err)
      os.exit(1)
    }

    write_err := os.write_entire_file_or_err(filename, json_data)
    if write_err != nil {
      fmt.eprintln("Error writing to configuration file: ", write_err)
      os.exit(1)
    }

  }
}

writeDependency :: proc(pkg: string) {
  _ = checkForConfig()
  name, version := getNameAndVersion(pkg)

  data, ok := os.read_entire_file_from_filename(filename)
  if !ok {
    fmt.eprintln("Error reading from", filename)
    os.exit(1)
  }
  defer(delete(data))

  json_data, parse_err := json.parse(data)
  if parse_err != nil {
    fmt.eprintln("Error parsing configuration", parse_err)
  }
  defer(json.destroy_value(json_data))

  fmt.println(json_data)

  //json_data["dependencies"] = map[]
  

}

readDependencies :: proc() /*-> (map[int][]string)*/ {

}
