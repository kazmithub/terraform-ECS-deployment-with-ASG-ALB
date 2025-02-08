output "sgAlb" {
  value = "${aws_security_group.sgAlb.id}"
}

output "sgECS" {
  value = "${aws_security_group.sgECS.id}"
}

output "vpcId" {
  value = "${aws_vpc.mainVPC.id}"
}

output "subnetIds" {
  value = "${join(",", aws_subnet.subnet.*.id)}"
}



