output "sqs_queue_url" {
  value = aws_sqs_queue.my_queue.url
}