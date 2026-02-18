output "cluster_name" {
    value = module.eks.cluster_name
}

output "cluster_endpoint" {
    value = module.eks.cluster_endpoint
}

output "lambda_function_name" {
    description = "Name of the Lambda function"
    value       = aws_lambda_function.login.function_name
}