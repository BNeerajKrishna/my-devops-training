name             = "tf-session"
env              = "test"
vm_types         = ["t2.micro", "t3.micro"]
public_ip_enable = true
zone_names       = ["ap-south-1a", "ap-south-1c"]
instance_count   = 1
bucket_name      = "test2765777"

subnet_configs = {
  public1 = {
    cidr_block  = "10.0.1.0/24"
    subnet_type = "public"
    zone        = "ap-south-1a"
  }
  public2 = {
    cidr_block  = "10.0.2.0/24"
    subnet_type = "public"
    zone        = "ap-south-1b"
  }
  app1 = {
    cidr_block  = "10.0.3.0/24"
    subnet_type = "private"
    zone        = "ap-south-1a"
  }
  app2 = {
    cidr_block  = "10.0.4.0/24"
    subnet_type = "private"
    zone        = "ap-south-1b"
  }
  db1 = {
    cidr_block  = "10.0.5.0/24"
    subnet_type = "private"
    zone        = "ap-south-1a"
  }
  db2 = {
    cidr_block  = "10.0.6.0/24"
    subnet_type = "private"
    zone        = "ap-south-1b"
  }
}




