# Roles and Policy

data "aws_iam_policy_document" "assume_role_policy" {
    version = "2012-10-17"
    statement {
      actions = ["sts:AssumeRole"]
      effect = "Allow"
      sid = ""

      principals {
        type = "Service"
        identifiers = ["ecs-tasks.amazonaws.com"]
      }
    }
}

resource "aws_iam_role" "TaskExecRole" {
  name = "${var.app_name}-${var.env}-TaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "ecs_task_exec_role" {
  name_prefix = "ecs_iam_role_policy"
  role = aws_iam_role.TaskExecRole.id
  policy = data.template_file.ecs_service_policy.rendered
}

# resource "aws_iam_role_policy_attachment" "TaskRolePolicy" {
#   role = aws_iam_role.TaskExecRole.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
# }

data "template_file" "ecs_service_policy" {
  template = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe",
        "ec2:DescribeInstances"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "ssm:GetParametersByPath"
      ],
      "Resource": [
        "arn:aws:ssm:*:*:parameter/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "arn:aws:secretsmanager:*:*:secret:*"
      ]
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
         "kms:ListKeys",
         "kms:ListAliases",
         "kms:Describe*",
         "kms:Decrypt"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# added 12.11
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.app_name}-${var.env}-TaskRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_task_role" {
    name   = "${var.app_name}-${var.env}-TaskRole"
  role   = aws_iam_role.ecs_task_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

###### Resources 

resource "aws_ecs_cluster" "test_cluster" {
  name = "${var.app_name}-${var.env}-cluster"
}

locals {
  image = format("%s:%s", var.aws_ecr_repository_url, var.image_tag)
}

resource "aws_ecs_task_definition" "task-definition" {
  family = "${var.app_name}-${var.env}-task"
  execution_role_arn = aws_iam_role.TaskExecRole.arn
  task_role_arn = aws_iam_role.ecs_task_role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "1024"
  memory = "2048"
  container_definitions = jsonencode([
    {
        name = "${var.app_name}-${var.env}-app"
        image = "${local.image}"
        #"152617774363.dkr.ecr.eu-central-1.amazonaws.com/testapp-testenv${var.image_tag}"
        #"${var.aws_ecr_repository_url}${var.image_tag}" #"nginx:latest"
        essential = true
        portMappings = [
            {
                containerPort = 80
                hostPort = 80
            }
        ],
        environment = [
          {
                name = "VERSION"
                value = "${var.app_name}${var.image_tag}"
          }
        ]
    }
  ])
}

resource "aws_ecs_service" "ecs" {
    name = "${var.app_name}-${var.env}-service"
    cluster = aws_ecs_cluster.test_cluster.id
    task_definition = aws_ecs_task_definition.task-definition.arn
    launch_type = "FARGATE"
    scheduling_strategy = "REPLICA"
    desired_count = 1
    force_new_deployment = true
    
    network_configuration {
      security_groups = [aws_security_group.task_sg.id]
      subnets = var.private_subnet_id #var.private_subnet_cidr
      assign_public_ip = true
    }

    # adding lb 12.11
    load_balancer {
      target_group_arn = var.alb_target_group
      container_name = "${var.app_name}-${var.env}-app"
      container_port = 80
    }


    depends_on = [
      #var.alb_listener, var.iam_role
      var.alb_listener, aws_iam_role_policy.ecs_task_exec_role
    ]
}

resource "aws_security_group" "task_sg" {
  name = "task_sg"
  vpc_id = var.vpc_id

    ingress {
    protocol    = "tcp"
    from_port   = 80 #5000
    to_port     = 80 #5000
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.alb_sg.name]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}