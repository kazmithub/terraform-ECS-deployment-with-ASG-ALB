provider "aws" {
  region = "${var.awsRegion}"
}

variable "service_count" {}


variable "namePrefix" {
  default = "tf"
  description  ="Name prefix for this module"
}

variable "awsRegion" {
  default = "us-west-1"
}
variable "ecsImage" {
  default = "ami-02507631a9f7bc956"
}

variable "dockerImageTag" {
  default = "latest"
}

variable "countTasks" {
  default  =2
}

variable "desiredCapacity" {
  default = 2
  description = "No. of instances"
}

variable "minHealthPercentage" {
  default = "50"
}

variable "nameTaskDef" {
  type = "list"
  default = ["v1","v2"]
}
variable "hostPort" {
  type = "list"
  default = ["80","8080"]
}
variable "keyName" {
  default = "Kazmi-NC"
}

variable "isntanceType" {
  default = "t2.micro"
}


# iam module's outputs
variable "ecsServiceRole" {}

# asg module outputs

variable "webServerTgArn" {}

