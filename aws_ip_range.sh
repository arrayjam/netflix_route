#!/bin/sh

curl https://ip-ranges.amazonaws.com/ip-ranges.json | jq --raw-output ".prefixes[].ip_prefix" | sort | uniq
