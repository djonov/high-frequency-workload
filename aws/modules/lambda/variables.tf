variable "sqs_queue_url" {
  description = "The URL of the SQS queue"
  type        = string
}

variable "api_gateway_execution_arn" {
    description = "The Execution ARN of API Gateway"
  type        = string
}