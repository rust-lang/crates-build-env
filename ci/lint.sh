#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Ensure `packages.txt` is sorted
cat packages.txt | sort > /tmp/sorted-packages.txt
if ! diff /tmp/sorted-packages.txt packages.txt >/dev/null 2>&1; then
    echo "Lint error: packages.txt is not sorted"
    exit 1
fi

echo "All lints passed"
