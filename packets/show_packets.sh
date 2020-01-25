#!/usr/bin/env bash

find . -name '*.pcapng' -print0 | 
    while IFS= read -r -d '' line; do
        tshark -r "$line" > $(basename "$line" .pcapng)
    done
