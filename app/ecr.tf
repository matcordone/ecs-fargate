resource "aws_ecr_repository" "name" {
    name = "my-ecs-fargate-repo"
    image_tag_mutability = "MUTABLE"
    
    tags = {
        Name = "ECR-Repository"
    }
}