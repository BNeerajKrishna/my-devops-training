output "instance_ip" {
  value = [ for i in aws_instance.web: i.public_ip ]
}

output "instance_id" {
  value = [ for surya in aws_instance.web: surya.id ]
}

output "test_ip" {
  value = aws_instance.web["ap-south-1c"].public_ip
}