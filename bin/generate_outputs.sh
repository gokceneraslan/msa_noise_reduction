#!/bin/bash

set -e

for d in inputs/*
do
    mkdir -p ${d/inputs/outputs}

    for f in ${d}/*.msl
    do
        filename=`basename $f`
        outfile=${f/inputs/outputs}

        echo "Processing $f..."
        ./reduce_noise -i "$f" -o "$outfile" -d "${outfile/msl/tree}" -g "${f/msl/tree}" -R svg
    done
done
