provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_vpc" "VPC" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
    Name = "test-vpc"
    }
}

resource "aws_subnet" "PublicSubnet1a" {
    vpc_id = aws_vpc.VPC.id
    cidr_block = "10.0.10.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-northeast-1a"

    tags = {
    Name = "public-subnet-1a"
    }
}

resource "aws_subnet" "PublicSubnet1c" {
    vpc_id = aws_vpc.VPC.id
    cidr_block = "10.0.11.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-northeast-1c"

    tags = {
    Name = "public-subnet-1c"
    }
}

resource "aws_subnet" "PrivateSubnet1a" {
    vpc_id = aws_vpc.VPC.id
    cidr_block = "10.0.20.0/24"
    map_public_ip_on_launch = false
    availability_zone = "ap-northeast-1a"

    tags = {
    Name = "private-subnet-1a"
    }
}

resource "aws_subnet" "PrivateSubnet1c" {
    vpc_id = aws_vpc.VPC.id
    cidr_block = "10.0.30.0/24"
    map_public_ip_on_launch = false
    availability_zone = "ap-northeast-1c"

    tags = {
    Name = "private-subnet-1c"
    }
}

resource "aws_route_table" "PublicRouteTable" {
    vpc_id = aws_vpc.VPC.id

    tags = {
    Name = "public-route"
    }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.VPC.id

    tags = {
    Name = "igw"
    }
}

resource "aws_route" "RouteInternet" {
    route_table_id = aws_route_table.PublicRouteTable.id
    gateway_id = aws_internet_gateway.IGW.id
    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "PublicRouteLocal1a" {
    subnet_id = aws_subnet.PublicSubnet1a.id
    route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "PublicRouteLocal1c" {
    subnet_id = aws_subnet.PublicSubnet1c.id
    route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_security_group" "EC2SecurityGroup" {
    name = "web-sg"
    description = "web-sg"
    vpc_id = aws_vpc.VPC.id

    tags = {
    Name = "web-sg"
    }
}
resource "aws_security_group_rule" "ec2_80" {
    type = "ingress"
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
    security_group_id = aws_security_group.EC2SecurityGroup.id
}
resource "aws_security_group_rule" "ec2_22" {
    type = "ingress"
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
    security_group_id = aws_security_group.EC2SecurityGroup.id
}
resource "aws_security_group_rule" "ec2_3000" {
    type = "ingress"
    from_port = "3000"
    to_port = "3000"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
    security_group_id = aws_security_group.EC2SecurityGroup.id
}
resource "aws_security_group_rule" "ec2_any" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.EC2SecurityGroup.id
}
resource "aws_security_group" "JenkinsSecurityGroup" {
    name = "jk-sg"
    description = "jk-sg"
    vpc_id = aws_vpc.VPC.id

    tags = {
    Name = "jk-sg"
    }
}
resource "aws_security_group_rule" "jk_8080" {
    type = "ingress"
    from_port = "8080"
    to_port = "8080"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
    security_group_id = aws_security_group.JenkinsSecurityGroup.id
}
resource "aws_security_group_rule" "jk_22" {
    type = "ingress"
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
    security_group_id = aws_security_group.JenkinsSecurityGroup.id
}
resource "aws_security_group_rule" "jk_any" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.JenkinsSecurityGroup.id
}
resource "aws_security_group" "RDSSecurityGroup" {
    name = "rds-sg"
    description = "rds-sg"
    vpc_id = aws_vpc.VPC.id

    tags = {
    Name = "rds-sg"
    }
}
resource "aws_security_group_rule" "rds_3306" {
    type = "ingress"
    from_port = "3306"
    to_port = "3306"
    protocol = "tcp"
    source_security_group_id = aws_security_group.EC2SecurityGroup.id
    security_group_id = aws_security_group.RDSSecurityGroup.id
}
resource "aws_security_group_rule" "rds-any" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.RDSSecurityGroup.id
}

resource "aws_security_group" "ALBSecurityGroup" {
    name = "alb-sg"
    description = "alb-sg"
    vpc_id = aws_vpc.VPC.id

    tags = {
    Name = "alb-sg"
    }
}
resource "aws_security_group_rule" "alb-80" {
    type = "ingress"
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
    security_group_id = aws_security_group.ALBSecurityGroup.id
}
resource "aws_security_group_rule" "alb-any" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.ALBSecurityGroup.id
}

data "aws_ami" "recent_amazon_linux_2" {
 most_recent = true
 owners = ["amazon"]

 filter {
  name = "name"
  values = ["amzn2-ami-hvm-2.0.??????????-x86_64-gp2"]
 }

 filter {
  name = "state"
  values = ["available"]
 }
}

resource "aws_instance" "EC2Instance01" {
 subnet_id = aws_subnet.PublicSubnet1a.id
 instance_type = "t2.micro"
 availability_zone = "ap-northeast-1a"
 key_name = "ec2-test2"
 monitoring    = false
 #ami = data.aws_ami.recent_amazon_linux_2.image_id
 ami = "ami-068a6cefc24c301d2"
 instance_initiated_shutdown_behavior = "stop"
 vpc_security_group_ids = [aws_security_group.EC2SecurityGroup.id]

 tags = {
  Name = "SV#1"
 }
}

