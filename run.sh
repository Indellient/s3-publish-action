#!/bin/bash

if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
  echo "Error: three arguments (object prefix, bucket name, clear folder true/false) required. Got: ${@:1}"
  exit 1
fi

if [[ "$3" != "true" ]] && [[ "$3" != "false" ]]; then
  echo "Error: third argument (clearing folder true/false) must be one of 'true', 'false'. Got: $3"
  exit 1
fi

bucket_folder="$1"
bucket="$2"
clear_folder="$3"

if [[ "$clear_folder" == "true" ]]; then
  echo "Clearing s3://${bucket}/${bucket_folder}..."
  aws s3 rm s3://${bucket}/${bucket_folder} --recursive
fi

echo "Copying files... to s3://${bucket}/${bucket_folder}..."
aws s3 cp . s3://${bucket}/${bucket_folder}/ --recursive --exclude ".gitignore" --exclude ".git/*"

if [[ ! "$?" -eq 0 ]]; then
  echo "Error: s3 cp command failed. Check that sufficient IAM permissions are supplied."
  exit 1
fi

echo "Files successfully copied to s3://${bucket}/${bucket_folder}"

echo "s3://${bucket}/${bucket_folder}" > output