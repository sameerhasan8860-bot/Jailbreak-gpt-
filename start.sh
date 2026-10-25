#!/bin/bash

set -u

echo "EvilGPT Telegram Bot Starting..."

# Install dependencies
python3 -m pip install -r requirements.txt || exit 1

# Run bot for up to 5 hours 50 minutes
echo "Bot is starting..."
timeout --signal=TERM --kill-after=30s 21000s python3 -u main.py
BOT_STATUS=$?

echo "Bot process ended with status: $BOT_STATUS"
echo "Requesting next GitHub Actions run..."

# Trigger the next run
if [ -z "${GH_TOKEN:-}" ] || [ -z "${GITHUB_REPOSITORY:-}" ]; then
    echo "ERROR: GH_TOKEN or GITHUB_REPOSITORY is missing."
    exit 1
fi

curl --fail-with-body --silent --show-error \
  --request POST \
  --header "Authorization: Bearer ${GH_TOKEN}" \
  --header "Accept: application/vnd.github+json" \
  --header "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/dispatches" \
  --data '{"event_type":"restart_evil_bot"}' \
  || exit 1

echo "Next workflow dispatch request succeeded."