resource "aws_instance" "EC2Instance02" {
 subnet_id = aws_subnet.PublicSubnet1c.id
 instance_type = "t2.micro"
 availability_zone = "ap-northeast-1c"
 key_name = "ec2-test2"
 monitoring    = false
 #ami = data.aws_ami.recent_amazon_linux_2.image_id
 ami = "ami-068a6cefc24c301d2"
 instance_initiated_shutdown_behavior = "stop"
 vpc_security_group_ids = [aws_security_group.EC2SecurityGroup.id]

 tags = {
  Name = "SV#2"
 }
}

resource "aws_instance" "JenKins" {
 subnet_id = aws_subnet.PublicSubnet1a.id
 instance_type = "t2.micro"
 availability_zone = "ap-northeast-1a"
 key_name = "ec2-test2"
 monitoring    = false
 #ami = data.aws_ami.recent_amazon_linux_2.image_id
 ami = "ami-068a6cefc24c301d2"
 instance_initiated_shutdown_behavior = "stop"
 vpc_security_group_ids = [aws_security_group.JenkinsSecurityGroup.id]

 tags = {
  Name = "jenkins"
 }
}

resource "aws_lb_target_group" "TargetGroup" {
  name = "web-tg"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.VPC.id

  health_check {
    interval = 10
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = 200
  }
}
resource "aws_lb_target_group_attachment" "Targets" {
  target_group_arn = aws_lb_target_group.TargetGroup.arn
  target_id        = aws_instance.EC2Instance01.id
  port             = 80
}
resource "aws_lb" "ApplicationLoadBalancer" {
  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALBSecurityGroup.id]
  subnets            = [
      aws_subnet.PublicSubnet1a.id,
      aws_subnet.PublicSubnet1c.id,
      ]

  enable_deletion_protection = false
  idle_timeout = 60
  enable_http2 = true

  access_logs {
    bucket  = "elb-backet-test"
    prefix  = "test-alb"
    enabled = true
  }
}
resource "aws_lb_listener" "Listener" {
    load_balancer_arn = aws_lb.ApplicationLoadBalancer.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.TargetGroup.arn
    }
}

resource "aws_db_subnet_group" "SubnetGroup" {
    name = "aws-and-infra-private-db-subnet-grp"
    description = "aws-and-infra-private-db-subnet-grp"
    subnet_ids = [aws_subnet.PrivateSubnet1a.id, aws_subnet.PrivateSubnet1c.id]
}
resource "aws_db_instance" "RDS" {
  availability_zone = "ap-northeast-1a"
  engine               = "mysql"
  engine_version       = "5.7.22"
  license_model        = "general-public-license"
  instance_class       = "db.t2.micro"
  multi_az             = false
  storage_type         = "gp2"
  identifier           = "database-1"
  username             = "admin"
  password             = "pkyCrDnWeTMHgDDqOHri"
  port                 = 3306
  vpc_security_group_ids = [aws_security_group.RDSSecurityGroup.id]
  allocated_storage    = 20
  allow_major_version_upgrade = false 
  auto_minor_version_upgrade  = false
  publicly_accessible  = false
  parameter_group_name = "default.mysql5.7"  
  option_group_name    = "default:mysql-5-7"  
  copy_tags_to_snapshot = false
  backup_retention_period = 1
  monitoring_interval = 0
  #name                 = ""
  db_subnet_group_name = aws_db_subnet_group.SubnetGroup.name
  skip_final_snapshot = true
}


resource "aws_s3_bucket" "S3Bucket" {
    bucket = "elb-backet-test"
    acl    = "private"
    force_destroy = true

    #versioning {
    #    enabled = true
    #}
}
resource "aws_s3_bucket_public_access_block" "private" {
  bucket = aws_s3_bucket.S3Bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_policy" "S3BucketPolicy" {
  bucket = aws_s3_bucket.S3Bucket.id
  policy = data.aws_iam_policy_document.PolicyDocument.json
}
data "aws_iam_policy_document" "PolicyDocument" {
    statement {
        sid = "AlbWriteAccess"
        effect = "Allow"
        actions = ["s3:PutObject"]
        resources = ["arn:aws:s3:::${aws_s3_bucket.S3Bucket.id}/*"]
        principals {
            type = "AWS"
            identifiers = ["582318560864"]
        }
    }
}


#-----output-----

output "EC2Instance01" {
	value = [
        aws_instance.EC2Instance01.public_dns,
        aws_instance.EC2Instance01.public_ip,
    ]
}
output "EC2Instance02" {
	value = [
        aws_instance.EC2Instance02.public_dns,
        aws_instance.EC2Instance02.public_ip,
    ]
}
output "JenKins" {
	value = [
        aws_instance.JenKins.public_dns,
        aws_instance.JenKins.public_ip,
    ]
}
output "RDS-endpoint" {
  value = aws_db_instance.RDS.endpoint
}
