#####################Provider###################
provider "aws" {
  region = "us-east-1"
}


###################RESOURCE################

resource "aws_s3_bucket" "b" {
  bucket = "nssp0101-bucket11"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

###################Upload################
# Upload an object
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.b.id
  key    = "30-2.jpeg"
  acl    = "public-read"  # or can be "public-read"
  source = "./30-2.jpeg"
  etag = filemd5("./30-2.jpeg")
}


#####################OUTPUT###############
output "s3-bucket-url" {
  value = "${formatlist(
    "%s/%s", 
    "https://${aws_s3_bucket.b.bucket_domain_name}",
    "${aws_s3_bucket_object.object.key}"
  )}"
}