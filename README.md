## Two-TierAWS

### Two-Tier AWS Architecture

**Overview**  
This project implements a two-tier architecture on AWS using Terraform. The infrastructure includes a VPC, public and private subnets, internet gateway, security groups, and EC2 instances in a two-tier configuration. The architecture is designed for hosting a web server and a database server, following a secure and scalable pattern.

### Project Structure

Two-TierAWS/ ├── modules/ # Optional: Folder for reusable Terraform modules │ ├── ec2/ # Module for EC2 instances │ │ ├── main.tf │ │ ├── variables.tf │ │ └── outputs.tf │ ├── rds/ # Module for RDS instances │ │ ├── main.tf │ │ ├── variables.tf │ │ └── outputs.tf │ └── vpc/ # Module for VPC and networking │ ├── main.tf │ ├── variables.tf │ └── outputs.tf ├── main.tf # Root Terraform file to bring all modules together ├── variables.tf # Global variable definitions ├── outputs.tf # Global output definitions ├── provider.tf # Provider configurations (e.g., AWS region) ├── terraform.tfvars # Optional: Environment-specific variables ├── .gitignore # Git ignore file for Terraform files and sensitive information └── README.md # Project overview and documentation


### Prerequisites

- **Terraform**: Installed on your local machine (mention required version if needed).
- **AWS CLI**: Configured with necessary permissions to deploy resources.
- **Git**: For version control and pushing code changes.

### Getting Started

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/Dubskywalkn/Two-TierAWS.git
   cd Two-TierAWS
terraform init
terraform plan
terraform apply
terraform destroy

Security Considerations
IAM Roles and Policies: Ensure that your AWS credentials have the least privilege required for this deployment.
Secrets Management: Avoid hardcoding sensitive information in your Terraform files. Use environment variables or secret management solutions for passwords and other sensitive data.

### Explanation of Changes

- **Spacing and Structure**: Each section is spaced out to improve readability.
- **Code Blocks**: The project structure is within a code block, which preserves indentation and makes it visually organized.
- **Commands**: Important commands are formatted in code blocks to differentiate them from regular text.
- **Headings and Subheadings**: Used consistently to create a clear flow.

This format is more visually appealing and organized, making it easy for others to understand and follow.
