provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source = "./modules/vpc"
  namePrefix = "${var.namePrefix}"
}

module "iam" {
  source = "./modules/iam"
  namePrefix = "${var.namePrefix}"
}

module "ecs" {
  source = "./modules/ecs"
  webServerTgArn = "${module.autoscale.webServerTgArn}"
  ecsServiceRole = "${module.iam.ecsServiceRole}"
  dockerImageTag = "${var.dockerImageTag}"
  countTasks = "${var.countTasks}"
  desiredCapacity = "${var.desiredCapacity}"
  namePrefix = "${var.namePrefix}"
  service_count = "${var.service_count}"
}
module "autoscale" {
  source = "./modules/asg-alb"
  sgAlb = "${module.vpc.sgAlb}"
  sgECS = "${module.vpc.sgECS}"
  vpcId = "${module.vpc.vpcId}"
  subnetIds = "${module.vpc.subnetIds}"
  ecsServiceRole = "${module.iam.ecsServiceRole}"
  ecsInstanceProfile = "${module.iam.ecsInstanceProfile}"
  ecs_cluster_name = "${module.ecs.ecs_cluster_name}"
  namePrefix = "${var.namePrefix}"
}