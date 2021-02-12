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
    bucket = aws_s3_bucket.s3_b.id
    acl    = "public-read"
    key    = "srini.txt"
    source = "./folder1/srini.txt"
    etag = filemd5("./folder1/srini.txt")
}

output "aws_s3_bucket_url"  {
  value = "${formatlist(
    "%s/%s", 
    "https://${aws_s3_bucket.s3_b.bucket_domain_name}",
    "${aws_s3_bucket_object.nssp_folder.key}"
  )}"
}