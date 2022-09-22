# sembump

Bash script to update Semantic Version based on Conventional Commits.

## Features

Update the last Semantic Version in the git tag based on the type of Conventional Commits from the last version in the git log.
Switching between 0.x.y development versions is also supported by adding an option.

## Installation

Copy or download and save `sembump.sh` anywhere you like.  
Or redirect from curl and execute as follows:

```
bash <(curl -Ss https://raw.githubusercontent.com/i5irin/sembump/v0.3.0/sembump.sh)
```

## Usage

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
$ /Path/to/sembump.sh
1.3.0
```

If the tag does not exist, v1.0.0 will be taken as the next version.

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
$ /Path/to/sembump.sh -d
0.2.0
```

If the tag does not exist, v0.1.0 will be taken as the next version.  
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
$ /Path/to/sembump.sh
1.0.0
```

## License

This is released under the Apache License, Version2.0, see [LICENSE](./LICENSE) file for the detail.
