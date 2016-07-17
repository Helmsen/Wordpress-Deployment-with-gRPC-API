#!/bin/bash

aws_access_key_id=$KEY_ID
aws_access_key_secret=$KEY_SECRET

ip=$IP_SERVER
port=$PORT_SERVER

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

# Create machine 2
echo ""
echo "CREATE MACHINE 2"
out="$(java -jar /fapra/DeploymentClient.jar $ip $port createvm $instance_type $os $key_pair_name $security_group_name $number $region $aws_access_key_id $aws_access_key_secret)"
out="$(echo $out | grep -F "Instance")"
instanceId2="$(sed 's/.*Instance ID: //' <<< $out)"
instanceId2="$(sed 's/Public IP.*//' <<< $instanceId2)"
echo "Created instance with id = ${instanceId2}"

# After creation we have to wait a certain time until te machines have public ips
echo ""
echo "SLEEP SOME SECONDS"
sleep 5s

# Get information about machine 1
echo ""
echo "GET INFORMATION ABOUT MACHINE 1"
out="$(java -jar /fapra/DeploymentClient.jar $ip $port getdetails $instanceId1 $region $aws_access_key_id $aws_access_key_secret)"
ip1="$(sed 's/\(.*\)Instance Id: \(.*\) Operating System: \(.*\) Public IP: \(.*\) Public DNS: \(.*\)/\4/' <<< $out)"
dns1=$(echo $out | grep DNS | sed 's/.*Public DNS: \(.*\)/\1/')
echo " ++ "
echo "$out"
echo "# Machine 1"
echo "* IP: $ip1"
echo "* DNS: $dns1"

# Get information about machine 2
echo ""
echo "GET INFORMATION ABOUT MACHINE 2"
out="$(java -jar /fapra/DeploymentClient.jar $ip $port getdetails $instanceId2 $region $aws_access_key_id $aws_access_key_secret)"
ip2="$(sed 's/\(.*\)Instance Id: \(.*\) Operating System: \(.*\) Public IP: \(.*\) Public DNS: \(.*\)/\4/' <<< $out)"
dns2=$(echo $out | grep DNS | sed 's/.*Public DNS: \(.*\)/\1/')
echo "# Machine 2"
echo "* IP: $ip2"
echo "* DNS: $dns2"

# Sleep again
echo ""
echo "SLEEP AGAIN (WAIT FOR INITIALIZATION OF THE MACHINES)"
sleep 120s

# Deploy db
echo ""
echo "DEPLOY DB TO MACHINE 1"
out="$(java -jar /fapra/DeploymentClient.jar $ip $port deploydb $os $ip1 $privateKey saltuser saltpw wordpress)"
echo "$out"

# Deploy app
echo ""
echo "DEPLOY WORDPRESS TO MACHINE 2"
out="$(java -jar /fapra/DeploymentClient.jar $ip $port deployapp $os $ip2 $privateKey wordpress saltuser saltpw $dns1)"
echo "$out"

# In this script we did not use following commands:
# * destroyvm: Otherwise you could not test if wordpress is working
# * connectapptodb: Because the app (wordpress) is initially connected to a db. If we would connect it to another db, you could not test if the initial db connection works
# * backupdb: This requires a ftp server to upload to
# * restoredb: Because we would have to provide a valid sqldump containing wordpress data to make the changes visible in the app
#
# That's why we provide some more deployment scenarios (as bash scripts). Also feel free to write your own scripts and test the commands.
