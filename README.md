====================================LINUX==================================

	  
-----------------------------------Day2------------------------------------


* How give sudo access to created User:
--> visudo    ctrl + X  and yes Enter
--> /etc/sudores

* Linux Group 
wheel- sudo permission wala group

we can add users who want to give sudo access


***  Cronjob  ***

open crontab guru website 

* is there any cronjob running
$crontab -l

* how to create cronjob 

$crontab -e 

sudo find / -name cron
$whereis  crontab
$locate crontab

*Local DNS=/etc/hosts

*Remote DNS= /etc/resolv.conf


-----------------------------------Day3------------------------------------


Commands:
$lsblk: List Available block devices
$df -hT: List available Disk space
$growpart /dev/

-->Scalling of compute
1. Increase/Modify existing EBS volume:
2. Add new EBS Volume and attach to instance


1. Increase/Modify existing EBS volume:

go to EC2 Console-->click on storage-->modify storage
#growpart /dev/xvda1 1
filesystem- allow to store/retrive files from volumes
#xfs_growfs -d /

2. Add new EBS Volume and attach to instance:
Create new EBS Volume it should be in same availability zone of EC2 Instance

To see filesystem
#sudo file -s /dev/xvdf: if output is data filesystem is not available

To Create filesystem
#sudo mkfs -t xfs /dev/xvdf: it will create new filesystem

No Mountpoint available in Ebs by default:
#sudo mkdir /EBSData
#sudo mount /dev/xvdf /EBSData
#lsblk
#sudo reboot

when our system is reboot mounted volume is unmount automatically,so we have to add entry into /etc/fstab to permentally mount this volume

sudo blkid
sudo vi /etc/fstab
sudo mount -a 

now reboot your instance and check for mountpoint

-->shell Scripting:

1.linux command written in specific order to achive some task.
vi install.sh

#!/bin/bash
yum install httpd -y
echo"" >> /var/www/html/index.html
yum httpd start

chmod 777 install.sh
./install.sh or bash install.sh




================================Terraform==================================

-----------------------------------Day2------------------------------------

- Manually creating resources with same configuration is difficult task
- Terraform is IAC Tool and everything is treated same as developers code and stored in git.
- Terraform is a tool for building,changing,& versioning infrastructure.

INSTALLATION:
	# Install yum-config-manager to manage your repositories.
	sudo yum install -y yum-utils
	# Use yum-config-manager to add the official HashiCorp Linux repository.
	sudo yum-config-manager --add-repo
	https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
	# sudo yum -y install terraform
	sudo yum -y install terraform
	[ec2-user@ip-172-31-4-240 ~]$ terraform version




HCL Basics:
	- HCL is HashiCorp Configuration Language.
	- variable reference is constructed with the "${var.region}" syntax.This example
references a variable named region, which is prefixed by var.
	- Strings are wrapped in double quotes.




TERRAFORM CONFIGURATION STEPS:
	- Create an EC2 instance and IAM role with required access and attach that IAM role to the EC2 Instance
	1. Create provider.tf file:
		provider "aws" {
 			region = "us-east-1"
			}

	2. To make a provider available execute terraform init command
	
	3. Create terraform resource file:
		resource "aws_vpc" "terraform_test_vpc" {
			 cidr_block = "172.31.0.0/16"
			 enable_dns_hostnames = true
			 enable_dns_support = true
			 tags = {
				 Name = "terraform_test_vpc"
				   }
			  }
      4. Terraform Validate
		- validates the configuration files in a directory.
		- verify whether a configuration is syntactically valid
		- run before the terraform plan.
 	4. terraform plan 
		- create and exucute plan it will not create/modify resource
	
	5. terraform apply
		- terraform apply command is used to apply the changes required to reach the desired state of the
configuration.
		- Terraform apply will also write data to the terraform .tfstate file.

	6. Terraform Destroy
		- terraform destroy command is used to destroy resources.
		- you can also destroy resources by removing resource block and run terraform apply




Terraform State Files:
	- Terraform stores information about your infrastructure in a state file.
	- This state is stored by default in a local file named terraform.tfstate
	- This is how terraform is aware of the provisioned resources when you run terraform plan or the resource that need to be deleted.




