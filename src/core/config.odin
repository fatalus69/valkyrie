#+feature dynamic-literals
package core;

import "core:fmt"
import "core:strings"
import "core:os"
import "core:encoding/json"

//Prototype. If it stays TODO: move to /src/types/core.odin
json_structure :: struct {
  name: string,
  type: string,
  dependencies: map[string]map[string]string
}

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
  name, version, type := getNameAndVersion(pkg)

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

  dependency_map: map[string]map[string]string

  dependency_map[name] = {
    "type" = type,
    "version" = version
  }
  json_struc := new(json_structure)
  json_map := json_data.(json.Object)
  
  json_struc.name = json_map["name"].(string)
  json_struc.type = json_map["type"].(string)
  json_struc.dependencies = dependency_map

  json_builder, build_err := json.marshal(json_struc, {
    pretty = true
  })

  if build_err != nil {
    fmt.eprintln("Error serializing Json", build_err)
    os.exit(1)
  }

  write_err := os.write_entire_file_or_err(filename, json_builder)

  if write_err != nil {
    fmt.eprintln("Error writing to file", write_err)
    os.exit(1)
  }
}

readDependencies :: proc() /*-> ()*/ {

}
