output "dev_ip" {
  value = aws_instance.dev_node.public_ip
}

output "public_ip" {
  value = data.http.my_local_ip.response_body
}