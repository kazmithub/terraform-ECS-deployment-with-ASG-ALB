# terraform-ecs-deployment

## Description

A terraform code that creates a VPC with basic configurations including internet gateways, route tables, subnets
and security groups. An ECS cluster is deployed inside which has 2 runnung tasks of nginx and a httpd server. 
IAM roles are configured accordingly. At the end, an the cluster is attached to an application load balancer
and auto-scaling group is configured.

## Pre-requisutes

Before reading this, 
- AWS account 
- AWS services basic knowledge
- Basic Terraform knowledge
- Extensive knowledge of Docker
- Extensive knowledge of Amazon ECS service 

 is required

## Modules

| Module Name   | Function                                                  |
| ------------- | ----------------------------------------------------------|
| vpc           | - A VPC with a provided CIDR.                             |
|               | - Two public Subnets within the above VPC.                |
|               | - Internet Gateway for internet access.                   |
|               | - Route table for routing.                                |
|               | - DHCP options.                                           |
|               | - Security groups.                                        |
|               |                                                           |
| iam           | - Instance Role for ECS cluster with a policy attached.   |
|               | - Role for an ECS service.                                |
|               |                                                           |
| ecs           | - An ECS cluster.                                         |
|               | - Task Definition with container definition.              |
|               | - An ECS Service.                                         |
|               |                                                           |
| ags-alb       | An ASG inside which                                       |
|               | - Launch configuration                                    |
|               | - Autoscaling group                                       |
|               | An ALB inside which                                       |
|               | - A listener                                              |
|               | - A target group                                          |
|               | - An application load balancer                            |

## Deployment

Deployment process on ECS consists of two steps. The first step is registering a Task definition that holds the
information about what container you want to start and what the requirements are. For instance memory, cpu or port.
The second step is creating or updating a Service definition which defines a Service which eventually uses the Task
Definition to start the containers on ECS and keeps them running.

More tasks can be added to the service using the count variable and the nameTaskDef variable which
defines the task definitions of the running tasks.

![alt text](https://github.com/kazmithub/terraform-ECS-deployment-with-ASG-ALB/blob/master/ecs3.png)

Task Definition is found in ./modeules/ecs/templates/taskdef.tpl and /modules/ecs/main.tf and can be referred in 
[documentation](https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html).

![alt text](https://github.com/kazmithub/terraform-ECS-deployment-with-ASG-ALB/blob/master/ecs1.png)

The service and the cluster are inside /modules/ecs/main.tf where the basic configuration is placed. The documentation
of the service and cluster


## Load Balancing and Autoscaling

Load balancing and autoscaling are inside the asg-alb block. The load balancer is Application load balancer which 
requires listener and target group. All of which are configured in the block. The running containers are using port 80
and 8080 of the host. 

![alt text](https://github.com/kazmithub/terraform-ECS-deployment-with-ASG-ALB/blob/master/alb1.png)

## Variable declaration

Before running the cluster, the varibles have to be initialized by the user to make things happen in the preferred way.
For testing purposes, uncomment the default values of the variables.

## Running the Cluster 

First of all, configure aws-cli in your instance or machine using [this link](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).
We can run the cluster in any given region which can be edited in the main file by using the following commands.

```
terraform init
terraform plan -var-file="The path and name of the variables file"
terraform apply -var-file="The path and name of the variables file"
```

## Container Secrets

Almost all containers require some form of external values or secrets, like the database password or keys to another
service. There are a lot of ways to do this, the simplest way when using ECS is by using AWS Parameter Store. Here is
[a blog post](http://blog.coralic.nl/2017/03/22/docker-container-secrets-on-aws-ecs/) that describes different options and how to use AWS Parameter Store.
To allow a task to access the Parameter Store you need a role that you can assing to your task. The ecs roles module 
can create such a role.

## State Management

State Management has numerous advantages like
- Safer storage: Storing state on the remote server helps prevent sensitive information. State file remains same but remote     storage like S3 provides a layer to security like making S3 bucket private and giving limited access.
- Auditing: Invalid access can be identified by enabling logging.
- Share data: Remote storage helps share state file with other members of team.

The backend lock is placed inside the backend.tf file. It is better to make the bucket and DynamoDB table manuallly to 
avoid any mishaps. 
