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
  while read -r line; do
    log=$(echo "$line" |
      sed -nr 's/^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\([a-zA-Z_0-9]+\))?(!)?: (.*)$/\1:\3/p')
    IFS=: read -r commit_type is_breaking <<<"$log"
    if [ -z "$commit_type" ]; then
      continue
    fi
    if [ "$is_breaking" = '!' ]; then
      echo 'major'
      continue
    fi
    if [ "$commit_type" = 'feat' ]; then
      echo 'minor'
    else
      echo 'patch'
    fi
  done < <(cat -)
}

function reduce_update_type() {
  reduced_type=''
  while read -r update_type; do
    if [ "$update_type" = 'major' ]; then
      echo 'major'
      return 0
    fi
    if [ "$update_type" = 'minor' ]; then
      reduced_type='minor'
    fi
    if [ "$update_type" = 'patch' ] && [ "$reduced_type" != 'minor'  ]; then
      reduced_type='patch'
    fi
  done < <(cat -)
  if [ -z "$reduced_type" ]; then
    return 1
  fi
  echo "$reduced_type"
}

function bumpup_version() {
  current_version="$1"
  update_type="$2"
  is_develop="$3"
  IFS=. read -r major minor patch <<<"$current_version"
  if [ "$is_develop" = '--develop' ] && [ "$major" != '0' ]; then
    echo 'The major version of the development version must be 0.' 1>&2
    return 1
  fi
  if [ "$is_develop" != '--develop' ] && [ "$major" = '0' ]; then
    echo "1.0.0"
    return 0
  fi
  case "$update_type" in
  "major")
    if [ "$is_develop" = '--develop' ]; then
      echo "$major.$((minor + 1)).0"
    else
      echo "$((major + 1)).0.0"
    fi
    ;;
  "minor")
    echo "$major.$((minor + 1)).0"
    ;;
  "patch")
    echo "$major.$minor.$((patch + 1))"
    ;;
  *)
    echo 'Invalid update type was specified.' 1>&2
    return 1
    ;;
  esac
}

DEVELOP=''
while (($# > 0)); do
  case $1 in
  -d | --develop)
    if [[ -n "$DEVELOP" ]]; then
      echo "Duplicated 'option'." 1>&2
      exit 1
    fi
    DEVELOP='--develop'
    ;;
  -*)
    echo "invalid option"
    exit 1
    ;;
  *)
    CURRENT_VERSION="$1"
    ;;
  esac
  shift
done

export -f bumpup_version
if [ -p /dev/stdin ]; then
  cat -
else
  echo "$@"
fi |
  read_update_type |
  reduce_update_type |
  xargs -I{} bash -c "bumpup_version $CURRENT_VERSION {} $DEVELOP"
