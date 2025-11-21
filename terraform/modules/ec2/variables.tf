variable "name" { 
    type = string 
    description = "The name of the EC2 instance"
}
variable "ami" { 
    type = string 
    description = "The AMI ID for the EC2 instance"
}   
variable "instance_type" { 
    type = string 
    default = "t3.medium"
    description = "The instance type for the EC2 instance"
}
variable "subnet_id" { 
    type = string 
    description = "The subnet ID for the EC2 instance"
}
variable "key_name" { 
    type = string 
    default = "" 
    description = "The key name for the EC2 instance"
}
variable "security_group_ids" { 
    type = list(string) 
    default = [] 
    description = "List of security group IDs for the EC2 instance"
}
variable "tags" { 
    type = map(string) 
    default = {} 
    description = "Tags to assign to the EC2 instance"
}