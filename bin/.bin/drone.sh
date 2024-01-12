#!/bin/bash

export DRONE_SERVER="https://drone-github.skyscannertools.net"
export DRONE_TOKEN="$(security find-generic-password -a $USER -s drone_token -w skyscanner.keychain)"