Creation of Remote State file:
	- By default,Terraform stores state locally in a file named terraform.tfstate.
	- With remote state, Terraform writes the state data to a remote data store, which can then be shared between all members of a team.
	- Pre-requisite:
		1. sign in into terraform cloud
		2. Create New organisation
		3. Create a new Workspace > CLI-Driven Workspace > (your_workspace_name)
		4. once workspace created example block of code will be provided
		5. add this code in backend.tf (into your current working ditectory)
		6. Workspace Settings, modify the Execution mode: Remote to Execution mode: Local >
Click on Save Settings.
		7. Navigate to User Settings > Tokens > Create an API Token > Add Description > Create API Token.
		8. Enter command terraform login (Enter the token created in the previous step.)
		9. once terrafor login is success run terraform init command


-----------------------------------Day3------------------------------------

-->Terraform Variables:
	i) Declare varible
	ii) passing value
     iii) using that value

	- Variables can have a default value.
	- default - A default value which then makes the variable optional.
 	  type - This argument specifies what value types are accepted for the variable.
	  description - This specifies the input variable's documentation.
	- supported type keywords are:
		string
		Numbers
		Boolean
		list
		map
	- string variable:
				
				variable "vpc_cidr" {
 					 type = string
					 description = "Enter the VPC CIDR Value."
 					 // default = "172.31.0.0/16"
					}
	- List Variable:
	
				variable "test_list" {
 					type = list(string)
 					default = ["Value1", "Value2"]
					}
	- Map Variable:

				variable "ami_ids" {
 					type = map
 					default = {
 						"eu-west-1" = "ami-0713f98de93617bb4"
 						"us-east-1" = "ami-062f7200baf2fa504"
 						"us-east-2" = "ami-07a0844029df33d7d"
 						}
					    }


	- Input Variable
		- users can enter values without editing the source.
				variable "vpc_cidr" {
 					 type = string
					 description = "Enter the VPC CIDR Value."
 					}


	
-->Passing Variables in Terraform:

1. Variable while executing the terraform commands:
 	
	EX: terraform apply -var="vpc_cidr=172.31.0.0/16" -var="vpc_tag_name=test_vpc_tag"


2. Variable with .tfvars file:
	Create .tfvar file
		vpc_tag_name = "dev_tf_vpc"
		vpc_cidr = "172.31.0.0/16"

	EX: terraform apply -var-file="dev.tfvars"


3. Auto tfvars files:
	- Automatically loads a number of variable in this .auto.tfvars
	- File name should exactly same terraform.tfvars or file_name.auto.tfvars
	- terraform.tfvars
			vpc_tag_name = "dev_tf_vpc_tfvars"
			vpc_cidr = "172.31.0.0/16"

	- terraform apply
	- terraform will use all variable assignment values from terraform.tfvars by default.


4.ENV Variable:
	- To use environment variables with Terraform they must have the TF_VAR prefix.
		eg: export TF_VAR_ami=ami-049d8641


-->Variable Precedence order:
	1. Any -var and -var-file options on the command line, in the order they are provided.
 	2. Any .auto.tfvars or .auto.tfvars.json files, processed in lexical order of their filenames.
	3. The terraform.tfvars.json file, if present.
	4. The terraform.tfvars file, if present.
	5. Environment variables



-->Resource Refrence:
	- one resource can be refferenced in another resource using below syntax.
		RESOURCE_TYPE.NAME.PROPERTY
		eg: vpc_id = aws_vpc.terraform_test_vpc.id

-----------------------------------Day4------------------------------------

Data Sources:


data "aws_availability_zones" "available" {}


resources ""aws_subnet" "public_test_subnet"{
	vpc_id=aws_vpc.<your_vpc_name>.id
	cidr_block = var.piblic_cidr-->declare public_cidr in 	varible.tf
	map_pubic_ip_on_launch = true-->it will assign public IP
	availability_zone = 	data.aws_availability_zone.available.names[0]

	tags = {
		name ="public_test_subnet"
		}
	}

