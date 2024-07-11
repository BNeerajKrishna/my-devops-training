name             = "tf-session"
env              = "production"
vm_types         = ["t2.micro", "t3.micro"]
public_ip_enable = false
zone_names       = ["ap-south-1a", "ap-south-1c"]
instance_count   = 2