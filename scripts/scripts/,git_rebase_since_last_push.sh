#!/usr/bin/env bash

if git status | grep -F "Your branch is up to date with"; then
    git status
    exit 0
fi

num_commits="$(git status -sb | sed -En "s/.*ahead ([0-9]+).*/\1/p")"

if [ -z "$num_commits" ]; then
    echo "Unable to find number of commits since last push. Exiting..."
    exit 1
fi

git rebase -i "HEAD~$num_commits"
