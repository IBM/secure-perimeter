################################################################
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

data "external" "registry_token" {
 program = ["python", "${path.module}/registry_token.py"]

 query = {
   path = "${var.file_path}"
   email = "${var.email}"
 }
}

output "file_path" {
  value = "${data.external.registry_token.result["file_path"]}"
}
