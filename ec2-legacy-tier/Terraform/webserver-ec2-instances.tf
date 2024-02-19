resource "aws_instance" "webserver" {
  depends_on = [
    aws_subnet.sandbox_subnet_public_1,
    aws_subnet.sandbox_subnet_public_2
  ]
  for_each      = { for webserver in var.webserver_instances : webserver.id => webserver }
  ami           = data.aws_ami.amazon_linux.id
  instance_type = each.value.server_type
  key_name      = var.access_key_name
  subnet_id     = each.value["web_subnet"].id
  tags          = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-${each.value.tagged_name}" }))

  vpc_security_group_ids = [
    aws_security_group.webserver_sg.id
  ]


}

/*resource "aws_instance" "webserver_2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = var.access_key_name
  subnet_id     = aws_subnet.sandbox_subnet_public_2.id

  vpc_security_group_ids = [
    aws_security_group.webserver_sg.id
  ]

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-public-webserver-2" }))
}
*/
