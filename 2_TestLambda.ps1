aws lambda invoke --function-name infoline-login-function --cli-binary-format raw-in-base64-out --payload file://AT1_Infrastructure/test-admin.json --region eu-west-3 response.json | Out-Null
Get-Content response.json
aws lambda invoke --function-name infoline-login-function --cli-binary-format raw-in-base64-out --payload file://AT1_Infrastructure/test-invalid.json --region eu-west-3 response.json | Out-Null 
Get-Content response.json
aws lambda invoke --function-name infoline-login-function --cli-binary-format raw-in-base64-out --payload file://AT1_Infrastructure/test-missing.json --region eu-west-3 response.json | Out-Null
Get-Content response.json
aws lambda invoke --function-name infoline-login-function --cli-binary-format raw-in-base64-out --payload file://AT1_Infrastructure/test-user.json --region eu-west-3 response.json | Out-Null
Get-Content response.json
aws logs tail /aws/lambda/infoline-login-function --region eu-west-3 --since 1m