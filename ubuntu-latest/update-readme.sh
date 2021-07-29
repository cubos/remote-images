#!/bin/bash
set -e

. /etc/profile

IMAGE=ubuntu-latest

TARGET=$(echo -n "<!-- BEGIN GENERATED SECTION: $IMAGE -->

| Name | Version | Notes |
| ---- | ------- | ----- |
| .NET SDK | $(dotnet --list-sdks | cut -d' ' -f 1 | tr '\n' ',' | sed 's/,$/\n/' | sed 's/,/<br>/g') (default) |
| Dart | $(dart --version 2>&1 | cut -d' ' -f 4) |
| Docker | $(docker -v | cut -d' ' -f 3 | sed 's/.$//') |
| Flutter | $(flutter --version | head -n1 | cut -d' ' -f 2) |
| GCC | $(gcc --version | head -n1 | cut -d' ' -f 4) |
| Git | $(git --version | cut -d' ' -f 3) |
| Go | $(go version | cut -d' ' -f 3 | cut -c 3-) |
| Google Cloud SDK | $(gcloud --version | head -n 1 | cut -d' ' -f 4) |
| kubectl | $(kubectl version --client -o json | jq -r ".clientVersion.gitVersion" | cut -c 2-) |
| Node.js | $(nvm use 12 >/dev/null && node -v | cut -c 2-)<br>$(nvm use 14 >/dev/null && node -v | cut -c 2-) (default)<br>$(nvm use 16 >/dev/null && node -v | cut -c 2-) | Select with \`nvm\` |
| Python | $(python --version 2>&1 | cut -d' ' -f2)<br>$(python3 --version 2>&1 | cut -d' ' -f2) | Use \`python\` or \`python3\` |
| Rust | $(rustc --version | cut -d' ' -f 2) |
| Terraform | $(terraform -v | head -n1 | cut -d'v' -f 2) |

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
