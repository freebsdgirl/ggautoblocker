#!/usr/bin/env bash

set -eou pipefail

readonly USERNAME=$(echo "$1" | tr -d '@')

function user_exists_warning(){
  echo "$USERNAME is already on whitelist. Exiting..."
  exit 1
}

function add_user_to_whitelist(){
  echo "$USERNAME" >> whitelist.txt
}

function add_whitelist_to_git(){
  git add whitelist.txt
  git commit -m "Add $USERNAME to whitelist based on Appeal Group decision"
}

function main(){
  if [[ $(grep -i -e "$USERNAME" whitelist.txt ) ]];then
    user_exists_warning
  else
    add_user_to_whitelist
    add_whitelist_to_git
  fi
}

main
