variable "name" { 
    type = string 
    default = "bgr-app-vpc" 
    }
variable "vpc_cidr" { 
    type = string 
    default = "10.0.0.0/16" 
    }
variable "azs" { 
    type = list(string) 
    default = [] 
    }
variable "public_subnet_cidrs" { 
    type = list(string) 
    default = [] 
    }
variable "private_subnet_cidrs" { 
    type = list(string) 
    default = [] 
    }
variable "enable_nat_gateway" { 
    type = bool 
    default = true 
    }
variable "tags" { 
    type = map(string) 
    default = {} 
    }