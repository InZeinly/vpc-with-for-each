# Creating in module ecr
# resource "aws_ecr_repository" "test_repo" {
#   name                 = "testapp-testenv"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   # tags = {
#   #   Name = "ecr repo"
#   #   Environment = "Prod"
#   # }
# }

# # added 12.11

# resource "aws_ecr_repository_policy" "test_repo" {
#   repository = aws_ecr_repository.test_repo.name
#   policy     = <<EOF
# {
#     "Version": "2008-10-17",
#     "Statement": [
#       {
#         "Sid": "adds full ecr access to the demo repository",
#         "Effect": "Allow",
#         "Principal": "*",
#         "Action": [
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:BatchGetImage",
#           "ecr:CompleteLayerUpload",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:GetLifecyclePolicy",
#           "ecr:InitiateLayerUpload",
#           "ecr:PutImage",
#           "ecr:UploadLayerPart"
#         ]
#       }
#     ]
# }
# EOF
# }


# Roles and policy 

# added 12.11
resource "aws_iam_role" "ecs_task_role" {
  name               = "testapp-testenv-taskrole"
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

resource "aws_iam_role" "TaskExecRole" {
  name = "exec-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Name = "iam-role"
    Environment = "testenv"
  }
}

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

resource "aws_iam_role_policy" "ecs_task_exec_role" {
  name_prefix = "ecs_iam_role_policy"
  role = aws_iam_role.TaskExecRole.id
  policy = data.template_file.ecs_service_policy.rendered
}

resource "aws_iam_role_policy_attachment" "TaskRolePolicy" {
  role = aws_iam_role.TaskExecRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_ecs_cluster" "test_cluster" {
  name = "${var.app_name}-${var.env}-cluster"
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
        name = var.app_name
        image = "nginx:latest"
        essential = true
        portMappings = [
            {
                containerPort = 5000
                hostPort = 5000
            }
        ],
        environment = [
          {
                name = "VERSION"
                value = var.image_tag
          }
        ]
    }
  ])
}

resource "aws_ecs_service" "ecs" {
    name = "test-ecs-service"
    cluster = aws_ecs_cluster.test_cluster.id
    task_definition = aws_ecs_task_definition.task-definition.arn
    launch_type = "FARGATE"
    scheduling_strategy = "REPLICA"
    desired_count = 1
    force_new_deployment = true
    network_configuration {
      subnets = var.private_subnet_id
      assign_public_ip = true
    }

    # adding lb 12.11
    load_balancer {
      target_group_arn = var.alb_target_group
      container_name = var.app_name
      container_port = 80
    }


    depends_on = [
      var.alb_listener, var.iam_role
    ]
}