resources ""aws_subnet" "private_test_subnet"{
	vpc_id=aws_vpc.<your_vpc_name>.id
	cidr_block = var.private_cidr-->declare private_cidr in 	varible.tf
	map_pubic_ip_on_launch = false-->it will not assign public IP
	availability_zone = 	data.aws_availability_zone.available.names[1]

	tags = {
		name ="private_test_subnet"
		}
	}


-----------------------------------Day5------------------------------------

1.count meta argument:

A)Creating multiple subnet:

main.tf file
---------------
resources "aws_subnet" "test_private_subnet"{
	count=2
	vpc_id =aws_vpc.<your_vpc_name>.id
	cidr_block=var.public_cidrs[count.index]   
	map_public_ip_on_launch   = false
  	availability_zone         = 	data.aws_availability_zones.available.names[count.index]
	
	}
----------------
resources "aws_subnet" "test_public_subnet"{
	count=2
	vpc_id =aws_vpc.<your_vpc_name>.id
	cidr_block=var.public_cidrs[count.index]   
	map_public_ip_on_launch   = true
  	availability_zone         = 	data.aws_availability_zones.available.names[count.index]
	
	}

variable.tf file
----------------
variable "public_cidrs" {
  type = list(string)
  default = ["172.31.1.0/24","172.31.3.0/24"]
}

variable "private_cidrs" {
  type    = list(string)
  default = ["172.31.2.0/24","172.31.4.0/24"]
}

-----------------

B) Launching multiple EC2 Instance:


-----------------------------------Day6------------------------------------

create 

1.networking.tf= which contain networking related resources
2.compute.tf= which contain ec2 and compute related resources
3.storage.tf= which contain storage related resources ie S3
4.IAM.tf= which store identity and access related things
5.create assumerole.json policy file

-->instance profile ARN only available in ec2 role only


-----------------------------------Day7------------------------------------

creating same resources in multiple environment

mkdir dev qa prod

one env -->one workspace -->one statefile

create individual workspace for each environment in terraform cloud

1. create backend.tf for each env accordingly
2. cloud.env value need to change according to env


-----------------------------------Day8------------------------------------

code reusability:

code files containing resources are de duplicated


modules:
	code file which are de duplicated are stored in module.
	module = child module
	main.tf = root module
	provider should be configured in root module only
	

eg:
	mkdir -p module/services/infra_services
	
	module "infra_services" {
		 source = "../modules/services/infra_services"
		 cloud_env = "dev"
 		 vpc_tag_name = "dev_vpc"
		 instance_count = "2"
 		 instance_type = "t2.micro"
 		 vpc_cidr = "172.31.0.0/16"
 		 public_cidrs = ["172.31.3.0/24","172.31.4.0/24"]
 		 private_cidrs = ["172.31.5.0/24","172.31.6.0/24"]
		 public_cidr = "172.31.1.0/24"
		 private_cidr = "172.31.2.0/24"
	 	 bucket_name = "testing-terraform-s3-bucket-data"
 	     	instance_key_name = "test-tf-key"
		}


-->In root directory keep(dev/qa/prod)
	1.provider.tf
	2.backend.tf
	3.main.tf -->which contain module defination



-->in child directory(module/services/infra_services)
	1.nw.tf
	2.compute.tf
	3.iam.tf
	4.variables.tf
	5.policy.json







===================================PYTHON==================================

-----------------------------------Day1------------------------------------

--> will use Python Scripting for automation

--> why python:
		less line of code
		python community developed lots of packages we can directly use it
1.create EC2 instance and install python
>>>print('hello world')

--> we dont need to declare variable in pythonwe can directely use it
1.variable assignment:
	msg ="hello world"
	type(msg)
	print(msg)

2.variable concatenaton:
	first="AWS"
	second="DevOps"
	fullname=first+ ' ' +second

3.python comments
	v=60 #single line comments

