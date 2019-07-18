data "template_file" "taskFileWebServer" {
  template = "${file("./modules/ecs/templates/taskdef.tpl")}"
  count = "${var.service_count}"
  vars = {
      webServerImage = "${element(var.docker, count.index)}:${var.dockerImageTag}"
      webServerName  = "${element(var.webServerName, count.index)}"
      hostPort       = "${element(var.hostPort, count.index)}"
  }
}
variable "docker" {
  default = ["nginx","httpd"]
}
variable "webServerName" {
  default = ["webServer1","webServer2"]
}


# "${element(aws_ecs_task_definition.*.arn, count.index)}"
