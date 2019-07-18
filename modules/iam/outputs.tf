output "ecsInstanceProfile" {
  value = "${aws_iam_instance_profile.ecsInstanceProfile.arn}"
}

output "ecsServiceRole" {
  value = "${aws_iam_role.ecsServiceRole.arn}"
}
