resource "aws_appautoscaling_target" "ecs_target" {
    max_capacity = 4
    min_capacity = 1
    resource_id  = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
    scalable_dimension = "ecs:service:DesiredCount"
    service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
    name = "ecs-auto-scaling-policy"
    policy_type = "TargetTrackingScaling"
    resource_id = aws_appautoscaling_target.ecs_target.resource_id
    scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
    service_namespace = aws_appautoscaling_target.ecs_target.service_namespace
     target_tracking_scaling_policy_configuration {
       target_value = 50.0
       scale_in_cooldown = 30
       scale_out_cooldown = 30

       predefined_metric_specification {
            predefined_metric_type = "ECSServiceAverageCPUUtilization"
       }
     }

  
}