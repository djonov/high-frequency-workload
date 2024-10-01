resource "aws_sqs_queue" "my_queue" {
  name = "myQueue.fifo"
  fifo_queue                = true
  visibility_timeout_seconds = 30
  content_based_deduplication = true
  deduplication_scope       = "messageGroup"
  fifo_throughput_limit     = "perMessageGroupId"
}
