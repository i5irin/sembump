# sembump

Bash script to update Semantic Version based on Conventional Commits.

## Features

Updates the Semantic Version given in the argument based on the type of Conventional Commits in the update history given in the Std-in.  
Switching between 0.x.y development versions is also supported by adding an option.

## Installation

Copy or download and save `sembump.sh` anywhere you like.  
Or redirect from curl and execute as follows:

```
echo "$update_log" \
  | bash <(curl -Ss https://raw.githubusercontent.com/i5irin/sembump/v0.1.1/sembump.sh) 2.1.1
```

## Usage

Update current version 1.2.3 using standard input.

```
/Path/to/sembump.sh 1.2.3 << EOF
feat!: add functionality
fix: fix bugs
chore: update dependencies
EOF
```

The output will be follows:

```
2.0.0
```

Update current development version 0.1.2 using standard input.

```
/Path/to/sembump.sh 0.1.2 --develop << EOF
feat!: add functionality
fix: fix bugs
chore: update dependencies
EOF
```

The output will be follows:

```
0.2.0
```

Update the current development version 0.9.7 to 1.0.0 from standard input.

```
/Path/to/sembump.sh 0.9.7 << EOF
feat!: add functionality
fix: fix bugs
chore: update dependencies
EOF
```

The output will be follows:

```
1.0.0
```

## License

This is released under the Apache License, Version2.0, see [LICENSE](./LICENSE) file for the detail.
