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
rm -rf "${book_dist}"

book_dist="${book_dist}/dist"
# --theme-dir '/asciibook/${book_dir}/theme'
docker run --rm \
    --user $(id -u):$(id -g) \
    -w /asciibook \
    -v "${ROOT_DIR}":/asciibook \
    asciibook/asciibook:0.0.3-cjk-sc \
    bash -c " \
        cd '/asciibook/${book_dir}/src' && \
        asciibook build \
            --format html \
            --template-dir '/asciibook/${book_dir}/templates' \
            --page-level 3 \
            --dest-dir '/asciibook/${book_dist}' \
            index.adoc && \
        cd '/asciibook/${book_dir}/src/en' && \
        asciibook build \
            --format html,pdf \
            --template-dir '/asciibook/${book_dir}/templates' \
            --page-level 3 \
            --dest-dir '/asciibook/${book_dist}/en' \
            book.adoc && \
        cd '/asciibook/${book_dir}/src/zh' && \
        asciibook build \
            --format html,pdf \
            --template-dir '/asciibook/${book_dir}/templates' \
            --page-level 3 \
            --dest-dir '/asciibook/${book_dist}/zh' \
            book.adoc
    "


book_dir="${ROOT_DIR}/books/${book_name}"
book_dist="${ROOT_DIR}/dist/${book_name}"

cp "${book_dir}/theme/html/icon.png" "${book_dist}"
mv "${book_dist}/dist/html"/* "${book_dist}/" || echo "  Ignore it."

rm -rf "${book_dist}/en" "${book_dist}/zh"
mv "${book_dist}/dist/en/html" "${book_dist}/en" || echo "  Ignore it."
mv "${book_dist}/dist/zh/html" "${book_dist}/zh" || echo "  Ignore it."
cp -f "${book_dir}/theme/html/icon.png" "${book_dist}/en" || echo "  Ignore it."
cp -f "${book_dir}/theme/html/icon.png" "${book_dist}/zh" || echo "  Ignore it."

mkdir "${book_dist}/pdf"
mv "${book_dist}/dist/en/pdf/book.pdf" "${book_dist}/pdf/en.pdf" || echo "  Ignore it."
mv "${book_dist}/dist/zh/pdf/book.pdf" "${book_dist}/pdf/zh.pdf" || echo "  Ignore it."

rm -rf mv "${book_dist}/dist"
