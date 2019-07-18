# Number of services to run
variable "service_count" {
  # default = 3
}


variable "dockerImageTag" {
  # default = "latest"
}

variable "countTasks" {
#  default = 3
}

variable "desiredCapacity" {
#  default = 3
  description = "No. of instances"
}

variable "namePrefix" {
#  default = "dev"
  description  = "Name prefix for this module"
}

variable "region" {
#  default = "us-west-2"
}
