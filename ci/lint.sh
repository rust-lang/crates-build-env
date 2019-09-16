#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Ensure packages lists are sorted
for file in packages; do
    cat "${file}.txt" | sort > "/tmp/sorted-${file}.txt"
    if ! diff "/tmp/sorted-${file}.txt" "${file}.txt" >/dev/null 2>&1; then
        echo "Lint error: ${file}.txt is not sorted"
        exit 1
    fi
done

echo "All lints passed"
