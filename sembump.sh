#!/bin/bash

# Copyright 2022 i5irin
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eu

# TODO: Add a flag to treat commits other than Conventional Commits as Patch updates.
function read_update_type() {
  update_type=''
  while read -r line; do
    log=$(echo "$line" |
      sed -nr 's/^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\([a-zA-Z_0-9]+\))?(!)?: (.*)$/\1:\3/p')
    IFS=: read -r commit_type is_breaking <<<"$log"
    if [ "$is_breaking" = '!' ]; then
      update_type='major'
    elif [ "$commit_type" = 'feat' ]; then
      update_type='minor'
    elif [ -n "$commit_type" ] && [ "$update_type" != 'major' ] && [ "$update_type" != 'minor' ]; then
      update_type='patch'
    fi
  done < <(cat -)
  echo "$update_type"
}

function bumpup_version() {
  update_type="$1"
  current_version="$2"
  is_develop="$3"
  IFS=. read -r major minor patch <<<"$current_version"
  if [ "$is_develop" = 'true' ] && [ "$major" != '0' ]; then
    echo 'The major version of the development version must be 0.' 1>&2
    return 1
  elif [ "$is_develop" = 'true' ] && [ "$current_version" = '0.0.0' ]; then
    echo '0.1.0'
    return 0
  elif [ "$is_develop" = 'false' ] && [ "$major" = '0' ]; then
    echo "1.0.0"
    return 0
  fi
  case "$update_type" in
  "major")
    if [ "$is_develop" = 'true' ]; then
      echo "$major.$((minor + 1)).0"
    else
      echo "$((major + 1)).0.0"
    fi
    ;;
  "minor") echo "$major.$((minor + 1)).0" ;;
  "patch") echo "$major.$minor.$((patch + 1))" ;;
  *)
    echo 'Invalid update type was specified.' 1>&2
    return 1
    ;;
  esac
}

function get_current_version() {
  local version
  version=$(git tag \
    | sed -rn 's/v((0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-((0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(\.(0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*))?(\+([0-9a-zA-Z-]+(\.[0-9a-zA-Z-]+)*))?$)/\1/p' \
    | sort -Vr \
    | head -1)
  if [ -z "$version" ]; then
    version='0.0.0'
  fi
  echo "$version"
}

function main() {
  if [ ! -p /dev/stdin ]; then
    echo 'Give the update history from the standard input.'
    return 1
  fi
  local current_version develop_option='false'
  current_version=$(get_current_version)
  while getopts d OPT; do
    case $OPT in
      d) develop_option='true' ;;
      *) exit 1;;
    esac
  done
  export -f bumpup_version
  cat - \
    | read_update_type \
    | xargs -I{} bash -c "bumpup_version {} $current_version $develop_option"
}

main "$@"
