#!/bin/bash

if [[ -z "$1" ]] || [[ -z "$2" ]]; then
  echo "Error: two arguments (object prefix, bucket name) required."
  exit 1
fi

object_prefix="$1"
bucket="$2"

aws s3 cp . s3://${bucket}/${object_prefix}/ --recursive --exclude ".gitignore" --exclude ".git/*"

if [[ ! "$?" -eq 0 ]]; then
  echo "Error: s3 cp command failed. Check that sufficient IAM permissions are supplied."
  exit 1
fi

echo "s3://${bucket}/${object_prefix}" > output