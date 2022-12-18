AWS_PROFILE=default \
./terraform plan \
-input=false \
-var-file=./terraform.tfvars -var 'env=dev' \
-out="plan.tfplan" 
