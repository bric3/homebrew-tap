#!/usr/bin/env bash
set -euo pipefail

: "${TAP_NAME:?TAP_NAME is required}"
: "${GITHUB_OUTPUT:?GITHUB_OUTPUT is required}"
: "${GITHUB_STEP_SUMMARY:?GITHUB_STEP_SUMMARY is required}"

shopt -s nullglob
temporary_directory=$(mktemp -d)
updated=0
skipped=0
up_to_date=0

report() {
  printf '| `%s` | %s | %s | %s |\n' "$1" "$2" "$3" "$4" >> "$GITHUB_STEP_SUMMARY"
}

update_package() {
  local type=$1
  local file=$2
  local name qualified json log current latest outdated backup
  local -a bump
  name=$(basename "$file" .rb)
  qualified="$TAP_NAME/$name"
  json="$temporary_directory/$type-$name.json"
  log="$temporary_directory/$type-$name.log"
  backup="$temporary_directory/$type-$name.rb"

  printf '\n==> Checking %s (%s)\n' "$qualified" "$type"
  if ! brew livecheck --quiet --json "--$type" "$qualified" > "$json" 2> "$log"; then
    sed 's/^/  /' "$log"
    report "$name" "$type" "Skipped" "livecheck failed"
    skipped=$((skipped + 1))
    return
  fi
  if [[ -s "$log" ]]; then
    sed 's/^/  /' "$log"
  fi

  if ! current=$(jq -er '.[0].version.current | strings' "$json") \
      || ! latest=$(jq -er '.[0].version.latest | strings' "$json"); then
    report "$name" "$type" "Skipped" "invalid livecheck output"
    skipped=$((skipped + 1))
    return
  fi
  outdated=$(jq -r '.[0].version.outdated // false' "$json")
  if [[ ! "$current" =~ ^[0-9A-Za-z][0-9A-Za-z._,+-]*$ \
      || ! "$latest" =~ ^[0-9A-Za-z][0-9A-Za-z._,+-]*$ ]]; then
    report "$name" "$type" "Skipped" "unsafe version from livecheck"
    skipped=$((skipped + 1))
    return
  fi
  if [[ "$outdated" != true ]]; then
    report "$name" "$type" "Up to date" "$current"
    up_to_date=$((up_to_date + 1))
    return
  fi

  if ! cp "$file" "$backup"; then
    report "$name" "$type" "Skipped" "backup failed"
    skipped=$((skipped + 1))
    return
  fi
  if [[ "$type" == formula ]]; then
    bump=(brew bump-formula-pr --write-only --no-audit "--version=$latest" "$qualified")
  else
    bump=(brew bump-cask-pr --write-only --no-audit --no-style "--version=$latest" "$qualified")
  fi

  if ! "${bump[@]}" > "$log" 2>&1; then
    sed 's/^/  /' "$log"
    if ! cp "$backup" "$file"; then
      echo "Failed to restore $file" >&2
      exit 1
    fi
    report "$name" "$type" "Skipped" "bump failed"
    skipped=$((skipped + 1))
    return
  fi
  sed 's/^/  /' "$log"

  if cmp -s "$backup" "$file"; then
    report "$name" "$type" "Skipped" "bump made no changes"
    skipped=$((skipped + 1))
    return
  fi

  report "$name" "$type" "Updated" "$current -> $latest"
  updated=$((updated + 1))
}

printf '%s\n\n' '## Package updates' > "$GITHUB_STEP_SUMMARY"
printf '%s\n' '| Package | Type | Result | Details |' >> "$GITHUB_STEP_SUMMARY"
printf '%s\n' '|:--------|:-----|:-------|:--------|' >> "$GITHUB_STEP_SUMMARY"

for file in ./*.rb Formula/*.rb HomebrewFormula/*.rb; do
  update_package formula "$file"
done
for file in Casks/*.rb; do
  update_package cask "$file"
done

printf '\nUpdated: %d; up to date: %d; skipped: %d.\n' \
  "$updated" "$up_to_date" "$skipped" >> "$GITHUB_STEP_SUMMARY"

if (( updated > 0 )); then
  printf 'updated=true\n' >> "$GITHUB_OUTPUT"
else
  printf 'updated=false\n' >> "$GITHUB_OUTPUT"
fi
