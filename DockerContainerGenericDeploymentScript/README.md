# Docker Container for Test Script

This docker container runs a test script, which tests the generic deployment service.
It starts a EC2 instance and installs MySQL and Wordpress on it.
Before you run a container, provide some AWS information in the Dockerfile:
* ```KEY_ID```: Your AWS access key id
* ```KEY_SECRET```: Your AWS access key secret
* ```KEY_PAIR_NAME```: Name of the SSH-Key pair you want to use to start the EC2 instance (must exist in AWS management console)
* ```SECURITY_GROUP_NAME```: Name of the security group you want to use to configure the EC2 instance (must exist in AWS management console)
* ```IP_SERVER```: IP of the host which runs the deployment service
* ```PORT_SERVER```: Port the deployment service is listening on

These information must be valid for the AWS region us-west-1, because the test script creates a EC2 instance in this region.
The private ssh-key of the specified KEY_PAIR_NAME must be present in this directory (<repositoryRoot>/DockerContainerGenericDeploymentScript) before you run the test script and must be named as ```key.pem```.

Important: The generic deployment method applies SaltStateFiles (ssl) on a remote machine. But it can not send customized files to a remote machine. Thus it is not possible to configure installed application (we would have to send a customized config file). So you have to set the database of the wordpress installation manually (via browser).

Create a docker image with ```docker build -t <containerName> <pathToDockerfile>``` and run a container with ```docker run <containerName>```
