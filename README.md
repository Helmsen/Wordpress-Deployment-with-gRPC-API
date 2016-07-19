# Wordpress gRPC

The wordpress deployment script container runs a test script which tests wordpress specific deployment methods.
It starts two EC2 instances, deploys MySQL and Wordpress and connects those two components.
The wordpress installation is reachable at ```<host>/wordpress/``` or ```<host>/FAPRA-TEST/wordpress/```.
Important: The generic deployment method applies SaltStateFiles (ssl) on a remote machine. But it can not send customized files to a remote machine. Thus it is not possible to configure installed application (we would have to send a customized config file). So you have to set the database of the wordpress installation manually (via browser).

There is a preconfigured scenario for each test script (```docker-compose-wordpress.yml``` and ```docker-compose-generic.yml```).
Run a preconfigured deployment scenario with ```docker-compose -f <nameOfComposeFile> up```. But before you have to provide some AWS information in the corresponding compose file:
* ```KEY_ID```: Your AWS access key id
* ```KEY_SECRET```: Your AWS access key secret
* ```KEY_PAIR_NAME```: Name of the SSH-Key pair you want to use to start the EC2 instance (must exist in AWS management console)
* ```SECURITY_GROUP_NAME```: Name of the security group you want to use to configure the EC2 instance (must exist in AWS management console)

These information must be valid for the AWS region us-west-1, because the test script creates EC2 instances in this region.
The private ssh-key of the specified KEY_PAIR_NAME must be present in the docker container directory (```DockerContainerWordpressDeploymentScript``` or ```DockerContainerGenericDeploymentScript```) before you run the test script and must be named as ```key.pem```.
