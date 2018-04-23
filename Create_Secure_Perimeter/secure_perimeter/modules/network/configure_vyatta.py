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
import argparse

parser = argparse.ArgumentParser(description='Simple program to configure config.json file for use in network pod for vyatta configuration')
parser.add_argument("--action", dest="action", choices=["add-sp", "add-vlan", "remove-vlan"], required=False)
parser.add_argument('-n', '--vlan_num', help='VLAN Number', required=False)
parser.add_argument('-i', '--vlan_id', help='VLAN ID', required=False)
parser.add_argument('-t', '--vlan_type', help='type of vlan public/private', required=False)

parser.add_argument('-u', '--sluserid', help='SoftLayer User Id', required=False)
parser.add_argument('-k', '--apikey', help='SoftLayer API Key', required=False)
parser.add_argument('-a', '--primary_priv_ip', help='Private IP of Primary Vyatta', required=False)
parser.add_argument('-r', '--region', help='Region Name', required=False)
parser.add_argument('-b', '--primary_pub_ip', help='Public IP of Primary Vyatta', required=False)
parser.add_argument('-c', '--secondary_priv_ip', help='Private IP of Secondary Vyatta', required=False)
parser.add_argument('-d', '--secondary_pub_ip', help='Public IP of Secondary Vyatta', required=False)
parser.add_argument('-v', '--gatewayid', help='Gateway ID', required=False)
parser.add_argument('-gv', '--gatewayvip', help='Gateway VIP', required=False)
args = parser.parse_args()

def add_sp(slid,
    apikey,
    primary_priv_ip,
    primary_pub_ip,
    secondary_priv_ip,
    secondary_pub_ip,
    gatewayid,
    gatewayvip,
    region):
    config = json.loads(open('config.json').read())
    config["apikey"]=apikey
    config["slid"]=slid
    config["gatewayid"]=int(gatewayid)
    config["region"]=region
    config["vyatta_gateway_vip"]=gatewayvip
    config["vyatta_primary"]["private_ip"]=primary_priv_ip
    config["vyatta_primary"]["public_ip"]=primary_pub_ip
    config["vyatta_secondary"]["private_ip"]=secondary_priv_ip
    config["vyatta_secondary"]["public_ip"]=secondary_pub_ip


    with open('config.json','w') as f:
        f.write(json.dumps(config, sort_keys=True, indent=2))

def add_vlans(vlan_num, vlan_id, vlan_type):
    config = json.loads(open('config.json').read())
    item = {u'type': vlan_type,  u'vlanid': int(vlan_id), u'vlan_num': int(vlan_num)}
    config["vlans"].append(item)

    with open('config.json','w') as f:
        f.write(json.dumps(config, sort_keys=True, indent=2))

def remove_vlan(vlan_id):
    config = json.loads(open('config.json').read())

    for x in range(len(config["vlans"])):
        vlan_data = config["vlans"][x]

        if vlan_data["vlanid"] == vlan_id:
            del config["vlans"][x]
            break

        x += 1

    with open('config.json','w') as f:
        f.write(json.dumps(config, sort_keys=True, indent=2))

# ----------------------------------- #
#                main
# ----------------------------------- #

if (args.action == "add-sp"):
    print ("Adding VPC info to config.json file")
    add_sp(args.sluserid, args.apikey, args.primary_priv_ip, args.primary_pub_ip, args.secondary_priv_ip,args.secondary_pub_ip, args.gatewayid,args.gatewayvip, args.region)
elif (args.action == "add-vlan"):
    print ("Adding vlan info to config.json file")
    add_vlans(args.vlan_num, args.vlan_id, args.vlan_type)
elif (args.action == "remove-vlan"):
    remove_vlan(args.vlan_id)
