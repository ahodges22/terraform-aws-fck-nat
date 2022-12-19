#####################
# Required Variables
#####################
variable "name" {
  description = "The name to use for the associated resources."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}

variable "public_subnet" {
  description = "The ID of the subnet to place the NAT instance."
  type        = string
}

variable "private_subnets_cidr_blocks" {
  description = "List of CIDR blocks of the private subnets. The NAT instance accepts connections from these CIDRs."
  type        = list(string)
}

#####################
# Optional Variables
#####################
variable "enabled" {
  description = "Enable the fck-nat instance."
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Enable monitoring on the NAT instance."
  type        = bool
  default     = false
}

variable "private_route_table_ids" {
  description = "List of IDs of the private subnet route tables. Used to set the route for the private subnets to use the NAT instance."
  type        = list(string)
  default     = []
}

variable "image_id" {
  description = "For a user provided AMI. Defaults to the latest fck-nat AMI."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The instance type for the NAT, arm64 is supported."
  type        = string
  default     = "t4g.nano"
}

variable "key_name" {
  description = "Name of the key pair for the NAT instance."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to resources created with this module"
  type        = map(string)
  default     = {}
}

locals {
  // Merge the default tags and user-specified tags.
  // User-specified tags take precedence over the default.
  common_tags = merge(
    {
      Name = "nat-instance-${var.name}"
    },
    var.tags,
  )
}
