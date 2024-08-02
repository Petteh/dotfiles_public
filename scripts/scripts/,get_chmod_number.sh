#!/usr/bin/env bash

for f in "$@"; do
    num=$(stat --format '%a' "$f")
    echo -e "$f\t$num"
done

