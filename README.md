# The immutable repository

***immutable*** represents my best implementation of an immutable and [DRY](https://en.wikipedia.org/wiki/Dry)-driven repository. You can get more information about [here](TODO). In few words, the idea behind immutable is to provide one-command deployable repository that contains everything needed to deploy itself.

## Idea

The idea behind *immutable* is to provide a repository as much as possible - 100% - immutable and without repetitions. This repository contains the code to deploy the infrastructure, the server, the CI/CD and a sample application that actually is a website hosted by the infrastructure described in this repository. It's an autonomous repository.

## Requirements

- [aws-account](https://aws.amazon.com)
- [docker](https://www.docker.com/)

## Structure

The project is divided into several folder:

- ```root```: contains a Dockerfile to *build* a unique ```builder``` based on alpine:3.8 docker image. This docker container includes everything is needed to let you deploy everything inside the repository.
- ```applications```: ideally, this folder contains ```n``` different application (source code) you want to deploy in your infrastructure. In this repo, it only contain the website to show the infrastructure behind the application.
- ```infrastructure```: this folder contains the infrastructure resources to deploy the entire stack.

### Infrastructure

The infrastructure folder contains two folder inside, ```live``` and ```modules```. To build the infrastructure, I mainly made use of [ansible](https://github.com/ansible/ansible), [packer](https://github.com/hashicorp/packer), [terraform](https://github.com/hashicorp/terraform) and [terragrunt](https://github.com/gruntwork-io/terragrunt). The latter define the folder structure at infrastructure level (see the [official doc](https://www.gruntwork.io/) for more information).

From high level perspective, the ```live``` folder contains the configurations patterns and values for two staging enviroment, called ```dev``` and ```prod``` You can modify the project to match your requirements using some simple rules defined by [terragrunt](https://github.com/gruntwork-io/terragrunt).

The ```modules``` folder my *\*.tf* files to setup the AWS infrastructure. Both the two folder are configured as much as possible to follow the [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) approach, mostly thanks to [terragrunt](https://github.com/gruntwork-io/terragrunt): unfortunately, there are still some repetition I would like to remove as soon as I understand how :)

#### The live folder

As already said, the ```live``` folder represent the environments. I have define two environments at the moment (20/10/18): both of them contains the deployment descriptions of different modules - without the effective ```.tf``` files that describe respective resources, defined in respective ```modules``` folder. Every enviroment are defined by some variables stored in two different places:

- the shared and common variables defined in the ```common.tfvars``` file in the root level of every stage-folder
- the modules specific variables and respective values are defined in the ```terraform.tfvars``` file in the ```live``` folder

Actually, what the environments define are the values of the variables and remote states - computed in a single terraform.tfvars but persisted, for each modules in a separate object using an s3 backend bucket (see more [here](https://www.terraform.io/docs/backends/)). In each environment, every module has a *terragrunt* statement to reach the respective terraform source files (that is unique and not environment related) defined in the ```modules``` folder.

#### The modules folder

The ```modules``` folder contains the terraform codes of the modules part of the infrastructure. Every module is contained in a subfolder with at least one ```<module>.tf```, an ```output.tf``` and a ```variables.tf``` terraform file. These modules can be written in the same way a terraform module is usually written: the only difference is that anything in your code that should be different between environments should be exposed as an input variable - I prefer to separate them into a ```variables.tf``` file.

In each module, the main file contains the provider definition with the reference to the profile in credentials plus the ```backend``` configuration empty reference, that will be filled in by terragrunt - more precisely, with the values specified in the global ```terraform.tfvars``` file in the ```live``` folder.

The states of all the modules are mantained preserved across different keys using the built-in ```path_relative_to_include()``` function that, by design, *let you get the relative path between the current ```terraform.tfvars``` file and the path specified in its include block* - thus, the modules name.

Enjoy and extend!

**NOTE**: the only side effect of this approach is that is tricky to handle cross-module resource dependencies. In order, to accomplish this you have to:

- Output the values required by the resource that has dependencies;
- Define in the environment folder the remote state key of the module(s) that contains the resource(s) you have some dependencies with - this is required by the way terragrunt work;
- Reach the remote state for each module(s) / resource(s) and get the value you need from them using the same output name you define in the first state. To have an example, look at the VPC id output example and how it is propagated to the security group module.

### Applications

TODO

## Run it

- Change the ```terraform.tfvars``` file in the ```live``` folder accordingly
- Go to one of the stage folder. To plan, run ```terragrunt plan-all```
- Enjoy watching your immutable project start

## Thanks

Many thanks to

- [docker](https://www.docker.com/)
- [ansible](https://github.com/ansible/ansible)
- [packer](https://github.com/hashicorp/packer)
- [terraform](https://github.com/hashicorp/terraform)
- [terragrunt](https://github.com/gruntwork-io/terragrunt)
