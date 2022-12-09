resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "main"
  subnet_ids = data.aws_subnet_ids.available_db_subnet.ids
  tags = {
    name = "My db subnet group"
  }
}