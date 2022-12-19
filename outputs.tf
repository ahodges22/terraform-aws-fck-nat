output "private_ip" {
  description = "Private IP of the ENI for the NAT instance"
  value       = element(concat(aws_instance.this.*.private_ip, [""]), 0)
}

output "instance_id" {
  description = "ID of the security group of the NAT instance"
  value       = element(concat(aws_instance.this.*.id, [""]), 0)
}
