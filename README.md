# Valkyrie - A package manager for Odin
## Sketch and Future TODO's:

## GENERAL:
- CLI Name: valkyrie
- Package folder: runepkg
- Config Files: valkyrie.json (dependencies and settings) & valkyrie.lock (pin exact versions, tags or commits)
- Import style: import "runepkg:foo"

### Commands:
- valkyrie engrave [package] – installs one package from ressource
- valkyrie forge - Installs all packages from valkyrie.json
- valkyrie remove [package] - removes desired package
- valkyrie update [package] - updates all or desired package
- valkyrie init – starts an interactive setup
- valkyrie clean-install - wipes + reinstalls all packages
- valkyrie list - list installed packages

##### Maybe:
- valkyrie doctor - check setup of json
- valkyrie graph - show dependency graph (future feature)

#### Dependency Format:
- git - with ref, tag or branch
- path - for local package development
- version (maybe)

#### Lock File:
- exact commit hash
- metadata

#### Stuff I should consider:
- A script that replaces import "runepkg:foo" with relative paths during build or a wrapper that does that during odin build

#### Example of valkyire.json:
````json
{
    name: "example",
    type: "library",
    dependencies: {
        "https://github.com/vendor/repo": {
            type: "git",
            branch: "main"
        }
    }
}
````
#### Structure:
```
src/
├── main.odin                 # CLI entrypoint
├── cli/
│   ├── commands.odin         # All commands and dispatch logic
│   ├── parser.odin           # os.args[] parser & help output
├── core/
│   ├── config.odin           # valkyrie.json reading/writing
│   ├── lockfile.odin         # valkyrie.lock reading/writing
│   ├── resolver.odin         # dependency resolver (git clones, paths, etc)
│   ├── installer.odin        # install/update/remove logic
│   ├── helpers.odin          # helper stuff (string handling, error printing, etc)
└── types/
    ├── package.odin          # structs for dependencies, versions, etc
    └── config_schema.odin    # if needed for json struct definitions
```
