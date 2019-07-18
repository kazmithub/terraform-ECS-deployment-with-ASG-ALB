variable "namePrefix" {
  default = "tf"
}

variable "subnetAZs" {
  description = "Subnet AZs, spereated by comma. "
  default = "a,b"
}

variable "awsRegion" {
  default = "us-west-1"
}

variable "count" {
  default = 3
}
