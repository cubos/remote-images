#!/bin/bash

IMAGE=ubuntu-latest

TARGET=$(echo -n "<!-- BEGIN GENERATED SECTION: $IMAGE -->

| Name | Version |
| ---- | ------- |
| Go | $(/usr/local/go/bin/go version | cut -d' ' -f 3 | cut -c 3-) |
| Docker | $(docker -v | cut -d' ' -f 3 | sed 's/.$//') |
| Terraform | $(terraform -v | head -n1 | cut -d'v' -f 2) |

<!-- END GENERATED SECTION: $IMAGE -->" | tr '\n' '\r')

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

git config --global user.name github-actions
git config --global user.email github-actions@example.com
git add ../README.md
git commit -m "chore: Update $IMAGE: $UPDATED_PACKAGES"
