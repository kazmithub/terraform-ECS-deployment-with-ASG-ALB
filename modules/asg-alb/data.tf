data "template_file" "autoScaleTemplate" {
  template = "${file("./modules/asg-alb/templates/autoScaleUserdata.tpl")}"
  vars = {
      ecs_cluster = "${var.ecs_cluster_name}"
  }
}