This repo has terraform templates for IBM Cloud customers to create a Secure Perimeter for their workload in the IBM Cloud using a Virtual Router Appliance (a.k.a. Vyatta). There are terraform templates to do the following:
1. Create Secure Perimeter: HA deployment of VRA with default rules to prevent public ingress access.
1. Create Secure Perimeter Segment: secured, isolated vlan pair (a.k.a. segment in this context)
1. Deploy a sample application, bluechatter, using IBM Cloud Container Service kubernetes cluster deployed in the secure-perimeter and Dedicated Compose Redis service instance in the IBM Cloud.
