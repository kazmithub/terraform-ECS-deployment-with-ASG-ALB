output "alb_dns_name" {
    value = "${aws_alb.mainALB.dns_name}"
}

output "webServerTgArn" {
  value = "${aws_alb_target_group.webServertg.*.arn}"
}
