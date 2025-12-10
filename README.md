# Dynamic Terraform Test - Preview Environments

This project demonstrates how to manage multiple isolated Terraform environments using dynamic backend configuration and variable passing via CLI. It's designed for testing preview environments per pull request, where each PR gets its own state file and resources.

## What This Does

Creates isolated S3 buckets for each pull request environment using:
- **Dynamic backend keys** - Each PR has its own state file in the same S3 bucket
- **Variable-driven resources** - Resources are named using the PR number
- **Terraform AWS S3 Module** - Uses the official AWS S3 bucket module

## Project Structure

```
.
├── config.tf          # Provider config and S3 backend configuration
├── main.tf            # Main resources - creates PR-specific S3 buckets
└── backend/           # Backend setup (creates the state bucket)
    ├── config.tf
    └── main.tf
```

## Prerequisites

- Terraform >= 1.13.0
- AWS credentials configured
- An existing S3 bucket for state storage (see backend/ directory)

## Usage

### Creating and Managing PR Environments

Each PR environment requires three steps:

1. **Initialize with PR-specific state key**
2. **Plan and apply with PR number variable**
3. **Destroy when done**

### Example Commands

#### Option 1: Using CLI Flags (Inline)

**PR #123:**
```bash
terraform init -reconfigure -backend-config="key=terraform/state/preview-envs/pr-123/terraform.tfstate"
terraform plan -var="pr_number=123" -out pr-123.plan
terraform apply pr-123.plan
terraform destroy -var="pr_number=123" -auto-approve
```

**PR #345:**
```bash
terraform init -reconfigure -backend-config="key=terraform/state/preview-envs/pr-345/terraform.tfstate"
terraform plan -var="pr_number=345" -out pr-345.plan
terraform apply pr-345.plan
terraform destroy -var="pr_number=345"
```

**PR #678:**
```bash
terraform init -reconfigure -backend-config="key=terraform/state/preview-envs/pr-678/terraform.tfstate"
terraform plan -var="pr_number=678" -out pr-678.plan
terraform apply pr-678.plan
terraform destroy -var="pr_number=678"
```

#### Option 2: Using Configuration Files

For cleaner commands and better organization, you can use configuration files instead of CLI flags.

**Backend Configuration File (`backend.hcl`):**

Create a backend configuration file for each PR environment:

```hcl
# backend-pr-123.hcl
key = "terraform/state/preview-envs/pr-123/terraform.tfstate"
```

**Variable Configuration File (`terraform.tfvars` or `*.tfvars`):**

Create a variable file for each PR environment:

```hcl
# pr-123.tfvars
pr_number = 123
```

**Usage with Configuration Files:**

```bash
# PR #123
terraform init -reconfigure -backend-config=backend-pr-123.hcl
terraform plan -var-file="pr-123.tfvars" -out pr-123.plan
terraform apply pr-123.plan
terraform destroy -var-file="pr-123.tfvars" -auto-approve

# PR #345
terraform init -reconfigure -backend-config=backend-pr-345.hcl
terraform plan -var-file="pr-345.tfvars" -out pr-345.plan
terraform apply pr-345.plan
terraform destroy -var-file="pr-345.tfvars"
```

**Benefits of Using Configuration Files:**
- Cleaner, more readable commands
- Easier to track and version control (if needed)
- Reduce risk of typos in CLI parameters
- Can include multiple backend/variable settings in one file

## Key Concepts

### Dynamic Backend Configuration
The backend key is set via CLI during `terraform init`, allowing multiple isolated state files in the same S3 bucket:
```bash
-backend-config="key=terraform/state/preview-envs/pr-{NUMBER}/terraform.tfstate"
```

### Variable Passing
The PR number is passed as a variable to name resources uniquely:
```bash
-var="pr_number=123"
```

### Benefits
- **Isolated state** - Each PR has its own state file, preventing conflicts
- **Resource isolation** - Each PR creates separate AWS resources
- **Easy cleanup** - Destroy resources per PR without affecting others
- **No workspace complexity** - Uses backend config instead of Terraform workspaces

## Resources Created

For each PR environment:
- 1 S3 bucket named `pr-{NUMBER}-{random}-{region}`

## Cleanup

To destroy a specific PR environment:
```bash
terraform init -reconfigure -backend-config="key=terraform/state/preview-envs/pr-{NUMBER}/terraform.tfstate"
terraform destroy -var="pr_number={NUMBER}" -auto-approve
```
