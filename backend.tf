terraform {
  backend "s3" {
    bucket = "tflock"
    key    = "terraform.tfstate"
    region = "us-west-1"
    dynamodb_table = "tf-lock"
  }
}


resource "aws_dynamodb_table" "backendLock" {
   name = "tf-lock"
   hash_key = "LockID"
   read_capacity = 5
   write_capacity = 5
   
   lifecycle{
     prevent_destroy = true
   }
   attribute {
     name = "LockID"
     type = "S"
   }
}