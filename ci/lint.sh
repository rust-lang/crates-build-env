#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
export LC_ALL=C

# Ensure packages lists are sorted
for file in packages; do
    cat "${file}.txt" | sort -u > "/tmp/sorted-${file}.txt"
    if ! diff -u "/tmp/sorted-${file}.txt" "${file}.txt"; then
        echo "Lint error: ${file}.txt is not sorted"
        exit 1
    fi
done

echo "All lints passed"
