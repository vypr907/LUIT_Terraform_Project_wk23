#module/network/outputs

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_sg" {
  value = aws_security_group.pub_sg.id
}

output "private_sg" {
  value = aws_security_group.priv_sg.id
}

output "web_sg" {
  value = aws_security_group.web_sg.id
}

output "private_subnet" {
  value = aws_subnet.private_subnet[*].id
}

output "public_subnet" {
  value = aws_subnet.public_subnet[*].id
}