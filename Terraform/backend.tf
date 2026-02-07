terraform {
  backend "s3" {
    bucket         = "bedrock-terraform-state-9fhk4mee"  
    key            = "bedrock/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bedrock-terraform-locks"
    encrypt        = true
  }
}