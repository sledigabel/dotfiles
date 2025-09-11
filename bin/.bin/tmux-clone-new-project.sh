#!/bin/bash

repo=""
if [[ "${#}" -eq 1 ]]; then
  repo=$1
elif [[ "${#}" -eq 0 ]]; then
  echo "Repository to clone:"
  echo -n " "
  read -r repo
else
  echo "Need 0 or 1 argument"
  exit 1
fi

echo ${#}
echo "cloning ${repo}"

if echo "$repo" | grep -q "^https://"; then
  endpoint_name=$(echo "$repo" | awk -F '/' '{print $3}')
elif echo "$repo" | grep -q "^git@"; then
  endpoint_name=${repo#git@}
  endpoint_name=${endpoint_name%:*}
else
  echo "Couldn't parse repository ${repo} properly"
fi

case ${endpoint_name} in
"github.com")
  # we have to check whether it's a personal or work repo
  # if the repo belongs to the `skyscanner` organisation, we assume it's a work repo
  if echo "$repo" | grep -q "github.com/skyscanner/"; then
    echo "Cloning in WORK"
    pushd ~/dev/work || exit 2
  else
    echo "Cloning in PERSO"
    pushd ~/dev/perso || exit 2
  fi
  git clone "$repo"
  popd >/dev/null || exit 2
  ;;
"github.skyscannertools.net")
  echo "Cloning in WORK"
  pushd ~/dev/work || exit 2
  git clone "$repo"
  popd || exit 2
  ;;
*)
  echo "the server is not recognised"
  exit 1
  ;;
esac
if [ "$1" == "--help" ]; then
  echo "Usage: ./script.sh <input>"
elif [ "$1" = "" ]; then
  echo "Input argument cannot be empty."
else
  echo "Hello, world!"
fi

read -p "Press enter to continue"