4.python indentation:
	- if x > 5:
		print('a is grter than 5')
		print('== PYTHON ==')
            if a ==10:
			print('a is equal to 10')
        print('i'm outside the if block')


5.conditional statement:

i) if else:

    a = 10
    if a>5:
	print('A is greater than 5')
	print('i'm in a if block')
    else:
	print('A is smaller than 5')	
	print('i'm in a else block')

ii) elif:
	age = 29
	age = 10
	if age < 5:
		ticket_price=0
	elif age < 18:
		ticket_price=50
	else age > 18:
		ticket_price=100
	print("ticket price value", ticket_price)
      
	vi test.py
	copy above code and paste it
	python3 test.py


--> python datatype:

1.List:
	- mutable in nature ie we can append,insert values
	- sequence of vlues,value can be any type
	- first value index is 0
      
      eg:
	 bikes = ['bullet' , 'ktm' , 'apache']
       print(bike)
       print(type(bike))
	

   --->Slicing a List:
  		aws_topics = ['ec2' , 's3' , 'rds' , 'IAM']
		first_two = aws_topics[:2]
            all_topics = aws_topics[:]



-----------------------------------Day2------------------------------------


2.Tuple:
	- immutable
	- sequence of vlues,value can be any type
	- eg:
	    a = (1,20,3,40,5,60) OR a= 1,20,3,40,5,60
	    print(a[2])
	- index number should be passed in square braces [] only


3.Dictionary:
	- mostely used datatype in our DevOps Journey
	- key value pair (same like Json file)
	- eg:
	     S3 = {'name':'mybucket', 'NumofObj':10}
	     print(S3['NumofObj'])
		where,
		 S3=dictionary name
		 NumofObj= Key of dictionary
           S3['region']='us-east-1'
		print(S3)


4.Input:

	name= input("enter your good name:")
	print("Hello",name)


5. while loop:
	- it will iterate untill condition becomes false


	eg:
	   1) a=10
		while a <= 10:
		  print('Current Value of a',a)
		  a += 1

	   
	   2) msg = ''
		while msg != 'quite'
		  msg = input('enter your msg:')
		  print(msg)


-----------------------------------Day3------------------------------------

1.Python Function:

	- block of code designed to perform a task.
	- using def keyword we can define our own function
	- def function_name():       ---> Function defination
		print("Enter your Msg")---> Block of code
	  function_name()  	     ---> Function Calling

       eg:
		def greet():
              print("Hello Sid...!!")
		greet()


2.Function Argument:

	- 
	- def greet(username):
              print("Hello," + username + "!")
		greet('Admin')

	A) Default Argument:

	- def greet(username='Admin'):
			print("hello",username)
		greet()
	B) def add(x,y):
		return x + y

	   sum1 = add(10,20)
	   sum2 = add(150,20)
	   print(sum1)
	   print(sum1)


3.import modules/Function in python:
	

   A)Math Module:
	- from math import pi
	- import math    -->(it will import math module from python library)
	- print(math.pi) -->it will give pie value

	- python boto3 module is usefull in our journey
	
    B)json module:
	- import json
	- json.loads()   -->string to dictionary
	- json.dumps()   -->dictionary to string


    C) SYS Module:
	- we can take input from user by using Python Input function         which is interactive we can not use it in automation scripting
	- also we can use sys.argv module to take input from user in positional argument we use in automation scripting
	- we can use positional arguments using sys module
	
	- vi sys.py
	  import sys
	  print(sys.argv)
	  print(type(sys.argv))	  
	  
	  python3 sys.py sid 24 Latur

      - vi add.py
	  import sys
	  a=sys.argv[1]
	  b=sys.argv[1]
	  sum=a+b
	  print(sum)
	  
	  python3 add.py 120 180


--> will discuss boto3 module in next session

-----------------------------------Day4------------------------------------

1.Boto3
	- Allows you to interact with AWS cloud
	- using pip3 we can install boto3 module
	  $ sudo yum update -y
	  $ sudo yum install python3-pip
	  $ pip3 install boto3 
	
	- python3
	  import boto3
	- Athentication/Autorisation
		create and attch IAM role with apropriate permission
	-
	  #!/usr/bin/env python
	  import boto3
	  ec2 = boto3.client('ec2') -->it will create boto client object to interact with EC2
	  ec2_dict=ec2.describe_instances()
	  print('ec2_dict type is', type(ec2_dict))
	  print('ec2_dict is', ec2_dict)
	- 
	  import boto3
	  s3 = boto3.client('s3')
	  s3_dict=s3.list_buckets()
	  print("S3 dict is", s3_dict)
	

