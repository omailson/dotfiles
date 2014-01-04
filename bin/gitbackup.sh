#!/bin/bash
# Script to perform a remote backup of the current git workspace

git commit -a -m WIP
git push -f origin HEAD:backup-"$USER"
git reset HEAD~1
