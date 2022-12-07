data "archive_file" "init" {
  type        = "zip"
  source_file = "Welcome.py"
  output_path = "${path.module}/outputs/Welcome.zip"
}


resource "aws_lambda_function" "terraform_lambda_func" {
filename                       = "${path.module}/outputs/Welcome.zip"
function_name                  = "Welcome"
role                           = "${aws_iam_role.lambda_role.arn}"
handler                        = "Welcome.hello"
runtime                        = "python3.8"
#depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

