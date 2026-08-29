# Terraform AWS Static Site

Production styled static website infrastructure on AWS using **Terraform, Amazon S3, and Amazon CloudFront**.

This project started as a simple S3 website lab and has been modernized into a portfolio grade reference implementation focused on secure defaults, repeatable Infrastructure as Code, HTTPS delivery, and clear operational documentation.

## Architecture

```text
User
  |
  | HTTPS
  v
CloudFront
  |
  | Origin Access Control
  v
Private S3 Bucket
  |
  +-- index.html
  +-- error.html
```

The S3 bucket is intentionally **not public**. CloudFront is the only service permitted to retrieve site objects through Origin Access Control.

## What This Demonstrates

* Terraform based AWS infrastructure provisioning
* Private S3 object storage
* CloudFront content delivery and HTTPS redirect
* Origin Access Control between CloudFront and S3
* S3 public access protection
* Server side encryption
* S3 versioning
* Terraform input validation
* Infrastructure outputs for operations and automation
* Separation of cloud credentials from source code

## Technology Stack

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| AWS S3 | Private static content origin |
| AWS CloudFront | CDN and HTTPS delivery |
| AWS IAM Policy | Restricts S3 access to CloudFront |
| HTML | Static site content |

## Repository Structure

```text
.
├── main.tf          # S3, CloudFront, OAC, security controls and content objects
├── provider.tf      # Terraform and AWS provider requirements
├── variable.tf      # Validated deployment inputs
├── outputs.tf       # Deployment endpoints and resource identifiers
├── index.html       # Site homepage
└── error.html       # Custom error page
```

## Security Design

The original version of this lab used a publicly readable S3 bucket. The modernized implementation intentionally changes that architecture.

### Current controls

* S3 Block Public Access is enabled
* No AWS access keys are stored in Terraform files
* CloudFront uses Origin Access Control with SigV4 signing
* Bucket policy only permits `s3:GetObject` from the deployed CloudFront distribution
* Objects are encrypted at rest with S3 server side encryption
* S3 versioning is enabled to improve recoverability
* HTTP requests are redirected to HTTPS at CloudFront

AWS credentials should be supplied through a supported credential provider, for example an AWS profile, environment variables, IAM role, or CI/CD workload identity.

## Prerequisites

* Terraform 1.6 or newer
* AWS account
* AWS CLI credentials or another supported AWS authentication method
* Permissions to create S3, CloudFront and related IAM policy resources

## Deploy

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

Because S3 bucket names are globally unique, override the default when necessary:

```bash
terraform apply -var='bucket_name=your-unique-bucket-name'
```

After deployment, Terraform returns the CloudFront URL:

```text
cloudfront_url = https://xxxxxxxxxxxx.cloudfront.net
```

## Destroy

To remove the lab resources when finished:

```bash
terraform destroy
```

Review the plan before approval, especially in shared or production AWS accounts.

## Operational Notes

CloudFront caches content. After changing site files, a production implementation would normally include a CloudFront invalidation step in the deployment pipeline so users receive the newest version immediately.

A future iteration of this project will add:

* GitHub Actions CI validation
* Automated deployment workflow
* CloudFront cache invalidation
* Custom domain and ACM certificate
* Security scanning for Terraform
* Cost and architecture documentation

## Engineering Decisions

### Why CloudFront instead of public S3 website hosting?

Direct S3 website hosting is useful for learning, but it requires a public website endpoint. Using a private S3 origin behind CloudFront provides a stronger security model and HTTPS delivery while keeping the storage layer inaccessible directly from the internet.

### Why are credentials not configured in `provider.tf`?

Credentials do not belong in source controlled Terraform configuration. Terraform and the AWS SDK credential chain can retrieve them securely from the runtime environment.

### Why enable versioning?

Versioning improves recoverability when objects are overwritten or removed accidentally, which reflects the same operational principle used in production systems: design for recovery, not only deployment.

## Author

**Ohioze Isemede**  
Senior DevOps Engineer | SRE | Cloud Platform Engineering

[LinkedIn](https://www.linkedin.com/in/john-isemede) · [GitHub](https://github.com/ohioze)
