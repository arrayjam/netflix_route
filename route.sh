#!/bin/sh
# AWS IPs can be found via https://ip-ranges.amazonaws.com/ip-ranges.json

NETFLIX_INTERFACE="ppp0"
RANGES_DIR="ranges"

function main {
  if [[ $(id -u ) -ne 0 ]]; then
    echo "Must be run as root for route to work" >&2
    exit 1
  fi

  if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 [interface]" >&2
    exit 1
  fi

  if [[ ! -d "$RANGES_DIR" ]]; then
    mkdir $RANGES_DIR
  fi

  if [[ "$1" -eq "$NETFLIX_INTERFACE" ]]; then
    route_aws
  fi
}

function route_aws {
  aws_filename="$RANGES_DIR/aws"
  if [[ -f "$aws_filename" ]]; then
    while read net; do
      route_ip $net $NETFLIX_INTERFACE
    done < $aws_filename
  else
    sh aws_ip_range.sh > $aws_filename
    route_aws
  fi
}

function route_ip {
  route_opts="-net $1 -interface $2"
  get=$(route -n get $route_opts 2>&1)

  # Don't try to set a route again
  if [[ "$get" == *"not in table"* ]]; then
    route -n add $route_opts
  fi
}

main "$@"
