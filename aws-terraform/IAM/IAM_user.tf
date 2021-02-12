#####################VARIABLE#################
variable "user_list" {
    description = "account names"
    type = list(string)
    default = ["dhruva", "dakshya", "bhavya"]
}

variable "user_group" {
    type = string
    default = "devops3.0"
}
variable "iam_policy_arn" {
  description = "IAM Policy to be attached to group"
  type = "list"
  default = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess",
             "arn:aws:iam::aws:policy/AmazonS3FullAccess",
             "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"]
} 
#####################Provider###################
provider "aws" {    
  region = "us-east-1"
}

#####################Groups###################

resource "aws_iam_group" "user_group" {
    name = var.user_group
    path = "/"
}
###################RESOURCE################
resource "aws_iam_user" "user" {
    count = "${length(var.user_list)}"
    name = "${element(var.user_list,count.index )}"
    path = "/"
}

resource "aws_iam_group_membership" "user_group1" {
  name = "tf-testing-group-membership1"
  users = var.user_list
  group = aws_iam_group.user_group.name
}
resource "aws_iam_group_membership" "user_group2" {
  name = "tf-testing-group-membership2"
  users = var.user_list
  group = "S3bucketonly"
}
resource "aws_iam_group_policy_attachment" "policy-attachment"{
  group = "S3bucketonly"
  count = "${length(var.iam_policy_arn)}"
  policy_arn = "${element(var.iam_policy_arn,count.index )}"
  
}


resource "aws_iam_user_policy_attachment" "AmazonS3OutpostsFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3OutpostsFullAccess"
  count = "${length(var.user_list)}"
  user = "${element(var.user_list,count.index )}"

  depends_on = [
      aws_iam_user.user,
  ]
}

#####################OUTPUT###############
output "user_arn" {
    value = "${aws_iam_user.user.*.arn}"  
}