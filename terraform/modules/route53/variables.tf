variable "zone_name" { 
    type = string 
    description = "The name of the Route53 hosted zone"
    }
variable "tags" { 
    type = map(string) 
    default = {} 
    }