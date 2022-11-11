resource "aws_ecr_repository" "test_repo" {
  name                 = "testapp-testenv"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  # tags = {
  #   Name = "ecr repo"
  #   Environment = "Prod"
  # }
}

resource "aws_iam_role" "TaskExecRole" {
  name = "exec-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Name = "iam-role"
    Environment = "testenv"
  }
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

resource "aws_iam_role_policy_attachment" "TaskRolePolicy" {
  role = aws_iam_role.TaskExecRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_ecs_cluster" "test_cluster" {
  name = "test-cluster"
  tags = {
    "Name" = "test cluster"
    Environment = "testenv"
  }
}

resource "aws_ecs_task_definition" "task-definition" {
  family = "some-name"
  execution_role_arn = aws_iam_role.TaskExecRole.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "256"
  memory = "512"
  container_definitions = jsonencode([
    {
        name = "first"
        image = "nginx:latest"
        essential = true
        portMappings = [
            {
                containerPort = 80
                hostPort = 80
            }
        ]
    }
  ])
}

resource "aws_ecs_service" "ecs" {
    name = "test-ecs"
    cluster = aws_ecs_cluster.test_cluster.id
    task_definition = aws_ecs_task_definition.task-definition.id
    launch_type = "FARGATE"
    scheduling_strategy = "REPLICA"
    desired_count = 1
    force_new_deployment = true
    network_configuration {
      subnets = var.private_subnet_cidr
      assign_public_ip = true
    }
    depends_on = [
      var.alb_listener, var.iam_role
    ]
}