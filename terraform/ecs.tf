# ecs.tf

resource "aws_ecs_cluster" "main" {
    name = "DevCluster"
}

# ECS Repositories
resource "aws_ecr_repository" "ethereum_repo_backend" {

  # The 'name' attribute specifies the name of the ECR repository.
  name = "ethereum/backend"
  /*
  # The 'image_scanning_configuration' block is used to configure image scanning settings for the repository.
  image_scanning_configuration {

    # The 'scan_on_push' attribute determines whether images are scanned for vulnerabilities upon being pushed to the repository.
    # Setting this to 'true' enables automatic scanning upon each push.
    scan_on_push = true
  }
  */
}
resource "aws_ecr_repository" "ethereum_repo_frontend" {

  # The 'name' attribute specifies the name of the ECR repository.
  name = "ethereum/frontend"
}


resource "aws_ecs_task_definition" "app" {
    family                   = "ethereum-app-task"
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    network_mode             = "awsvpc"
    #network_mode             = "bridge"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory
    #requires_compatibilities = ["EC2"]
    #cpu                      = var.ec2_cpu
    #memory                   = var.ec2_memory

    container_definitions = <<DEFINITION
    [
        {
            "cpu": 128,
            "environment": [{
                "name": "BACKEND_URL",
                "value": "http://localhost:5000/api/callRemoteAPI"
            }],
            "portMappings": [
                {
                "containerPort": 80,
                "hostPort": 80
                }
            ],
            "essential": true,
            "image": "${aws_ecr_repository.ethereum_repo_frontend.repository_url}:latest",
            "memory": 128,
            "memoryReservation": 64,
            "name": "frontend",
            "logConfiguration": {
                "logDriver": "awslogs",
                    "options": {
                    "awslogs-group": "/ecs/ethereum-app",
                    "awslogs-region": "us-east-1",
                    "awslogs-stream-prefix": "ecs"
                    }
            }
        },
        {
            "cpu": 512,
            "secrets": [{
                "name": "API_KEY",
                "valueFrom": "arn:aws:ssm:us-east-1:585008074324:parameter/infura_api_key"
            }],
            "portMappings": [
                {
                "containerPort": 5000,
                "hostPort": 5000
                }
            ],
            "essential": true,
            "image": "${aws_ecr_repository.ethereum_repo_backend.repository_url}:latest",
            "memory": 128,
            "memoryReservation": 64,
            "name": "backend",
            "logConfiguration": {
                "logDriver": "awslogs",
                    "options": {
                    "awslogs-group": "/ecs/ethereum-app",
                    "awslogs-region": "us-east-1",
                    "awslogs-stream-prefix": "ecs"
                    }
            }
        }
    ]
DEFINITION
}

resource "aws_ecs_service" "main" {
    name            = "ethereum-service"
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.app.arn
    desired_count   = var.app_count
    #launch_type     = "EC2"
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [aws_security_group.ecs_tasks.id]
        subnets          = aws_subnet.private.*.id
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = aws_alb_target_group.app.id
        container_name   = "frontend"
        container_port   = var.app_port
    }

    depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_ecr_attachment]
    
}
