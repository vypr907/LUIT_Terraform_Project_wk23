# module/compute/main


#get the AMI
data "aws_ami" "lnx_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

#create the template for our bastion host
resource "aws_launch_template" "bastion" {
  name_prefix            = "wk23_bastion"
  image_id               = data.aws_ami.lnx_ami.id
  instance_type          = var.bast_instance_type
  vpc_security_group_ids = [var.public_sg]

  tags = {
    Name    = "wk23_bastion"
    Project = "Week_23"
  }
}

#create the template for our webserver
resource "aws_launch_template" "web" {
  name_prefix            = "wk23_web"
  image_id               = data.aws_ami.lnx_ami.id
  instance_type          = var.web_instance_type
  vpc_security_group_ids = [var.private_sg]
  user_data              = filebase64("simple_web_install.sh")

  tags = {
    Name    = "wk23_web"
    Project = "Week_23"
  }
}

#create the autoscaling groups for both tiers
resource "aws_autoscaling_group" "bastion_asg" {
  name                = "wk23_bastion"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 1
  vpc_zone_identifier = tolist(var.public_subnet)

  launch_template {
    id      = aws_launch_template.bastion.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                = "wk23_web"
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2
  vpc_zone_identifier = tolist(var.public_subnet)

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  lb_target_group_arn    = var.alb_target
}