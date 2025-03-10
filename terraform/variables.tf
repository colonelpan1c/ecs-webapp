# variables.tf


variable "az_count" {
    description = "Number of AZs to cover in a given region"
    default = "2"
}

/* 
variable "frontend_app_image" {
    description = "Docker image to run in the ECS cluster"
    default = "${aws_ecr_repository.ethereum_repo_frontend.repository_url}:latest"
}

variable "backend_app_image" {
    description = "Docker image to run in the ECS cluster"
    default = "${aws_ecr_repository.ethereum_repo_backend.repository_url}:latest"
}
*/

variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default = 80
}

variable "https_app_port" {
    description = "HTTPS port exposed by the docker image to redirect traffic to"
    default = 443
}

variable "app_count" {
    description = "Number of docker containers to run"
    default = 3
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
    default = "1024"
}

variable "fargate_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    default = "2048"
}

variable "ec2_cpu" {
    description = "EC2 instance CPU units to provision (1 vCPU = 1024 CPU units)"
    default = "1024"
}

variable "ec2_memory" {
    description = "EC2 instance memory to provision (in MiB)"
    default = "2048"
}

variable "secret_api_key" {
    description = "provided api key for ethereum project"
}
