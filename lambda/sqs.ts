import * as AWS from 'aws-sdk'
import { v4 as uuidv4 } from 'uuid'

export const sendSqsMessage = async (body) => {
  AWS.config.update({
    accessKeyId: process.env.AWS_ACCESS_KEY,
    secretAccessKey: process.env.AWS_SECRET_KEY,
    region: process.env.AWS_REGION,
  })
  const sqs = new AWS.SQS()
  const params = {
    MessageBody: JSON.stringify({
      data: body,
    }),
    QueueUrl: process.env.SQS_QUEUE_URL,
    DelaySeconds: 0,
    MessageGroupId: uuidv4(),
  }
  await sqs.sendMessage(params).promise()
}