#!/bin/bash

object_prefix="$1"
bucket="$2"

aws s3 cp . s3://${bucket}/${object_prefix}/ --recursive --exclude ".gitignore" --exclude ".git/*" 2>&1 > /dev/null
echo "s3://${bucket}/${object_prefix}"