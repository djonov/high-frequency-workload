provider "aws" {
  region = "eu-central-1" # or your preferred region
}

# Define Terraform state backend (optional)
terraform {
  backend "s3" {
    bucket = "research-terraform-bucket"
    key    = "my-app/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "api_gateway" {
  source = "./modules/api_gateway"

  # Pass Lambda ARN to API Gateway
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
}

module "lambda" {
  source = "./modules/lambda"

  # Pass SQS Queue URL to Lambda
  sqs_queue_url = module.sqs.sqs_queue_url

  # Pass API Gateway Execution ARN
  api_gateway_execution_arn = module.api_gateway.execution_arn
}

module "sqs" {
  source = "./modules/sqs"
}

module "elastic_beanstalk_worker" {
  source = "./modules/elastic_beanstalk_worker"

  # Pass SQS Queue URL to Elastic Beanstalk
  sqs_queue_url = module.sqs.sqs_queue_url
}

module "sagemaker" {
  source = "./modules/sagemaker"
}

module "rds" {
  source = "./modules/rds"
}
