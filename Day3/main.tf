module "ec2_creation" {
  source = "./modules/ec2_instance"
  ami_value = "ami-0f918f7e67a3323f0"
  instance_type_value = "t2.micro"
  subnet_id_value = "subnet-035825eefadedb804"
}

module "s3_bucket_creation" {
  source = "./modules/s3_bucket"
  aws_s3_bucket_value = "mytestbucketfordevopstraining22012025"
}

output "public_ip_address" {
  value = module.ec2_creation.public_ip_address
}

output "aws_s3_bucket_arn" {
  value = module.s3_bucket_creation.aws_s3_bucket_arn
}