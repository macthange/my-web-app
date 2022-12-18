# my-web-app

Here is my proposed  solution for the Used case.


Step to create a completed infra:


#Need to run this aws cli command on your local system create S3 bucket to store terraform tfstate and dynamodb to store tfstate lock.
#This is one time task


1) #Export the AWs crdentional 
#In  Jenkins we can store creention on credentials  manger or if jenkins is running on AWs ec2 we can use IAM role and avoide exposing  credentials  to os 
#we can store credentials  in gitlab registry if we use gilab runner for CI/CD pipeline we can mask these valu so it will not exposed on pipeline output 

$export AWS_ACCESS_KEY_ID="<your access key>"

$export AWS_SECRET_ACCESS_KEY="<your secret key"
$export AWS_REGION="us-east-1"
#
2)  create S3 bucket
$aws s3 ls | grep -i tfbackend-my-web-app-bucket || aws s3 mb s3://tfbackend-my-web-app-bucket --region us-east-1 && aws s3api put-bucket-versioning --bucket tfbackend-my-web-app-bucket  --versioning-configuration Status=Enabled 

3) create dynamodb tables for tflockstate

$aws dynamodb list-tables | grep -i tflockstate-my-web-app-table || aws dynamodb create-table --table-name tflockstate-my-web-app-table --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=2,WriteCapacityUnits=2

 4) 
#Download the code from repo
 $git clone https://github.com/macthange/my-web-app.git


5) 
#cd to packer to create encripted AMI

#Validate syntax in .hcl file 
$./packer validate vm.pkr.hcl
#  build packer image 
$./packer.exe build vm.pkr.hcl

6) 
#cd to the project dir (asg_terraform or ec2_terraform )and genrate ssh key this key will be used to access ec2instance, run ansible playbook etc.
$ssh-keygen -f mykey 

#Initialize Terraform Configuration 
$./terraform init

#Create a Terraform Plan to Verify to what resorces will be create 
$./terraform plan

#to create resources
$./terraform apply
 
#to destory the resources
$./terraform desrtoy 

######   or
# run  aws configure update your aws credentional local system 
#In  Jenkins we can store creention on credentials  manger or if jenkins is running on AWs ec2 we can use IAM role and avoide exposing  credentials  to os 
#we can store credentials  in gitlab registry if we use gilab runner for CI/CD pipeline

#Initialize Terraform Configuration 
$sh tf_init.sh

#Create a Terraform Plan to Verify to what resorces will be create 
$sh tf_plan.sh

#to create resources
$sh tf_apply.sh#

#to destory the resources
$sh tf_destroy.sh

