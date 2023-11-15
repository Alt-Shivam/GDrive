#!/bin/bash

# Function to extract the file ID from a Google Drive sharing link
extract_file_id() {
  local file_url="$1"
  echo "$file_url" | sed -n 's/.*\/\([^/]*\)\?\/[^/]*$/\1/p'
}

# Function to download the file
download_google_drive_file() {
  local file_url="$1"

  # Extract the file ID from the URL
  local file_id=$(extract_file_id "$file_url")

  if [ -z "$file_id" ]; then
    echo "Error: Invalid Google Drive URL"
    exit 1
  fi

  # Use wget to download the file
  wget --load-cookies /tmp/cookies.txt \
       "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://drive.google.com/file/d/$file_id/view?usp=sharing" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$file_id" \
       -O "$file_id"

  # Clean up temporary cookies file
  rm -rf /tmp/cookies.txt
}

# Check if the user provided a URL
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <Google Drive URL>"
  exit 1
fi

# Call the download function with the provided URL
download_google_drive_file "$1"
