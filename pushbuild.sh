#!/usr/bin/env bash

upload=

appveyor="appveyor.yml"
travis=".travis.yml"

while getopts 'u' OPTION; do
    case $OPTION in
        u) upload=1
           ;;
        ?) printf "Usage: %s: [-u] <commit>\n" $(basename $0) >&2
           exit 2
           ;;
    esac
done
shift $(($OPTIND - 1))

if [ $# -ne 1 ]; then
    printf "Usage: %s: [-u] <commit>\n" $(basename $0) >&2
    exit 2
fi

commit="$1"

git diff-index --quiet --cached HEAD
if (( $? )); then
    echo "Error: index has uncommitted changes."
    exit 1
fi

git diff-files --quiet
if (( $? )); then
    echo "Error: working tree has uncommitted changes."
    exit 1
fi

if [ "$upload" ]; then
    sed -i "s/UPLOAD_TO_PYPI: \w\+/UPLOAD_TO_PYPI: true/" $appveyor
    sed -i "s/UPLOAD_TO_PYPI=\w\+/UPLOAD_TO_PYPI=true/" $travis
else
    sed -i "s/UPLOAD_TO_PYPI: \w\+/UPLOAD_TO_PYPI: false/" $appveyor
    sed -i "s/UPLOAD_TO_PYPI=\w\+/UPLOAD_TO_PYPI=false/" $travis
fi

sed -i "s/BUILD_COMMIT: \w\+/BUILD_COMMIT: ${commit}/" $appveyor
sed -i "s/BUILD_COMMIT=\w\+/BUILD_COMMIT=${commit}/" $travis

git add $appveyor $travis
git commit -m "Build $commit"
git push

if [ "$upload" ]; then
    sed -i "s/UPLOAD_TO_PYPI: \w\+/UPLOAD_TO_PYPI: false/" $appveyor
    sed -i "s/UPLOAD_TO_PYPI=\w\+/UPLOAD_TO_PYPI=false/" $travis
    git add $appveyor $travis
    git commit -m "Reset UPLOAD_TO_PYPI to false." -m "[skip ci]"
    git push
fi
