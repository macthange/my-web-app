# my-web-app


#Create S3 bucket to stoke traform remote state file 
aws s3 ls | grep -i tfbackend-my-web-app || aws s3 mb s3://tfbackend-my-web-app --region us-east-1 && aws s3api put-bucket-versioning --bucket tfbackend-my-web-app  --versioning-configuration Status=Enabled 

#create dynamodb tables for tflockstate

aws dynamodb list-tables | grep -i tflockstate-my-web-app || aws dynamodb create-table --table-name tflockstate-my-web-app --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=2,WriteCapacityUnits=2
