################################################################
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

data "external" "sl_credentials" {
 program = ["python", "${path.module}/sl_credentials.py"]

 query = {
   ims_user_id = "${var.ims_user_id}"
   ims_token = "${var.ims_token}"
 }
}

output "username" {
  value = "${data.external.sl_credentials.result["username"]}"
}

output "apikey" {
  value = "${data.external.sl_credentials.result["apikey"]}"
}
