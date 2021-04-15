#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
export LC_ALL=C

PACKAGES_FILES=(
    linux/packages.txt
    linux-micro/packages.txt
)

# Ensure packages lists are sorted
for file in ${PACKAGES_FILES[@]}; do
    # Replace / with - in the file path to avoid creating subdirs.
    sorted_file="/tmp/sorted-${file/\//-}"

    cat "${file}" | sort -u > "${sorted_file}"
    if ! diff -u "${sorted_file}" "${file}"; then
        echo "Lint error: ${file} is not sorted"
        exit 1
    fi
done

echo "All lints passed"
