#!/usr/bin/env bash

usage() {
    >&2 echo -e "\nCalculates the checksum in the current directory recursively using the given algorithm"
    >&2 echo -e "\tUsage: $(basename "$0") [md5, sha256, sha512]"
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

check=""
case "$1" in
    md5)
        check=md5sum    ;;
    sha256)
        check=sha256sum ;;
    sha512)
        check=sha512sum ;;
    *)
        >&2 echo "ERROR! Invalid algorithm '$1'. Exiting..."
        usage
        ;;
esac

>&2 echo "Using algorithm '$check'"
out="checksums.$1"

if [ -f "$out" ]; then
    read -r -p "WARNING! File '$out' already exists. Overwrite? [y/n]: " yn
    if [[ $yn == [Yy]* ]]; then
        >&2  echo "Overwriting '$out'"
    else
        >&2 echo "Exiting..."
        exit 3
    fi
fi

>&2 echo "Calculating checksums..."
fd --hidden --no-ignore -t file -x "$check" |
    sort -k 2 > "$out"

# TODO: Recurse down directories and make a checksums.md5 file in every directory root
fd --hidden --no-ignore -t directory | while read -r d; do
    dir_out="./${d}${out}"
    >&2  echo "Overwriting $dir_out"
    grep -F "./$d" "./$out" > "$dir_out"
done

>&2 echo -e "\nDone"
