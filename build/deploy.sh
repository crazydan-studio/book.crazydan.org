#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd "${DIR}/.." && pwd -P)"


repo=github
branch=site-dist

pushd "${ROOT_DIR}"
    echo "Clean for ${branch} ..." \
        && git checkout ${branch} \
        && git pull ${repo} ${branch} \
        && git reset --hard ${repo}/${branch} \
        && git clean -d -f \
        && git merge origin/master -m "merge from origin/master" \
        && git rm -r "dist"

    echo "Build for ${branch} ..." \
        && bash "${DIR}/asciidoctor.sh" \
        && echo "Commit ..." \
        && git add "dist" \
        && git commit -m "Update dist" \
        && git push ${repo} ${branch}

    echo "Back to master ..."
    git checkout master
popd
