#!/bin/bash
set -e

. /etc/profile

IMAGE=fedora

TARGET=$(echo -n "<!-- BEGIN GENERATED SECTION: $IMAGE -->

| Name | Version | Notes |
| ---- | ------- | ----- |
| Docker | $(docker -v | cut -d' ' -f 3 | sed 's/.$//') |

<!-- END GENERATED SECTION: $IMAGE -->" | tr '\n' '\r')

echo "$TARGET"

README=$(cat ../README.md)

echo "$README" |
  tr '\n' '\r' |
  sed -e "s/<!-- BEGIN GENERATED SECTION: $IMAGE -->.*<!-- END GENERATED SECTION: $IMAGE -->/$TARGET/" |
  tr '\r' '\n' > ../README.md

[ -z "$(git diff ../README.md)" ] && exit

UPDATED_PACKAGES=$(
  git diff ../README.md |
  grep "^+|" |
  cut -d'|' -f 2 |
  grep -v -- "----" |
  grep -v Name |
  sed 's/^ *//;s/ *$//' |
  head -c -1 |
  tr '\n' ',' |
  sed -e 's/,/, /g'
)

git config --global user.name ci
git config --global user.email ci@example.com
git add ../README.md
git commit -m "update $IMAGE: $UPDATED_PACKAGES"
