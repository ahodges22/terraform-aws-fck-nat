resource "aws_security_group" "this" {
  count       = var.enabled ? 1 : 0
  name_prefix = var.name
  vpc_id      = var.vpc_id
  description = "Security group for NAT instance ${var.name}"
  tags        = local.common_tags
}

resource "aws_security_group_rule" "egress" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.this[count.index].id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
}

resource "aws_security_group_rule" "ingress_any" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.this[count.index].id
  type              = "ingress"
  cidr_blocks       = var.private_subnets_cidr_blocks
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
}

data "aws_ec2_instance_type" "this" {
  count         = var.enabled ? 1 : 0
  instance_type = var.instance_type
}

# Grab the latest fck-nat AMI
data "aws_ami" "this" {
  count       = var.enabled ? 1 : 0
  most_recent = true
  owners      = ["568608671756"]
  filter {
    name   = "architecture"
    values = data.aws_ec2_instance_type.this[count.index].supported_architectures
  }
  filter {
    name   = "name"
    values = ["fck-nat-amzn2-*"]
  }
}

resource "aws_launch_template" "this" {
  count         = var.enabled ? 1 : 0
  name_prefix   = var.name
  image_id      = var.image_id != "" ? var.image_id : data.aws_ami.this[count.index].id
  key_name      = var.key_name
  instance_type = var.instance_type

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.this[count.index].id]
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.common_tags
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  description = "Launch template for NAT instance ${var.name}"
  tags        = local.common_tags
}

resource "aws_instance" "this" {
  count     = var.enabled ? 1 : 0
  subnet_id = var.public_subnet

  launch_template {
    id = aws_launch_template.this[count.index].id
  }
}

resource "aws_route" "this" {
  count                  = var.enabled ? length(var.private_route_table_ids) : 0
  route_table_id         = var.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.this[count.index].primary_network_interface_id
}
