output "secret_key" {
  value = aws_iam_access_key.wordpress_plugin.encrypted_secret
}

output "access_key" {
  value = aws_iam_access_key.wordpress_plugin.id
}
