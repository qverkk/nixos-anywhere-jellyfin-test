#!/bin/sh
nixos-rebuild switch --flake .#vm --target-host $1