===================================PYTHON==================================

-----------------------------------Day1------------------------------------

shellcript= code for linux command : bash .sh
python    = python + boto3         : python3 test.py
main.tf   = terrafrom files        : terraform apply

main.tf = 10 lines code : Day1
main.tf = 25 lines code : Day2

how will manage this changes on daily basis
--> Using version control system

Your Team : 2 Devops , 2 Developer , 2 Tester
	1.Allow you to swith/revert changes
	2.version of file stored in folder ie called repo.
	3.it will track allow history of files.
	4.who made what changes on what time.

VCS Types:
	1. Licalised   VCS:
	2. Centerlised VCS:
	3. Distrubuted VCS:
		- it has remeto repo in remote server and local repo in 		  local computer.
		

GIT:
    - it is distrubuted vcs.
    - git sit on top of your files system nd tracking your directory
    - repo is folder initialised by git.
    - create one folder and cd /your folder run git init
    - it will create .git folder for tracking your files
    - git config can be global and local: 
    - Local git repo config
		git config --local user.name "sid007"
		git config --local user.email "sid007@gmail.com"
		git config --list
    

    - working area --> staging area --> git repository
    - git add . : it will changes file from working dir to staging area
    - git rm    : git rm --cached <file> to unstage that file
    - git commit:	git commit -m "file added"
    - git log   : it will show our commit id
    - git show <commit_id> show what changes are made in file
  
	  
-----------------------------------Day2------------------------------------
	
	- 3 step of git : untracked -> staged -> commited
	- HEAD : it is pointer to latest commit in current branch
	- git log --online
	- git log -p 2 : it shows last two entries
	- git log --stat
	- git commit --amend -m "to change commit msg"
	- unstagging of stagged file:
		git reset <files_name> : staged to untrack (working area)
	- older commit massage changes:
		git log --online
		git rebase -i HEAD~3 : it will open interactive termminal
	      reword commit id change_your_commit_msg
	- you can not make changes using rebase if working tree have some 	  untracked file

	- Create github account and create one repository into github
	- public repo
	- private repo

git clone:
	- DO NOT CLONE THE REPO IN GIT INITIALISED DIRECTORY
	- navigate to dir which is not git directory
	- git clone <URL_OF_GITHUB_REPO>
	- git remote -v : it will show remote repo configuration
	
git push:
	- we use push when local repo is ahead than remote repo
	- git push uploads all local branch commits to remote branch
	- first time push command uses -u parameter
	- git push -u origin main
	- origin is remote repository of github

connection to github account:
	- genrate PAT Token
	- github > setting > developer seeting > personal access 	 	  tockens > tokens > genrate token > give_name 
	- choose expiration
	- select scope repo only 

git pull:
	- we use pull when remote repo is ahead than local repo	  
	- git pull origin main/master
	
git remote configuration:
	- git add origin <URL_OF_GITHUB_REPO>

-----------------------------------Day3------------------------------------

Git Branching:
	- branching is way of working on diffrent version of repo at time
	- by default our repo have mster/main branch
	- new branch is always copy of base branch
	- git branch -->list your all branches
	- git branch feature1 -->it will create new branch ir=e feature1
	- git checkout feature1
	- commits in features1 is only be available with feature1 only
	- git checkout master
	- commits in feature want to merge in master
	- now checkout to master and merge
		git checkout master
		git merge feature1
	- once we merge feature branch we dont have to use that branch 	  instaed youhave to create new branch
 
-----------------------------------Day4------------------------------------

Git Merging:
	- concept of adding commits from one brach to another is merging
	1. fastforward merge:
		- when all the commit in the base are already available in  		  feature branch this called fastforward merge.
	2. 3-Way Merge:
		- a 3-Way merge incase the base branch moves ahead before 		  the feature branch is already merged


