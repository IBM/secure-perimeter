################################################################
# coding: utf8
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

#!/usr/bin/python

import sys
import json
import requests

from requests.auth import HTTPBasicAuth

query_args = json.load(sys.stdin)

apikey = query_args["iam_apikey"]

resp = requests.post("https://iam.ng.bluemix.net/oidc/token", headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "Accept": "application/json"
}, data = {
    "grant_type": "urn:ibm:params:oauth:grant-type:apikey",
    "apikey": apikey
})

if not resp.status_code == requests.codes.ok:
    print("Error: failed to authenticate")
    print(resp.text)
    sys.exit(1)

iam_token = resp.json()["access_token"]

resp = requests.post("https://iam.ng.bluemix.net/identity/token", auth=HTTPBasicAuth("bx", "bx"), headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "Accept": "application/json"
}, data = {
    "grant_type": "urn:ibm:params:oauth:grant-type:derive",
    "response_type": "ims_portal",
    "access_token": iam_token
})

if not resp.status_code == requests.codes.ok:
    print("Error: failed to authenticate")
    print(resp.text)
    sys.exit(1)

resp_json = resp.json()

ims_user_id = str(resp_json["ims_user_id"])
ims_token   = str(resp_json["ims_token"])

result = {
    "ims_user_id": ims_user_id,
    "ims_token": ims_token
}

print(json.dumps(result))
