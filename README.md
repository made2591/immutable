# The immutable repository
***immutable*** represents my best implementation of an immutable, opinionated and [DRY](https://en.wikipedia.org/wiki/Dry)-driven repository. You can get more information about [here](TODO). In few words, the idea behind immutable is to provide one-command deployable repository that contains everything needed to deploy itself.

## Idea
The idea behind *immutable* is to provide a repository as much as possible - 100% - immutable and without repetitions. This repository contains the code to deploy the infrastructure, a CI/CD agent and a sample application that actually is the website hosted by the infrastructure described in the repo.

## Requirements

- [aws-account](https://aws.amazon.com)
- [docker](https://www.docker.com/)

## Structure
The project is divided into several folder:

- ```root```: contains a Dockerfile to *build* a single ```builder``` based on alpine:3.8 docker image. This docker container includes everything is needed to let you deploy everything inside this repository.
- ```applications```: ideally, this folder contains ```n``` different applications to deploy in your infrastructure. In this repo, it only contain a website to show the infrastructure behind the application.
- ```infrastructure```: this folder contains the infrastructure resources definition to deploy the entire stack.

### Infrastructure
The ```infrastructure``` folder contains two folder inside, ```live``` and ```modules```. To build the infrastructure, I mainly made use of [terraform](https://github.com/hashicorp/terraform), [terragrunt](https://github.com/gruntwork-io/terragrunt),[ansible](https://github.com/ansible/ansible) and [packer](https://github.com/hashicorp/packer). terragrunt defines the folder structure at infrastructure level (see the [official doc](https://www.gruntwork.io/) for more information).

From an high level perspective, the ```live``` folder contains the configurations patterns and values for two staging enviroment, called ```dev``` and ```prod``` You can modify the project to match your requirements using some simple rules defined by [terragrunt](https://github.com/gruntwork-io/terragrunt).

The ```modules``` folder my *\*.tf* files to setup the AWS infrastructure. The folders are both configured *as much as possible* to follow the [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) approach: this was possible mostly thanks to terraform and terragrunt: unfortunately, there are still some things I would like to change/remove as soon as I understand how :)

#### The live folder
The ```live``` folder represent the environments. I defined two environments at the moment (20/10/18): both of them contains the variables init required by the modules - without the effective ```.tf``` file module definition, that describe respective resources of the module. The terraform files are defined in respective ```modules``` folder. Every enviroment contains some variables stored in two different places:

- the shared and common variables defined in the ```common.tfvars``` file in the root level of every *stage-folder*
- the modules specific variables and respective values are defined in the ```terraform.tfvars``` file in the ```live``` folder

Actually, what the environments define are the values of the variables and remote states - computed in a single terraform.tfvars but persisted, for each modules in a separate object using an s3 backend bucket (see more [here](https://www.terraform.io/docs/backends/)). In each environment, every module has a *terragrunt* statement to reach the respective terraform source files (that is **unique** and **not related to the environment**) defined in the ```modules``` folder.

#### The modules folder
The ```modules``` folder contains the terraform sources of the infrastructure. Every module is contained in a subfolder with at least one ```<module>.tf```, an ```output.tf``` and a ```variables.tf``` terraform file. These modules can be written in the same way a terraform module is usually written: the only difference is that anything in your code that should be different between environments should be exposed as an input variable - commonly declared in a ```variables.tf``` file.

In each module, the main file contains the provider definition with the reference to the aws-profile defined in your credentials plus the ```backend``` configuration as an empty reference, that will be filled in by terragrunt - more precisely, with the values specified in the global ```terraform.tfvars``` file shared across each environment in the ```live``` folder.

The states of all the modules are mantained preserved across different environment thanks to interpolated keys, using the built-in ```path_relative_to_include()``` function that, exposed by terragrunt, that *let you get the relative path between the current ```terraform.tfvars``` file and the path specified in its include block* - thus, the modules name.

Enjoy and extend!

**NOTE**: the only side effect of this approach is that the first you extend is tricky to handle cross-module resource dependencies. In order, to accomplish this you have to:

- Output the values required by the resource that has dependencies;
- Define in the environment folder the remote state key of the module(s) that contains the resource(s) you have some dependencies with - this is required by the way terragrunt work;
- Reach the remote state for each module(s) / resource(s) and get the value you need from them using the same output name you define in the first state. To have an example, look at the VPC id output example and how it is propagated to the security group module. The same happens also for the Jenkins EC2 instance.

##### Inside the modules
Inside the modules there are many folder:

- ```vpc``` contains the VPC definition, that is nothing more than a standard VPC with *n* subnets, private or public and shared across multiple availabily zone 

### Applications
TODO

## Run it

- Change the ```terraform.tfvars``` file in the ```live``` folder accordingly
- Go to one of the stage folder. To plan, run ```terragrunt plan-all```
- Enjoy watching your immutable project start

## Improvements

- Iter subnets and all involved VPC resources across both the number of avaiability zone and the number 

## Thanks
Many thanks to

- [docker](https://www.docker.com/)
- [ansible](https://github.com/ansible/ansible)
- [packer](https://github.com/hashicorp/packer)
- [terraform](https://github.com/hashicorp/terraform)
- [terragrunt](https://github.com/gruntwork-io/terragrunt)