-----------------------------------Day5------------------------------------

merge conflict:
	- merging two file have changes in same file on same line create conflict
	- we have to manually resolve conflict
	- code . -->it will open vs code.
	
merging in remote:
	- create new brach and push it to remote origin
	- git chekout -b iac_branch
	- add some files and commit in branch
	- git push origin <branch_name>

creating pull request(PR):
	- github login
	- click on pull request
	- base branch=main/master & compare branch= merge_branch_name
	- create pull request --> give title and description
	- now your pull request status is open -->merge pull request --> 	  cofirm now PR status is merged now
	- do not make any chane to ur child once it merged to base 

Adding user to github repo:
	- create new branch in local	
	- add some files and commit it
	- git add . && git commit -m "commit msg"
	- git push origin branch_name
	- setting--> collabarator--> manage access -->add people
	- collabarator receive one email
	- raise PR and add collabarator as reviewer 
	- once PR is approved by reviewer then only merge option enabled

-----------------------------------Day6------------------------------------

Ruleset:
	- click on repository--> Go to repo setting
	- Now click on Ruleset option
		- require pull request review before merging

.gitignore:
	- you will never have to stage or commit file that matches regular 	 	  expression in .gitignore file
	eg:
	   - vi .gitignore
	     *.pdf,*.png
	   - git add .
	   - git commit -m ""
	   - git push origin <branch_name>

Git tagging:
	- it has ability to tag specific point in repo imp history
	- typically used this for functionality to mark release point
	- listing tags
		- git tag
	- how to create tag:
		- tagging should be always created from main
		- if you not specify then tag always assigned on latest commit
		- git checkout main
		- git log --online
		- git tag -a v1.0 -m "app version 1.0"
		- git show v1.0
		- git push origin v1.0 -->push v1.0 tags to remote
		- git push origin --tags -->push all tags to remote
	- tagging for older commit:
		- git tag -a v0.9 <commit_id> -m "app version 0.9"
	
	- git log --online
		- git push origin --tags


connection to GitHub using SSH:
	- ssh-keygen -t -c "<github_email>
	- settings->gpg keys->new ssh key->copy contain of rsa.pub->save
	- Verify ssh connection:
		- ssh -t gi@github.com
	- if origin URL is https then PAT tocken will be used
	- if origin URL is ssh then PAT ssh keys will be used
	- git remote set-url origin ssh_url_of_repo
	
	
-----------------------------------Day7------------------------------------

AWS CodeCommit:
	- only private repositories will be hosted only(No Public) in codecomit
	- repository is region specific.
	- all git command used in github will be same in codecommit.
	- A pull request allow you to review,comment on and merge code 
	- we use branching strategy also
	- codecommit authentication is managed by IAM
	- AWS ROOT user login is not supported for gitcommit
	- IAM support two types of credential
	  1.HTTPS
	  2.SSH
	- git clone URL_OF_CodeCommit_repo
	- IAM user for codecommit HTTPS:
		- IAM>users>select_user/Create_user>security_credentials>HTTPS  		  git credentials for codecommit>generate.
	- codecommit SSH:
		- ssh-keygen -t rsa
		- Naviagate to IAM>USER>select/create IAM User> security 		  credentials>upload ssh public key> paste content of ssh pub 		  key>upload ssh public_key.
		- copy ssh key ID
		- on ur local create config file .ssh directory and add 		  following lines
			Host git-codecommit-*-amazon.com
			user SSH Key ID
			IdentityFile ~/.ssh/id_rsa 
			chmod 600 config
		- validate ssh connection:
		   ssh git-codecommit-us-east-1-amazon.com
		- clone repo and make changes to repo and push it
		   git clone git-codecommit-us-east-1-amazon.com
		- push all changes to remote URL


-----------------------------------Day8------------------------------------

How to restrict push to remote repo(Main/master):
	- create deny policy for master/main
	- apply that policy to IAM user/Group or role of codecommit	

