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
import SoftLayer

from SoftLayer.auth import TokenAuthentication

query_args = json.load(sys.stdin)

ims_user_id = query_args["ims_user_id"]
ims_token = query_args["ims_token"]

slclient = SoftLayer.Client(auth=TokenAuthentication(ims_user_id, ims_token))
user_auth_keys = slclient.call("User_Customer", "getObject", id=ims_user_id, mask="username;apiAuthenticationKeys.authenticationKey")

result = {
    "username": user_auth_keys["username"],
    "apikey": user_auth_keys["apiAuthenticationKeys"][0]["authenticationKey"]
}

print(json.dumps(result))
