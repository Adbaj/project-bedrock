Project Bedrock
InnovateMart – Production-Grade Microservices on AWS EKS
Role: Cloud DevOps Engineer
Assessment: Barakat Third Semester Exam
Region: us-east-1 (N. Virginia)
1. Project Overview
Project Bedrock provisions a production-grade Amazon EKS cluster using Infrastructure as Code (Terraform) and deploys the AWS Retail Store Sample Application.
The solution includes:
Fully automated AWS infrastructure
Secure developer access
Observability via CloudWatch
Event-driven serverless extension (S3 → Lambda)
CI/CD automation using GitHub Actions
Remote Terraform state management (S3 + DynamoDB locking)
2. Architecture Summary
Core Infrastructure
VPC Name Tag: project-bedrock-vpc
Public + Private subnets across at least 2 AZs
NAT Gateway
Internet Gateway
EKS Cluster Name: project-bedrock-cluster
Kubernetes Version: ≥ 1.34
Managed Node Group: bedrock_nodes
OIDC Provider enabled
Namespace: retail-app
Application Layer
Retail Store Sample App deployed using Helm
All application dependencies (MySQL, PostgreSQL, Redis, RabbitMQ, DynamoDB Local) running in-cluster as required
Application exposed via LoadBalancer service
Access URL:
Copy code

kubectl get svc -n retail-app
Serverless Extension
S3 Bucket: bedrock-assets-[student-id]
Private bucket
Lambda Function: bedrock-asset-processor
Trigger: S3 ObjectCreated event
Lambda logs:
Copy code

Image received: <filename>
Observability
EKS Control Plane logging enabled:
API
Audit
Authenticator
ControllerManager
Scheduler
Amazon CloudWatch Observability Add-On installed
Application logs shipped to CloudWatch Log Groups
3. Terraform Infrastructure
All infrastructure provisioned using Terraform.
Remote State
Backend: S3
Locking: DynamoDB
Local state files NOT used
Required Terraform Outputs
The root module outputs:
cluster_endpoint
cluster_name
region
vpc_id
assets_bucket_name
Grading file generated using:
Copy code

terraform output -json > grading.json
4. Secure Developer Access
IAM User Created:
Copy code

bedrock-dev-view
Console Access
Attached AWS managed policy: ReadOnlyAccess
Kubernetes Access
IAM user mapped to EKS cluster
Associated with AmazonEKSViewPolicy
Read-only cluster permissions
Verification:
Allowed:
Copy code

kubectl get pods -n retail-app
Blocked:
Copy code

kubectl delete pod <pod-name> -n retail-app
User also has permission to:
Copy code

s3:PutObject
for the assets bucket only.
Grading credentials are submitted separately in the Google Document (not stored in repository).
5. CI/CD Automation
GitHub Actions workflow configured.
Workflow Behavior
Pull Request → runs:
Copy code

terraform plan
Merge to main → runs:
Copy code

terraform apply -auto-approve
Security:
AWS credentials stored as GitHub repository secrets
No credentials hardcoded in repository
6. How to Trigger the Pipeline
Create new branch
Push changes
Open Pull Request → triggers terraform plan
Merge PR → triggers terraform apply
Workflow file location:
Copy code

.github/workflows/terraform.yml
7. Verification Commands
Cluster:
Copy code

aws eks describe-cluster --name project-bedrock-cluster --region us-east-1
Nodes:
Copy code

kubectl get nodes
Application:
Copy code

kubectl get pods -n retail-app
kubectl get svc -n retail-app
S3:
Copy code

aws s3 ls
Lambda:
Copy code

aws lambda list-functions --region us-east-1
CloudWatch Logs:
Check EKS log groups
Check Lambda log group
Check retail-app container logs
8. Tagging Compliance
All AWS resources are tagged with:
Copy code

Project = Bedrock
(Or required assessment tag if different per final submission instructions.)
9. Repository Structure
Copy code

Terraform/
  backend.tf
  main.tf
  vpc.tf
  eks.tf
  iam.tf
  s3-lambda.tf
  outputs.tf
  variables.tf
  versions.tf

.github/workflows/
  terraform.yml

lambda/
  lambda_function.py (or index.js)
10. Final Deliverables Submitted
Public GitHub Repository Link
Architecture Diagram
Deployment Guide
grading.json committed
IAM User Access Key + Secret Key submitted via Google Doc
Application URL
All required naming conventions followed
11. Production Considerations
Remote state prevents state corruption
Least privilege IAM policies applied
Logging enabled for auditability
Serverless architecture decoupled
CI/CD ensures reproducible infrastructure
