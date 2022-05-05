#!/bin/bash
set -e

IMAGE=fedora

TARGET=$(echo -n "<!-- BEGIN GENERATED SECTION: $IMAGE -->

| Name | Version | Notes |
| ---- | ------- | ----- |
| Docker | $(docker -v | cut -d' ' -f 3 | sed 's/.$//') |
| Git | $(git --version | cut -d' ' -f 3) |

<!-- END GENERATED SECTION: $IMAGE -->" | tr '\n' '\r')

echo "$TARGET"

README=$(cat ../README.md)

echo "$README" |
  tr '\n' '\r' |
  sed -e "s/<!-- BEGIN GENERATED SECTION: $IMAGE -->.*<!-- END GENERATED SECTION: $IMAGE -->/$TARGET/" |
  tr '\r' '\n' > ../README.md
