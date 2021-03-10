# s3-publish-action

This action publishes the current repository to a folder in S3.

## Usage

Add the following step to your workflow:

```yaml
    - id: test
        uses: Indellient/s3-publish-action@v0.1.2
        with:
          folder-name: 'master'
          bucket-name: ${{ secrets.bucket_name }}
          clear-folder: true
          exclusions: '.git/*,.gitignore,.github/*'
```

You will need to use this action in conjunction with the [configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials) action. For example:

```yaml
jobs:
  publish-repo-to-s3:
    runs-on: ubuntu-latest
    name: Publish repository to s3
    steps:
      - uses: actions/checkout@v2
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      - id: s3-publish 
        uses: Indellient/s3-publish-action@v0.1.2
        with:
          folder-name: 'master'
          bucket-name: ${{ secrets.bucket_name }}
          clear-folder: true
          exclusions: '.git/*,.gitignore,.github/*'
```

## IAM Permissions

You will need to make sure that the credentials supplied have the following policy at a minimum:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::test"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::test/*"]
    }
  ]
}
```

Where `test` in the policy syntax above is replaced with the name of the S3 bucket in question.