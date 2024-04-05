#!/bin/sh

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <name>"
    echo "       $0 step-certificates"
    exit 1
fi

function require() {
    for cmd in $@;
    do 
        if ! command -v $cmd &> /dev/null
        then
            echo "$cmd is required"
            exit 1
        fi
    done
}

require yq git helm

# Grab version from chart
version=$(yq .version ./$1/Chart.yaml)

# Build package
helm package ./$1

# Push it to gh-pages branch rebuilding the index
git checkout gh-pages
git pull origin gh-pages
git add "$1-$version.tgz"
mkdir new-charts
cp "$1-$version.tgz" new-charts/
helm repo index --merge index.yaml --url https://smallstep.github.io/helm-charts/ new-charts
cp new-charts/index.yaml .
rm -rf new-charts
git diff
echo "Press enter to continue."
read
git commit -a -m "Add $1-$version.tgz"
git push origin gh-pages
git checkout master