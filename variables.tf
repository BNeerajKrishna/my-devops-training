variable "name" {
  type = string
  # default     = "tf-session"
  description = "To define the name of ec2"
}

variable "vm_types" {
  type = list(string)
  # default = ["t2.micro", "t3.micro"]
}

variable "env" {
  type = string
  # default = "testing"
}

variable "public_ip_enable" {
  type = bool
  # default = true
}

variable "zone_names" {
  type = list(string)
  # default = ["ap-south-1a", "ap-south-1c"]
}

variable "bucket_name" {
  # default     = "bucket-1a1b0"
  description = "name of the bucket"
}

variable "instance_count" {
  type = number
  # default = 2
}
