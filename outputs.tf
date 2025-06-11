output "name" {
  value = aws_vpc.vpc_1.id
}
output "name_pub_subnet" {
  value = aws_subnet.subnet_pub.id
}
output "name_priv_subnet_1" {
  value = aws_subnet.subnet_1.id
}
output "name_priv_subnet_2" {
  value = aws_subnet.subnet_2.id
}
output "sg_alb" {
  value = aws_security_group.sg_alb.id
}
output "sg_ecs" {
    value = aws_security_group.sg_ecs.id
}
output "name_alb" {
  value = aws_alb.alb_ecs.dns_name
}