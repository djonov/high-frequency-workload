resource "aws_db_instance" "my_rds" {
  identifier         = "mydb"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  engine             = "postgres"
  engine_version     = "16.3"
  username           = "research"
  password           = "research"
  publicly_accessible = true
  skip_final_snapshot = true
}
