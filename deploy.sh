#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: $ENV_FILE not found."
  echo "Create it with:"
  echo "  echo 'FTP_PASSWORD=yourpassword' > .env"
  exit 1
fi

source "$ENV_FILE"

FTP_HOST="ftp.robotlearningbook.com"
FTP_USER="${FTP_USER:-robot308}"
FTP_PASS="${FTP_PASSWORD:?FTP_PASSWORD not set in .env}"
REMOTE_DIR="/public_html"
LOCAL_DIR="$SCRIPT_DIR/docs/_site"

echo "==> Building site..."
cd "$SCRIPT_DIR/docs"
bundle exec jekyll build
cd "$SCRIPT_DIR"

echo "==> Uploading to $FTP_HOST$REMOTE_DIR ..."
lftp -c "
  set ftp:ssl-allow yes
  set ssl:verify-certificate no
  open ftp://$FTP_USER:$FTP_PASS@$FTP_HOST
  mirror --reverse --delete --verbose \
    $LOCAL_DIR/ $REMOTE_DIR/
  bye
"

echo "==> Done. Visit https://robotlearningbook.com"
