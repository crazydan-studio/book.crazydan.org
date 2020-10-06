#!/bin/bash


book_dir="$1"
book_dist="$2"

rm -rf "${book_dist}"

langs=( $(cd "${book_dir}/src" && find . -maxdepth 1 -type d | sed '/^\.$/d; s|^\./||g') )
for lang in "${langs[@]}"; do
    mkdir -p "${book_dist}/${lang}"
    if [ -e "${book_dir}/theme/html/icon.png" ]; then
        cp -f "${book_dir}/theme/html/icon.png" "${book_dist}/${lang}"
    fi

    echo "  Create html for ${lang} ..."
    asciidoctor \
        --trace \
        --backend html5 \
        --source-dir "${book_dir}/src/${lang}" \
        --template-dir "${book_dir}/templates" \
        --destination-dir "${book_dist}/${lang}" \
        "${book_dir}/src/${lang}/book.adoc" \
    && mv "${book_dist}/${lang}/book.html" "${book_dist}/${lang}/index.html"

    # echo "  Create pdf for ${lang} ..."
    # asciidoctor \
    #     --trace \
    #     --require asciidoctor-pdf \
    #     --backend pdf \
    #     --source-dir "${book_dir}/src/${lang}" \
    #     --template-dir "${book_dir}/templates" \
    #     --destination-dir "${book_dist}/${lang}" \
    #     "${book_dir}/src/${lang}/book.adoc" \
    # && mv "${book_dist}/${lang}/book.pdf" "${book_dist}/pdf/${lang}.pdf"
done
