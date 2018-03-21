variable "repo_base" {}
variable "salt_version" {}

variable "create_archive" {
  default = "false"
}

variable "reposync_repo" {
  default = "https://github.com/plus3it/salt-reposync.git"
}

variable "reposync_ref" {
  default = "master"
}

locals {
  url_parts = "${split("/", var.repo_base)}"
  bucket    = "${local.url_parts[3]}"
  key       = "${join("/", slice(local.url_parts, 4, length(local.url_parts)))}"
  uuid      = "${uuid()}"
}

data "aws_partition" "current" {}

data "http" "ip" {
  # Get local ip for security group ingress
  url = "http://ipv4.icanhazip.com"
}

data "aws_vpc" "this" {
  default = "true"
}

data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-2017.09.*-x86_64-gp2"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  name_regex = "amzn-ami-hvm-2017\\.09\\.\\d\\.[\\d]{8}-x86_64-gp2"
}

data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "role" {
  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${local.bucket}/${local.key}/*",
    ]
  }

  statement {
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${local.bucket}",
    ]
  }
}

resource "aws_iam_role" "this" {
  name               = "salt-reposync-${local.uuid}"
  assume_role_policy = "${data.aws_iam_policy_document.trust.json}"
}

resource "aws_iam_role_policy" "this" {
  name   = "salt-reposync-${local.uuid}"
  role   = "${aws_iam_role.this.id}"
  policy = "${data.aws_iam_policy_document.role.json}"
}

resource "aws_iam_instance_profile" "this" {
  name = "salt-reposync-${local.uuid}"
  role = "${aws_iam_role.this.name}"
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "this" {
  key_name   = "salt-reposync-${local.uuid}"
  public_key = "${tls_private_key.this.public_key_openssh}"
}

resource "aws_security_group" "this" {
  name   = "salt-reposync-${local.uuid}"
  vpc_id = "${data.aws_vpc.this.id}"

  tags {
    Name = "salt-reposync-${local.uuid}"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.ip.body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami                    = "${data.aws_ami.this.id}"
  instance_type          = "t2.micro"
  iam_instance_profile   = "${aws_iam_instance_profile.this.name}"
  key_name               = "${aws_key_pair.this.id}"
  vpc_security_group_ids = ["${aws_security_group.this.id}"]

  tags {
    Name = "salt-reposync-${local.uuid}"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "sudo yum -y install git",
      "git clone ${var.reposync_repo} && cd salt-reposync",
      "git checkout ${var.reposync_ref}",
      "REPOSYNC_SALT_VERSION=${var.salt_version}",
      "REPOSYNC_HTTP_URL=${var.repo_base}",
      "REPOSYNC_ARCHIVE=${var.create_archive}",
      "export REPOSYNC_SALT_VERSION REPOSYNC_HTTP_URL REPOSYNC_ARCHIVE",
      "sudo -E make sync.s3",
    ]

    connection {
      port        = 22
      user        = "ec2-user"
      private_key = "${tls_private_key.this.private_key_pem}"
    }
  }
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = "${aws_instance.this.public_ip}"
}

output "private_key" {
  description = "Private key for the keypair"
  value       = "${tls_private_key.this.private_key_pem}"
}
