# CLuster Definition
resource "aws_ecs_cluster" "webCluster" {
  name = "${var.namePrefix}-WebServer-Cluster"
}
# ECS Task definition
resource "aws_ecs_task_definition" "taskDef" {
  family = "${element(var.nameTaskDef, count.index)}-taskDefintion"
  count = "${var.service_count}"
  container_definitions = "${data.template_file.taskFileWebServer[count.index].rendered}"  
  # lifecycle {
  #   create_before_destroy = true
  # }
}

# ECS Service Definition
resource "aws_ecs_service" "webServerService" {
  count = "${var.service_count}"
  name = "${element(var.nameTaskDef, count.index)}-WebServer-Service"
  cluster = "${aws_ecs_cluster.webCluster.id}"
  task_definition = "${aws_ecs_task_definition.taskDef[count.index].arn}"
  desired_count = "${var.countTasks}"
  deployment_minimum_healthy_percent = "${var.minHealthPercentage}"
  iam_role = "${var.ecsServiceRole}"

  load_balancer {
    target_group_arn = "${element(var.webServerTgArn, count.index)}"
    container_name = "${element(var.webServerName, count.index)}"
    container_port = 80
  }
    lifecycle {
     create_before_destroy = true
 }
}

