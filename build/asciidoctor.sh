#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"


ROOT_DIR="$(cd "${DIR}/.." && pwd -P)"


rm -rf "${ROOT_DIR}/dist"
echo
echo "Create index for all books ..."
docker run --rm \
    --user $(id -u):$(id -g) \
    -w /workspace \
    -v "${ROOT_DIR}":/workspace \
    asciidoctor/docker-asciidoctor \
    bash -c " \
asciidoctor \
    --trace \
    --backend html5 \
    --attribute nofooter \
    --source-dir 'books' \
    --destination-dir 'dist' \
    'books/index.adoc' \
"


echo
echo "Build all books ..."
books=( $(cd "${ROOT_DIR}/books" && find . -maxdepth 1 -type d | sed '/^\.$/d; s|^\./||g') )
for book in "${books[@]}"; do
    echo "---------------------------------------------------"
    echo "  ${book}"
    echo "---------------------------------------------------"

    bash "${DIR}/asciidoctor-book.sh" "${ROOT_DIR}/books/${book}"
done
