resource "null_resource" "example" {
  # Provisioner block defines actions to be taken
  provisioner "local-exec" {
    command = "echo 'Hello, Terraform!' > output.txt"
  }

  # Triggers define conditions for re-executing the provisioner
  triggers = {
    always_run = "${timestamp()}"
  }
}