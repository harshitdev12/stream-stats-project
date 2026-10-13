# --- Backend (Flask Kitchen) ---
resource "aws_ecs_task_definition" "backend_task" {
  family                   = "overlay-backend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "backend-container"
      image     = "${aws_ecr_repository.backend_repo.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "backend_service" {
  name            = "overlay-backend-service"
  cluster         = aws_ecs_cluster.overlay_cluster.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public_subnet.id] # Place in a private subnet for production
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

# --- Frontend (Express Waiter) ---
resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "overlay-frontend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "frontend-container"
      image     = "${aws_ecr_repository.frontend_repo.repository_url}:latest"
      essential = true
      environment = [
        {
          name  = "API_URL"
          value = "http://localhost:5000" # In production, this would be the backend service discovery endpoint
        }
      ]
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "frontend_service" {
  name            = "overlay-frontend-service"
  cluster         = aws_ecs_cluster.overlay_cluster.id
  task_definition = aws_ecs_task_definition.frontend_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public_subnet.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_tg.arn
    container_name   = "frontend-container"
    container_port   = 3000
  }
}