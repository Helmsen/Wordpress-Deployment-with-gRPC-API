#!/bin/bash

aws_access_key_id=$KEY_ID
aws_access_key_secret=$KEY_SECRET

ip=$IP_SERVER
port=$PORT_SERVER

mysqlPath="/srv/salt/generic/mysql.sls"
apachePath="/srv/salt/generic/apache.sls"
wordpressPath="/srv/salt/generic/wordpress.sls"
privateKey="/srv/salt/key/key.pem"
instance_type="t2.micro"
os="ubuntu"
key_pair_name=$KEY_PAIR_NAME
security_group_name=$SECURITY_GROUP_NAME
number="1"
region="us-west-1"

# Create machine 1
echo ""
echo "CREATE MACHINE 1"
out="$(java -jar /fapra/DeploymentClient.jar $ip $port createvm $instance_type $os $key_pair_name $security_group_name $number $region $aws_access_key_id $aws_access_key_secret)"
out="$(echo $out | grep -F "Instance")"
instanceId1="$(sed 's/.*Instance ID: //' <<< $out)"
instanceId1="$(sed 's/Public IP.*//' <<< $instanceId1)"
echo "Created instance with id = ${instanceId1}"

# After creation we have to wait a certain time until te machines have public ips
echo ""
echo "SLEEP SOME SECONDS"
sleep 5s

# Get information about machine 1
echo ""
echo "GET INFORMATION ABOUT MACHINE 1"
out="$(java -jar /fapra/DeploymentClient.jar $ip $port getdetails $instanceId1 $region $aws_access_key_id $aws_access_key_secret)"
ip1="$(sed 's/\(.*\)Instance Id: \(.*\) Operating System: \(.*\) Public IP: \(.*\) Public DNS: \(.*\)/\4/' <<< $out)"
dns1="$(echo $out | grep DNS | sed 's/.*Public DNS: \(.*\)/\1/')"
echo "# Machine 1"
echo "* IP: $ip1"
echo "* DNS: $dns1"

# Sleep again
echo ""
echo "SLEEP AGAIN (WAIT FOR THE INITIALIZATION OF THE MACHINE)"
sleep 120s

# Deploy SaltStack State File
echo ""
echo "DEPLOY GENERIC SALTSTACK STATE FILE (MySQL)"
out="$(java -jar /fapra/DeploymentClient.jar $ip $port generic $os $ip1 $privateKey $mysqlPath)"
echo "$out"
echo ""
echo "DEPLOY GENERIC SALTSTACK STATE FILE (Apache)"
out="$(java -jar /fapra/DeploymentClient.jar $ip $port generic $os $ip1 $privateKey $apachePath)"
echo "$out"
echo ""
echo "DEPLOY GENERIC SALTSTACK STATE FILE (Wordpress)"
out="$(java -jar /fapra/DeploymentClient.jar $ip $port generic $os $ip1 $privateKey $wordpressPath)"
echo "$out"
