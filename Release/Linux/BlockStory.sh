#!/bin/sh
printf '\033c\033]0;%s\a' BlockStory
base_path="$(dirname "$(realpath "$0")")"
"$base_path/BlockStory.x86_64" "$@"
