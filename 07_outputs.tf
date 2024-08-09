# output "instance_ip" {
#   value = [for i in aws_instance.web : i.public_ip]
# }

# output "instance_id" {
#   value = [for surya in aws_instance.web : surya.id]
# }

# output "test_ip" {
#   value = aws_instance.web["ap-south-1c"].public_ip
# }
# output "ansible_controller_public_ip" {
#   value = aws_instance.ansible_controller.public_ip
# }

# output "nginx_host_public_ip" {
#   value = aws_instance.nginx_host.public_ip
# }

# output "apache_host_public_ip" {
#   value = aws_instance.apache_host.public_ip
# }

output "bastion_instance_ip" {
  value = aws_instance.bastion_instance.public_ip
}

output "app1_instance_ip" {
  value = aws_instance.instance["app1"].private_ip
}

output "app2_instance_ip" {
  value = aws_instance.instance["app2"].private_ip
}

output "db1_instance_ip" {
  value = aws_instance.instance["db1"].private_ip
}

output "db2_instance_ip" {
  value = aws_instance.instance["db2"].private_ip
}