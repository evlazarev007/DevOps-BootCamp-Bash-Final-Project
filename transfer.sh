#!/bin/bash

readonly currentVersion="0.0.1"

# Function for upload files
upload()
{
  for file in "$@"; do
    echo "Uploading $file"
    response=$(curl --progress-bar --upload-file "$file" "https://transfer.sh/$file")
    echo "Transfer File URL: ""$response"
  done;
}

# Function for download single file
singleDowload () {
  local path="$1"
  local id="$2"
  local file="$3"
  if [[ ! -d "$path"  ]]; then
    mkdir -p "$path"
  fi
  echo "Downloading $file"
  curl --progress-bar "https://transfer.sh/$id/$file" -o "$path/$file"
  if [[ -f "$path/$file" ]]; then
    printDownloadResponse
  fi
}

# Function for returning the result of downloading
printDownloadResponse () {
  echo "Success!"
}

# Function for showing help
help () {
  cat << EOF
  Description: Bash tool to transfer files from the command line.
  Usage:
    -d Download single file
    -h Show the help
    -v Get the tool version
  Examples:
  ./transfer.sh test.txt test2.txt - upload files
  ./transfer.sh -d ./test Mij6ca test.txt - download file
EOF
}

# Check incoming paramters. If exist then upload runs, else help shows
main () {
if [[ -f "$1"  ]]; then
  upload "$@"
elif [[ "$#" -eq 0 ]]; then
  help
fi
}

# Flags functionality
while getopts "dvh" arg; do
case "${arg}" in
  d)
    path="$2"
    id="$3"
    file="$4"
    singleDowload "$path" "$id" "$file" 
  ;;
  v)
    echo "$currentVersion"
  ;;
  h)
    help
  ;;
  *) echo "Invalid flag"
  ;;
esac
done

main "$@"