PR merge option:
	- create new branch and raise PR to merge it on master.
	- create pull request (Destination=main source=feature_1)
	  1.Fast forward merge:
		- all child branch commit available in master

	  2.Squash and merge:
		- master branch
		  C1
		- child branch have four commit
		  C2,C3,C4 
		- 3 commit from child combine into single commit
		- when merge all commit will combine into one in master branch
		  After merge master will have C1,C2
		  Here C2=C2,C3,C4 
		- To avoid unnecessary commit we will use this method





==================================Docker===================================

-----------------------------------Day1------------------------------------


Docker diff:
	- docker diff container_name : it will show changes make 		  inside container after creation.
	- docker diff mycontainer

Creating Docker Images:
	
	1. Using Container:
		- BASE_IMAGE --> Create Container --> Install 				  Packages --> docker commit
		  now create image from C1 Container1
		  eg: docker commit <container_name> <new_iamge_name>

	2. Using Dockerfile:
		- write docker file with your required Env
		- FROM ubuntu:22.04
		  ARG SDLC_ARG
		  ENV SDLC_ENV=${SDLC_ARG}
		  RUN echo "arg value of SDLC_ARG IS $SDLC_ARG "
		  RUN echo "arg value of SDLC_ENV is $SDLC_ENV "
		  RUN apt-get upadate 
		  RUN apt-get install -y apache2 apache2-utils
		  RUN "Docker image created using dockerfile" > 			  /var/www/html/index.html
		  EXPOSE 80
		  CMD ["apache2ctl","-D","FOREGROUND"]

		- docker build -t myimg . --build-arg SDLC_ARG="dev" 

		- RUN instruction is excute while building image
		  CMD instruction is excute while launching container


-----------------------------------Day2------------------------------------

Docker Port_Mapping:
	- while runnning container -p option is used for port mapping 
	  eg: docker run -d -p 80:80 -t myimg
	      -p 80:80  <host_port>:<container_port>
	 	#netstat -nltp : it will show port mapping of (host EC2)
		#printenv
		docker run -d -p 80:80 -t myimg
		docker run -d -p 8080:80 -t myimg
		docker run -d -p 8888:80 -t myimg
	- using same image we have launched multiple container but on 	  host we can not use same port again

Container_Inspection:
	- #docker inspect <container_name/container_id>
	
	
-----------------------------------Day3------------------------------------

Docker image registry:
	- Amazon ECR:
	    1.Private ECR repository: 
		 - Create and attach IAM role to EC2 with permission to 		  create ECR repo and push images to ECR repository
		 - Create ECR repo using CLI
			# aws ecr create-repository --

	    2.Public ECR repository: 
		  - Create one public repository in ECR
		  - Assign IAM Role to EC2 with required permission

	- ECR Public gallery:
		- it is same like docker hub registry of Amzon ECR
		- we can download and use images of ECR gallery



-----------------------------------Day4------------------------------------

- Dockerhub :
	- On docker we have Official & Unofficial images are in 	  	  Dockerhub
	- official Image : <Image_name>
	  Unofficial Image : <username/image_name>
	
	- Create Dockerhub account:
	    - $docker login
	    - create one repository in dockerhub
	    - tag local images as per dockerhub account
	    - docker tag image_name   							<Dockerhub_Username>/Repository_name:tag 
	    - $docker tag myimg sidraut007/docker-test-repo:1.0
		$docker push sidraut007/docker-test-repo:1.0
	    - Now go to dockerhub and check your repo image is there
	   


