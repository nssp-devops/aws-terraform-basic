users = [
   "user1" : [ "arn:aws:iam::9779267977264588:group/S3bucketonly","" ]
   "user2": [ "arn:aws:iam::9977267977264599:group/S3bucketonly" ],
   "user3": [ "arn:aws:iam::9928867977264588:group/S3bucketonly" ]
]



resource "aws_iam_user" "list" {
  for_each      = var.users
  name          = each.key
  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "list" {
  for_each   = var.users
  user       = aws_iam_user[each.key].name
  policy_arn = each.value
}
