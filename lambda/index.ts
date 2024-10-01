import * as AWS from 'aws-sdk'
import { v4 as uuidv4 } from 'uuid'

export const handler = async (req: any) => {
  console.log(`Received message: ${req}`);
  
  try {
    await sendSqsMessage(req)
    console.log('Message sent')
    return {
      statusCode: 200,
    }
  } catch (err) {
    const errorResponse = {
      statusCode: 500,
      body: {
        message: 'Error',
        data: JSON.stringify(err),
      },
    }
    console.error(errorResponse)
    return errorResponse
  }
}

const sendSqsMessage = async (body) => {
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