Script for push docker image to ECR:
	- keep Dockerfile in same Directory
	- VI ecr.sh
	   #!/bin/bash
	   image=$1
	   region=$2
	   image_version=$3

	   echo "value of image is $image"
	   if ["$image" == "" ]
	   then
		echo "usage $0 <iamge name> not specified"
		exit 1
	   fi
	   
	   account=$(aws sts get-caller-identity --query Account --output text)

	   if [$? -ne 0]
	   then
		exit 255
	   fi 
	   ecr_repo_name=$iamge"ecr-repo"
	   image_name="$image-$image_version"
	   
	   echo "checking ECR repo with name $ecr_repo_name"
	   aws ecr describe-repositories --reposiotory-names ${ecr-repo_name} --region $region || aws ecr create-repository --repository-name ${ecr_repo_name} --region $region

	   aws ecr get-login-password --region $region | docker login --username AWS --password-stdin ${account}.dkr.ecr.${region}.amazonaws.com

	   docker build -t ${image_name} .
	   fullname="${account}.dkr.ecr.${region}.amazonaws.com/${ecr_repo_name}:$image_name"
	   echo "fullname is $fullname"

	   echo "tagging the local image ${image_name} with ${fullname}"
	   docker tag ${iamge_name} ${fullname}
	   docker push ${fullname}
	   if [$? -eq 0]
	   then
		echo "docker push event is succesfull with ${fullname}"
         else
		echo "docker push event failed"
	   fi

	  - bash ecr.sh myimg ap-south-1 1.3

-----------------------------------Day5------------------------------------

ENV Varibles for docker:
	- Use -e,--env, and --env-file to set ENV Variable in container you're runnning
	  eg: docker run -e MYVAR1=value01 --env SDLC_ENV=prod -it ubuntu /bin/bash
	- you can aslo load ENV Variable from files using --env-file
        vi env.list
	  VARIABLE1=val01	  
	  VARIABLE1=val02	  
	  VARIABLE1=val03	
	  $docker run --env-file env.list -it ubuntu bash

Docker Stats resources cosumption:
	- $docker stats
	- we can set memory limit to container:
	  $docker run --memory="200m" -d -p 8080:80 -t myimg
	

-----------------------------------Day6------------------------------------

Codebuild Pipeline:
	- create codecommit repository
	- create build project in codebuild
		- source provider = codecommit
		  repository      = your_repo_name
		  buildspec file  = docker_python/buildspec.yml
		  enable priviledged flag => it will build docker image
		  create project and continue
	        set ENV DOCKER_IMAGE_NAME
	
	
-----------------------------------Day7------------------------------------
 

Container files:
	- The files are always created in container space and are not directly available for other containers to read.
	-  When container killed/terminetd files created by container are lost.

Docker Volumes:
	1. Bind Volume:
		- connection from container to ditectory on the host machine
		- Any directory of your host you want to mount it into container then will use bind mount
		- Below to option are used:
		  1. -v or --volume: -v option contain three componentr
			$(pwd):/var/dat/:ro
			where:
			  $(pwd)=source
			  /var/data=mount point of container
			  ro=read only
		  eg: docker run -v $(pwd):/vat/data -it bash:latest
		   

		  2. Volume:
			- volumes are saved in /var/lib/docker/volumes/ which owned and managed by docker
			- $docker volume create datavolume
			  $docker volume ls
			  $docker volume inspect datavolume
			  $sudo ls /var/lib/docker/volumes
			  $docker volume rm datavolume

			- $docker volume create datavolume
			  $docker run -d --name=mycontainer --mount type=volume,source=datavolume,destination=/usr/share/nginx/html -p 80:80 nginx
			  $docker inspect mycontainer
			  
-----------------------------------Day8------------------------------------


Docker compose:
	- use it for defining and running multi-container docker application using docker compose file
	  eg:
	  version: "3"
	  services"
	 	web: 
		  container_name: nginx_01
		  image: nginx
		  ports:
		    - "8888:80"
		mydb:
	        container_name: mydb_01
		  image: mysql
		  ports:
		    - "3306:3306"
	- docker compose up -d 
	  docker compose down 
	- will use below command if file name is other than docker-compose.yaml	
	  $docker compose -f docker-compose-nginx up -d


ENV Variable in compose:
	  version: "3"
	  services"
	 	web: 
		  container_name: nginx_01
		  image: nginx
		  ports:
		    - "8888:80"
		  enviorment:
			- MYSQL_ROOT_PASSWORD=123456789
			  AWS_ACCESS_ID=564689222
		        ==OR==
		  env_file:
			- variable.env  create one env file


DEPLOYING APP WITH COMPOSE:
	- Docker compose log -f frontend
	- Docker compose log -f backend

