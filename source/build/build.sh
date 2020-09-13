#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"


ROOT_DIR="${DIR}/.."

BOOKS_DIR="${ROOT_DIR}/books"
DIST_DIR="${ROOT_DIR}/dist"

for book in `find "${BOOKS_DIR}" -type f -name book.toml`; do
    book_dir="$(dirname "${book}")"
    book_name="$(basename "${book_dir}")"
    book_dist="${DIST_DIR}/${book_name}"

    mdbook clean --dest-dir "${book_dist}" "${book_dir}"
    mdbook build --dest-dir "${book_dist}" "${book_dir}"
done
