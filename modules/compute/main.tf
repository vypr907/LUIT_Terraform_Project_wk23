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
  #TODO: Create simple_web_install.sh from bootstrap
  #user_data = filebase64("simple_web_install.sh") 

  tags = {
    Name    = "wk23_web"
    Project = "Week_23"
  }
}

#create the autoscaling groups for both tiers
