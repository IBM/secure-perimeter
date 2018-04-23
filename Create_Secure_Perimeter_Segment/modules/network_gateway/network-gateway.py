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
name_id = query_args["gateway_name_id"]

if name_id.isdigit():
    name_id = int(name_id)

slclient = SoftLayer.Client(auth=TokenAuthentication(ims_user_id, ims_token))
net_mgr = SoftLayer.NetworkManager(slclient)

# determine gateway members
all_gateways   = slclient["Account"].getNetworkGateways()
matched_gateways = [g for g in all_gateways if g["name"] == name_id or g["id"] == name_id]

if len(matched_gateways) == 0:
    print("No target gateway found for name/id: {}".format(name_id))
    sys.exit(1)

target_gateway = matched_gateways[0]

gateway_members = slclient["Network_Gateway"].getMembers(id=target_gateway["id"])

if len(gateway_members) == 0:
    print("No gateway members found for name/id: {}".format(name_id))
    sys.exit(1)

priv_vlan_id = gateway_members[0]["networkGateway"]["privateVlanId"]
pub_vlan_id = gateway_members[0]["networkGateway"]["publicVlanId"]

private_vlan = net_mgr.get_vlan(priv_vlan_id)
public_vlan  = net_mgr.get_vlan(pub_vlan_id)

result = {
    "name": target_gateway["name"],
    "id": str(target_gateway["id"]),
    "private_vlan_id": str(private_vlan["id"]),
    "private_vlan_number": str(private_vlan["vlanNumber"]),
    "public_vlan_id": str(public_vlan["id"]),
    "public_vlan_number": str(public_vlan["vlanNumber"]),
    "datacenter": private_vlan["primaryRouter"]["datacenter"]["name"],
    "private_vlan_router": ".".join(private_vlan["primaryRouter"]["fullyQualifiedDomainName"].split(".")[:2]),
    "public_vlan_router": ".".join(public_vlan["primaryRouter"]["fullyQualifiedDomainName"].split(".")[:2])
}

print(json.dumps(result, separators=(',',':')))
