#####################VARIABLE#################
variable "s3_bucket" {
    type = string
    default = "nssp-s3-bucket"
}

#####################Provider###################
provider "aws" {
  region = "us-east-1"
}

###################RESOURCE################
resource "aws_s3_bucket" "s3_b" {
  bucket = var.s3_bucket
  acl    = "private"
  versioning  {
    enabled = true
  }
  tags = {
        Name = "My bucket"
        Environment = "Dev"
    }
}

resource "aws_s3_bucket_policy" "s3_b_policy" {
  bucket = aws_s3_bucket.s3_b.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::nssp-s3-bucket/*",
      "Condition": {
         "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_object" "nssp_folder" {
    bucket = var.s3_bucket
    acl    = "private"
    key    = "devops_folder"
    source = "${path.module}/folder1/srini.txt"
    etag = "${filemd5("${path.module}/folder1/srini.txt")}"
}