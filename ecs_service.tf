resource "aws_ecs_service" "ecs_service" {
    name            = "my-ecs-service"
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.ecs_task.arn
    desired_count   = 1
    launch_type     = "FARGATE"
    
    network_configuration {
        subnets          = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
        security_groups  = [aws_security_group.sg_ecs.id]
    }
    
    load_balancer {
        target_group_arn = aws_alb_target_group.alb_target_group.arn
        container_name   = "my-container"
        container_port   = 80
    }
    
    depends_on = [
        aws_iam_policy_attachment.ecs_task_execution_policy,
        aws_alb_target_group.alb_target_group,
        aws_alb_listener.alb_listener,
]

    
    tags = {
        Name = "ECS-Service"
    }
  
}