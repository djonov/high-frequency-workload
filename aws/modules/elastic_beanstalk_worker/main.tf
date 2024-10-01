resource "aws_iam_role" "elasticbeanstalk_worker_role" {
  name = "aws-elasticbeanstalk-ec2-role-v2"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "worker_role_policy" {
  role       = aws_iam_role.elasticbeanstalk_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_instance_profile" "elasticbeanstalk_profile" {
  name = "aws-elasticbeanstalk-ec2-profile"
  role = aws_iam_role.elasticbeanstalk_worker_role.name
}

resource "aws_elastic_beanstalk_application" "my_app" {
  name = "my-worker-app"
}

resource "aws_elastic_beanstalk_environment" "worker_env" {
  name                = "my-worker-env"
  application         = aws_elastic_beanstalk_application.my_app.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.2.0 running Node.js 18"

  tier = "Worker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.elasticbeanstalk_profile.name
  }
  
  setting {
    namespace = "aws:elasticbeanstalk:sqsd"
    name      = "WorkerQueueURL"
    value     = var.sqs_queue_url
  }
  
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "3"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }
}
