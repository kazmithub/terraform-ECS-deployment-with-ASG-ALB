provider "aws" {
  region = "${var.awsRegion}"
}


variable "namePrefix" {
  default = "tf"
  description  ="Name prefix for this module"
}

variable "awsRegion" {
  default = "us-west-1"
}

variable "ecsImage" {
  default = "ami-00303cd65a37d033b"
}

variable "dockerImage" {
  default = "nginx"
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

variable "keyName" {
  default = "Kazmi-NC"
}

variable "isntanceType" {
  default = "t2.micro"
}



# vpc module's outputs

variable "sgAlb" {}
variable "sgECS" {}
variable "vpcId" {}
variable "subnetIds" {}

# iam module's outputs

variable "ecsInstanceProfile" {}
variable "ecsServiceRole" {}


# ecs module outputs

variable "ecs_cluster_name" {}

variable "listenerPort" {
  type = "list"
  default = ["80","8080"]
}






