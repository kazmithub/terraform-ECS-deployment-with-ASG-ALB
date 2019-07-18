### AUTO_SCALING_GROUP ###

resource "aws_launch_configuration" "webServerLC" {
  instance_type = "${var.isntanceType}"
  image_id = "${var.ecsImage}"
  user_data = "${data.template_file.autoScaleTemplate.rendered}"
  key_name = "${var.keyName}"
  iam_instance_profile = "${var.ecsInstanceProfile}"
  security_groups = ["${var.sgECS}"]
  associate_public_ip_address = true

  lifecycle {
      create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "webServerASG" {
  name = "${var.namePrefix}-WebServer-AutoScalingGroup"
  max_size = 5
  min_size = 0
  desired_capacity = "${var.desiredCapacity}"
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.webServerLC.name}"
  vpc_zone_identifier = "${compact(split(",", var.subnetIds))}"

  tag {
      key = "Name"
      value = "${var.namePrefix}-WebServer-AutoScalingGroup"
      propagate_at_launch = true
  }

  lifecycle {
      create_before_destroy = true
  }
}

### LOAD BALANCER ###
resource "aws_alb" "mainALB" {
  load_balancer_type = "application"
  lifecycle { create_before_destroy = true }
  name = "${var.namePrefix}-webServer-alb"
  subnets = "${compact(split(",", var.subnetIds))}"
  security_groups = ["${var.sgAlb}"]
  idle_timeout = 400
  tags = {
        Name = "${var.namePrefix}_webServer_alb"
  }
}

resource "aws_alb_target_group" "webServertg" {
  count = "2"
  name                 = "${var.namePrefix}-webServer-tg-${count.index}"
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = "${var.vpcId}"

  deregistration_delay = 180

  health_check {
    interval            = "60"
    path                = "/"
    port                = "80"
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    timeout             = "5"
    protocol            = "HTTP"
  }
  tags = {
        Name = "${var.namePrefix}-webServertg-${count.index+1}"
  }
  depends_on = ["aws_alb.mainALB"]
}


resource "aws_alb_listener" "frontendHttp" {
  load_balancer_arn = "${aws_alb.mainALB.arn}"
  count = "2"
  port              = "${element(var.listenerPort, count.index)}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.webServertg[count.index].arn}"
    type             = "forward"
  }

  depends_on = ["aws_alb.mainALB"]
}
