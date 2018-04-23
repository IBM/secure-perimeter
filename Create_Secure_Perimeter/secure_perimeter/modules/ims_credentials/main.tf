################################################################
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

data "external" "ims_credentials" {
  program = ["python", "${path.module}/ims_credentials.py"]

  query = {
    iam_apikey = "${var.iam_apikey}"
  }
}

output "user_id" {
  value = "${data.external.ims_credentials.result["ims_user_id"]}"
}

output "token" {
  value = "${data.external.ims_credentials.result["ims_token"]}"
}
