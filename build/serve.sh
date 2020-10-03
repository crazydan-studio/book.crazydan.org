#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"


ROOT_DIR="${DIR}/.."

BOOKS_DIR="${ROOT_DIR}/books"
DIST_DIR="${ROOT_DIR}/dist"

book_dir="$(cd "$1" && pwd -P)"
if [[ ! -d "${book_dir}" || ! -f "${book_dir}/book.toml" ]]; then
    echo "Usage: $0 <book dir>"
    exit 1
fi

book_name="$(basename "${book_dir}")"
book_dist="${DIST_DIR}/${book_name}"

mdbook serve --dest-dir "${book_dist}" "${book_dir}"
