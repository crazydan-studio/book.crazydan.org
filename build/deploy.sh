#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd "${DIR}/.." && pwd -P)"


repo=github
branch=site-dist

echo "Clean ..." \
    && git checkout ${branch} \
    && git pull ${repo} ${branch} \
    && git reset --hard ${repo}/${branch} \
    && git clean -d -f \
    && git rm -r dist

echo "Build ..." \
    && bash "${DIR}/asciidoctor.sh" \
    && echo "Commit ..." \
    && git add "${ROOT_DIR}/dist" \
    && git commit -m "Update dist" \
    && git push ${repo} ${branch}

echo "Back to master ..."
git checkout master
