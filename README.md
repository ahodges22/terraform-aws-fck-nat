# fck-nat Terraform Module
A module to spin up a NAT instance running [fck-nat](https://github.com/AndrewGuenther/fck-nat) in an AWS account.

Warning: Generally you should use a NAT gateway for production purposes. This module provides a very low cost solution for testing and development purposes.

## Example Usage

```
module "nat-instance" {
  source                      = "ahodges22/terraform-aws-fck-nat"
  name                        = "dev"
  vpc_id                      = "vpc-xxxx"
  public_subnet               = "subnet-xxxx"
  private_subnets_cidr_blocks = ["10.10.1.1/24"]
  private_route_table_ids     = ["rtb-xxxx"]
}
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.47.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_any](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ec2_instance_type.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Enable monitoring on the NAT instance. | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable the fck-nat instance. | `bool` | `true` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | For a user provided AMI. Defaults to the latest fck-nat AMI. | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type for the NAT, arm64 is supported. | `string` | `"t4g.nano"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Name of the key pair for the NAT instance. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to use for the associated resources. | `string` | n/a | yes |
| <a name="input_private_route_table_ids"></a> [private\_route\_table\_ids](#input\_private\_route\_table\_ids) | List of IDs of the private subnet route tables. Used to set the route for the private subnets to use the NAT instance. | `list(string)` | `[]` | no |
| <a name="input_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#input\_private\_subnets\_cidr\_blocks) | List of CIDR blocks of the private subnets. The NAT instance accepts connections from these CIDRs. | `list(string)` | n/a | yes |
| <a name="input_public_subnet"></a> [public\_subnet](#input\_public\_subnet) | The ID of the subnet to place the NAT instance. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to resources created with this module | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | ID of the security group of the NAT instance |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Private IP of the ENI for the NAT instance |
<!-- END_TF_DOCS -->