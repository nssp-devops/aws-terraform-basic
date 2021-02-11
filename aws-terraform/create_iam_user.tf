#####################VARIABLE#################
variable "user_list" {
    type = list(string)
    default = ["nick", "ssandy", "ppannu"]
}

variable "user_group" {
    type = string
    default = "devops3.0"
}
#####################Provider###################
provider "aws" {
  region = "us-east-1"
}

#####################Groups###################

resource "aws_iam_group" "user_group" {
    name = var.user_group
    path = "/system/"
}
###################RESOURCE################
resource "aws_iam_user" "user" {
    count = "${length(var.user_list)}"
    name = "${element(var.user_list,count.index )}"
    path = "/system/"
}

resource "aws_iam_group_policy_attachment" "aws_config_attach" {
  group = "S3bucketonly"
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess", 
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  ])
  policy_arn = each.value
}

resource "aws_iam_group_membership" "user_group" {
  name = "tf-testing-group-membership"
  users = var.user_list
  group = aws_iam_group.user_group.name
}

resource "aws_iam_group_membership" "existing_groups" {
  name = "exiting-group-membership"
  users = var.user_list
  group = "S3bucketonly"
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