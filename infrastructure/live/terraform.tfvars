terragrunt = {
  remote_state {
    backend = "s3"
    config {
      profile        = "made2591-terraform"
      bucket         = "made2591.terraform"
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = "eu-west-1"
      encrypt        = true
      dynamodb_table = "made2591-terraform"
      
      s3_bucket_tags = {
        Name = "terraform-s3bucket-state-lock",
        Description = "Terraform s3 bucket state lock for environment"
      }
      
      dynamodb_table_tags = {
        Name = "terraform-dynamodb-state-lock",
        Description = "Terraform dynamo DB state lock for environment"
      }

    }
  }

}