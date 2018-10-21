# immutable

**immutable** represents my best implementation of an immutable repository. You can get more information [here](#).

## Requirements

- [docker](https://www.docker.com/)

## Description

This project contains my personal [terraform](https://github.com/hashicorp/terraform) files configured as much as possible by following the [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) approach, mostly thanks to [terragrunt](https://github.com/gruntwork-io/terragrunt) to setup an AWS account.

## Structure

The project is divided into two folder, ```live``` and ```module```. You can modify the project to match your requirements using some simple rules defined by [terragrunt](https://github.com/gruntwork-io/terragrunt)

### live folder

The ```live``` folder represent your environments. I have two environments defined at the moment (20/10/18): both of them contains the deployment descriptions of different modules, without the ```.tf``` specification, that are instead defined in the ```module``` folder. Every enviroment share some common variables - and respective values - defined in the ```terraform.tfvars``` file in the ```live``` folder. 

In each environment, every module has a terragrunt statement to reach the respective terraform source code (the only one) defined in the module folder.

### modules folder

The ```modules``` folder contains your modules - the terraform code. Every module is contained in a subfolder with at least one ```<module>.tf``` file, an ```output.tf``` and a ```variables.tf``` terraform file. These module can be written in the same way you usually write a terraform module: the only difference is that anything in your code that should be different between environments should be exposed as an input variable - I prefer to separate them into a ```variables.tf``` file. 

In each module, the main file contains the provider definition with the reference to the profile in credentials plus the ```backend``` configuration empty reference that will be filled in by Terragrunt - more precisely by the values specified in the global ```terraform.tfvars``` file in the ```live``` folder.

The state is mantained preserved across different keys using the built-in ```path_relative_to_include()``` function that let you get the relative path between the current ```terraform.tfvars``` file and the path specified in its include block - thus, the modules name.

Enjoy and extend!

## Run it

- Change the ```terraform.tfvars``` file in the ```live``` folder accordingly.
- Go to one of the stage folder. To plan, run ```terragrunt plan-all```


## Thanks

Many thanks to
- [ansible](https://github.com/ansible/ansible)
- [packer](https://github.com/hashicorp/packer)
- [terraform](https://github.com/hashicorp/terraform)
- [terragrunt](https://github.com/gruntwork-io/terragrunt)
