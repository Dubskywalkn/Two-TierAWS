# Two-TierAWS
Two-Tier AWS Architecture

Overview
This project implements a two-tier architecture on AWS using Terraform. The infrastructure includes a VPC, public and private subnets, internet gateway, security groups, and EC2 instances in a two-tier configuration. The architecture is designed for hosting a web server and a database server, following a secure and scalable pattern.

Project Structure
Two-TierAWS/
├── modules/                   # Optional: Folder for reusable Terraform modules
│   ├── ec2/                   # Module for EC2 instances
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── rds/                   # Module for RDS instances
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── vpc/                   # Module for VPC and networking
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── main.tf                    # Root Terraform file to bring all modules together
├── variables.tf               # Global variable definitions
├── outputs.tf                 # Global output definitions
├── provider.tf                # Provider configurations (e.g., AWS region)
├── terraform.tfvars           # Optional: Environment-specific variables
├── .gitignore                 # Git ignore file for Terraform files and sensitive information
├── README.md                  # Project overview and documentation
├── docs/                      # Documentation folder for additional project resources
│   ├── architecture-diagram.png  # Architecture diagram image
│   └── notes.md               # Optional: Additional notes or documentation
└── scripts/                   # Optional: Any helper scripts
    └── setup.sh               # Example setup script if any additional setup is required


Prerequisites
Terraform: Installed on your local machine (mention required version if needed).
AWS CLI: Configured with necessary permissions to deploy resources.
Git: For version control and pushing code changes.

Getting Started
Clone the Repository:
git clone git@github.com:Dubskywalkn/Two-TierAWS.git
cd Two-TierAWS

Initialize Terraform:
terraform init

Run Terraform Plan:
terraform plan
This command shows you what Terraform will create without actually making any changes.

Apply Terraform Configuration:
terraform apply
Type yes to confirm and deploy the infrastructure.

Accessing Resources:
Once deployed, Terraform will output useful information, such as the public IP of the web server and the database endpoint.
Cleanup
To delete all resources created by this project, run:
terraform destroy

Security Considerations
IAM Roles and Policies: Ensure that your AWS credentials have the least privilege required for this deployment.
Secrets Management: Avoid hardcoding sensitive information in your Terraform files. Use environment variables or secret management solutions for passwords and keys.
Future Improvements
Scalability: Add an Auto Scaling Group for the web tier.
Load Balancing: Integrate an AWS Load Balancer for high availability.
Monitoring and Logging: Configure CloudWatch for log monitoring and alerting.


Created by Dubskywalkn - [GitHub Profile](https://github.com/Dubskywalkn)
