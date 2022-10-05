# Changelog

## v0.4.0 (2022-10-05)

🚀 New Feature

+ allow specifying the target directory of the update history
+ allow prefixes in version tags

🐛 Bug Fix

+ add an error when the type of update cannot be determined
+ enable to get the update history when the version does not exist
+ allow the version Prefix to include the sed special character
+ prevent Prefixed from being processed without specifying a Prefix

## v0.3.0 (2022-09-24)

💥 Breaking Change

+ get the current version from Git
+ get the update history from Git

## v0.2.0 (2022-09-16)

🚀 New Feature

+ treat the current version as 0.0.0 by default
+ the default version without the develop option is 1.0.0

🐛 Bug Fix

+ the first Patch update from 0.0.0 should be 0.1.0
+ avoid unexpected behavior in the order of arguments

## v0.1.1 (2022-09-12)

📝 Documentation

+ correct the example of execution in curl

## v0.1.0 (2022-09-04)

🎉 First release!
