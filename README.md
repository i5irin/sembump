# sembump

Bash script to update Semantic Version based on Conventional Commits.

## Features

Update the last Semantic Version in the git tag based on the type of Conventional Commits from the last version in the git log.
Switching between 0.x.y development versions is also supported by adding an option.  
Updating version per workspace in monorepo is also supported.

## Installation

Copy or download and save `sembump.sh` anywhere you like.  
Or redirect from curl and execute as follows:

```
bash <(curl -Ss https://raw.githubusercontent.com/i5irin/sembump/v0.4.0/sembump.sh)
```

## Usage

### Options

+ `-d` specify that this is the development version.
+ `-p` specify the prefix to be attached to the x.y.z version. (e.g. v1.0.0 => -p v)
+ `-w` specify the target directory for the update history.

### Output next version

Run the script with a version tagged starting with "v" or with no tags.

Situation
```
$ git tag
v1.2.3
$ git log --pretty=format:'%s
feat: add functionality
fix: fix bugs
chore: update dependencies
```

Commands and Outputs
```
$ /Path/to/sembump.sh -p v
v1.3.0
```

If the tag does not exist (even if the tag with the given or unspecified Prefix does not exist), v1.0.0 will be taken as the next version.

### Output the next development version

Run the script with the d option with v0.x.y tagged or with no tags.

Situation
```
$ git tag
v0.1.2
$ git log --pretty=format:'%s
feat!: add functionality
fix: fix bugs
chore: update dependencies
```

Commands and Outputs
```
$ /Path/to/sembump.sh -d -p v
v0.2.0
```

If the tag does not exist (even if the tag with the given or unspecified Prefix does not exist), v0.1.0 will be taken as the next version.  
**With the development version option, feature updates and breaking changes are treated as minor updates, and bug fixes and other updates are treated as patch updates.**

### Update from the development version to the production version

Run the script without the d option with the v0.x.y tag.

Situation
```
$ git tag
v0.9.7
$ git log --pretty=format:'%s
feat: add functionality
fix: fix bugs
chore: update dependencies
```

Commands and Outputs
```
$ /Path/to/sembump.sh -p v
v1.0.0
```

### Update associated with a specific directory in the monorepo

Run the script in situations where a specific directory update is tied to a tag with a specific prefix.

Situation
```
$ git tag
front/v1.0.7
$ git log --pretty=format:'%s -- apps/front
feat: add functionality
fix: fix bugs
chore: update dependencies
$ tree -L 2
.
├── README.md
└── apps
    ├── front
    └── api
```

Commands and Outputs
```
$ /Path/to/sembump.sh -p front/v -w apps/front
front/v1.1.0
```

## License

This is released under the Apache License, Version2.0, see [LICENSE](./LICENSE) file for the detail.
