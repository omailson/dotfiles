#!/bin/bash

packages=`cat "$1" | tr -d '\n' | tr -s ' '`

for p in $packages; do
	echo "$p"
done
