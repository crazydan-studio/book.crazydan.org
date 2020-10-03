#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"


ROOT_DIR="$(cd "${DIR}/.." && pwd -P)"

book_dir="$(cd "$1" && pwd -P)"
if [[ ! -d "${book_dir}" || ! -f "${book_dir}/asciibook.yml" ]]; then
    echo "Usage: $0 <book dir>"
    exit 1
fi

book_name="$(basename "${book_dir}")"
book_dir="books/${book_name}"
book_dist="dist/${book_name}"

docker run --rm \
    --user $(id -u):$(id -g) \
    -w /workspace \
    -v "${DIR}/asciidoctor-entrypoint.sh":/build.sh \
    -v "${ROOT_DIR}":/workspace \
    asciidoctor/docker-asciidoctor \
    bash /build.sh "/workspace/${book_dir}" "/workspace/${book_dist}"
