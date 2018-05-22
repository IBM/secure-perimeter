################################################################
# coding: utf8
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

#!/usr/bin/python

import os
import sys
import json
from subprocess import Popen, PIPE, STDOUT

query_args = json.load(sys.stdin)

proc = Popen("bx cr token-add --non-expiring -q", shell=True, stdout = PIPE, stderr = PIPE, env = os.environ.copy())

out, err = proc.communicate()

token_json = {
    "registry.bluemix.net": {
        "username": "token",
        "password": out.rstrip(),
        "email": query_args["email"]
    }
}

with open(query_args["path"], 'w') as outfile:
    json.dump(token_json, outfile)

result = {
    "file_path": query_args["path"]
}

print(json.dumps(result))
