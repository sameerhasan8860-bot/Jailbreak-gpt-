#!/bin/bash

# Auto-restart setup — 5h 50m = 21000 seconds
echo "🔥 EvilGPT Telegram Bot Starting... (21000s timeout)"

# Install dependencies
python3 -m pip install -r requirements.txt

# Run bot with timeout
timeout 21000 python3 main.py &

# Wait for it to be killed by timeout
wait $!

echo "💀 Old session ending... Spawning new GitHub Action..."

# Use GitHub Actions self-trigger via repo dispatch
curl -X POST \
  -H "Authorization: Bearer ${{ secrets.GITHUB_TOKEN }}" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/YOUR_USERNAME/YOUR_REPO/dispatches \
  -d '{
    "event_type": "restart_evil_bot",
    "client_payload": {
      "ref": "main"
    }
  }'

echo "🚀 New runner dispatched. Old one will die."
