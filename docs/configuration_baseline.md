# Configuration Baseline for AWS Resources (1.0)

Status: In Review
Created by: James Armes
Created time: March 6, 2025 3:54 PM
Last updated by: James Armes
Updated: April 3, 2025 2:24 PM
Authors: James Armes
Changes: Initial version
Document: Configuration Baseline for AWS Resources (https://www.notion.so/Configuration-Baseline-for-AWS-Resources-1ae373fd79b280d58aedda39c6b2d34f?pvs=21)
Version: 1.0

# Background

While Amazon Web Services (AWS) makes it easy to create resources, put them together, and launch an application; it requires more care to deploy **secure** resources that meet our **compliance requirements**. This document outlines a baseline for certain AWS resources.

When working with cloud resources, AWS or otherwise, we recommend using **infrastructure as code** (IaC) to manage your configuration. [OpenTofu](https://opentofu.org/) is encouraged, and we maintain a [collection of modules](https://github.com/codeforamerica/tofu-modules) to get you started. By default, the resources created by these modules meet our security and compliance requirements.

# **Account**

Most of your account related settings will be configured by an organization administrator before the account is made available. To request a new AWS account, please submit a ticket with the [IT Help Desk](https://codeforamerica.atlassian.net/servicedesk/customer/portal/1).

- Root user should *only* use a hardware device for multi-factor authentication (i.e. Yubikey)
- S3 public access should be blocked
- EBS encryption should be required in each region
- Public snapshot sharing should be disabled in each region
- A security contact should be set
- AWS Macie should be enabled on all regions

## **Existing accounts**

Special care should be taken *before* enabling certain settings for existing accounts.

- S3 public access should be block *after* ensuring existing buckets not public
- EBS encryption should be enabled *after* ensuring existing volumes are encrypted
- AWS Macie can incur high costs when scanning buckets for the first time; an inventory should be done before enabling, and any large buckets (> 100GB) that can be removed should be emptied and deleted

# **Databases**

Related modules: [aws-serverless-database](https://github.com/codeforamerica/tofu-modules-aws-serverless-database)

Databases *should never* be available directly from the public Internet. You should avoid making databases accessible from the Internet at all, but if it is necessary, you should use a network load balancer to proxy the traffic.

Databases in AWS fall into three categories:

- Aurora: Fully managed, highly scalable, and (optionally) serverless database clusters
- RDS: Managed databases instances, but you have to handle scaling and certain configuration yourself
- EC2 instances: Databases that aren’t available in the other categories, or requires self-hosting for other reasons

Aurora serverless is preferred for its hands-off approach, fault tolerance, and easy scalability. This option is more expensive, but allows for reduced costs by scaling down outside of peak hours. If your workloads will cause little scaling, it may be more appropriate to use Aurora provisioned.

All databases, regardless of their type, should adhere to the following:

- The requirements for [EC2 instances](https://docs.google.com/document/d/1gd38E3ZTCX59gF42xT5WwqedzcZLQEkXux7o-Ls6xUI/edit?tab=t.0#heading=h.kwh4fs4b13rn), where applicable
- Subnets: Databases *may* be placed in a subnet that has neither incoming or outgoing traffic to the Internet, but should otherwise be placed in a private subnet
- Monitoring: Enhanced monitoring should be enabled for Aurora and RDS databases
- Backups: Production databases should follow the guidance below, while non-production databases should use a more cost-effective retention strategy

## **Backups**

Though the process for creating backups will differ based on the database type selected, the importance of creating, retaining, and testing those backups remains the same. Your project may have specific requirements based on the type of data being stored, or contractual requirements. Use the following as a baseline when you don’t have differing requirements.

- Daily backups: Retain for 31 days
- Monthly backups: Retain for 13 months
- Yearly backups: Retained for 3 years
- Restores: Tested quarterly
- Copies: Backups should be copied to one other region

# **EC2 Instances**

EC2 instances *should not* be available directly from the public Internet. To serve traffic from an instance, you should use a load balancer or other proxy. To access instances, use [Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html) instead of SSH.

Additionally, EC2 instances should:

- Security groups: Use security groups with the minimum openings to support your use case; don’t use large shared security groups
- Instance profile: Instances should have an IAM instance profile attached (see below for requirements)
- AMI: Instances should be launched from approved images
- Sizing: Use free-tier instances when possible, especially in non-production environments; follow compute optimizer recommendations to right-size instances
- Logging & monitoring: Use the CloudWatch agent for to forward logs and metrics; detailed monitoring should be enabled
- Patching: Instances should adhere to a regular patch scheduled

## **Approved AMIs**

The following Amazon Machine Images (AMIs) are approved for use in all environments. Make sure the image you are using is tagged with “Verified provider” and “Free tier eligible”.

- Amazon Linux 2023 (preferred[¹](https://www.notion.so/Configuration-Baseline-for-AWS-Resources-1-0-1ae373fd79b280418d69e8dd55a6a694?pvs=21))
- Amazon Linux 2
- Ubuntu Server 24.04 LTS
- Ubuntu Server 22.04 LTS

If your project requires the use of a different AMI, please [open a ticket](https://codeforamerica.atlassian.net/servicedesk/customer/portal/1) and we can work with you to find a compatible image.

## **Instance Profile**

IAM instance profiles are used to enable EC2 instances to interact with the AWS APIs without needing to manage local credentials. All instances should have an instance profile attached. Instance profiles should meet the following requirements:

- Include [necessary permissions](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-instance-profile.html) for Session Manager
- Allow logs and metrics to be forwarded to CloudWatch
- Follow the principle of least privilege

## **Patching**

On EC2 instances, you are responsible for ensuring the system is regularly updated. Patches should follow the *minimum* requirements below:

- [Zero-day vulnerabilities](https://www.trendmicro.com/vinfo/us/security/definition/zero-day-vulnerability): Within 24 hours of detection
- Critical vulnerabilities: Within 15 days of detection
- High vulnerabilities: Within 30 days of detection
- Regular patching: Should be performed monthly

We recommend using ephemeral instances (instances that can be replaced) rather than long running instances. This allows systems to be “patched” by deploying a new, tested image. Regardless of your architecture or patching method, they must meet the requirements above.

You can use [Amazon Inspector](https://docs.aws.amazon.com/inspector/latest/user/what-is-inspector.html) to monitor for vulnerabilities in your instances.

# **IAM Users**

Users can access AWS using [Identity Center](https://www.notion.so/AWS-Identity-Center-e8a28122b2f44595a2ef56b46788ce2c?pvs=21), including programmatic access from their local machine. Identity and Access Management (IAM) users may be created for access from remote systems or services where alternatives, such as [cross-account roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html) and [IAM roles anywhere](https://docs.aws.amazon.com/rolesanywhere/latest/userguide/introduction.html), aren’t available. These are commonly referred to as “service accounts” or “bots.”

When creating an IAM user for programmatic access, the following restrictions apply:

- Always check if an alternative is supported
- Create a single user per connection; don’t use keys in more than one place
- Choose a name that makes the intention of the user clear
- The user *must not* have access to the AWS management console
- The user must have a policy attached that follows the principle of least privilege
- Access keys must be rotated every 90 days

# **Logging & Monitoring**

Related modules: [aws-logging](https://github.com/codeforamerica/tofu-modules-aws-logging)

AWS services offer logging to either CloudWatch logs or an S3 bucket. CloudWatch logs are great for real-time monitoring, but can be expensive for long-term storage. S3 is relatively inexpensive for long-term storage, but comes with a delay in log delivery. We use Datadog to aggregate these logs, along with metrics from CloudWatch.

Use the following guidance when configuring logging for your project:

- All resources with support for logging should be configured to do so
- Enabled enhanced monitoring when available, such as with EC2 instances and RDS databases
- [Deploy the Datadog forwarder](https://www.notion.so/Deploy-Datadog-AWS-Integration-efaf8e6d42bb472284c77ad25c976804?pvs=21) to all regions the project will operate in
- Prefer CloudWatch logs for real-time monitoring
- CloudWatch logs should have a retention period of 30 days, unless otherwise necessary
- Use a customer manager key (CMK) to encrypt your CloudWatch logs
- S3 logs should be retained for at least 90 days
- See [S3 buckets](https://docs.google.com/document/d/1gd38E3ZTCX59gF42xT5WwqedzcZLQEkXux7o-Ls6xUI/edit?tab=t.0#heading=h.4vsw87wz9v2s) to configure your bucket for logging
- [Configure Datadog](https://docs.datadoghq.com/logs/guide/send-aws-services-logs-with-the-datadog-lambda-function/?tab=awsconsole) log ingestion

# **S3 Buckets**

S3 buckets should *never* have public access enabled. If you believe you have a use case for a public S3 bucket, there is often a safer alternative. Please [file a ticket](https://codeforamerica.atlassian.net/servicedesk/customer/portal/1) if you need support with this.

- Logging: Access logs should be configured to target a logging bucket
- Encryption: Use a customer managed key (CMK) to encrypt buckets when possible; avoid using the AWS managed key unless *absolutely necessary*
- Versioning: Object versioning should be enabled
- Object lock: Object locking should be configured to prevent accidental deletions or overwrites
- Lifecycle policy: Buckets should include a lifecycle policy that meets compliance, as well as a any contractual requirements, based in the type of data
- SSL enforcement: The bucket policy should [require SSL](https://repost.aws/knowledge-center/s3-bucket-policy-for-config-rule)
- Replication: Production buckets should be configured with cross-region replication; this is recommended for production-like environments (e.g. staging) but not required

## **Infrastructure State Buckets**

Buckets used to store infrastructure state for OpenTofu will have a few exceptions:

- Object lock: The state file can change often, with versioning and locking using DynamoDB, the S3 object lock is unnecessary and can interfere with operations
- Replication: Infrastructure resources are region-specific and can be rebuilt using IaC, making replication unnecessary

## **Logging Buckets**

Logging buckets are exempt from a few of these requirements:

- Logging: Access logs *cannot* be configured without creating a circular reference
- Lifecycle policy: Logs should transition to a storage storage class designed for long-term storage, such as infrequent access or glacier, and be retained for at least 90 days
- Encryption: Logging buckets *must use* the AWS managed key due to limitations with logging for some AWS services
- Replication: Replication *may* be configured for logging buckets, but since we ingest these logs into DataDog, it is not necessary

# **VPC**

Related modules: [aws-vpc](https://github.com/codeforamerica/tofu-modules-aws-vpc)

If you’re launching any compute resources, whether they be provisioned or serverless, you will need to configure networking. If you haven’t been assigned a CIDR block, [open a ticket](https://codeforamerica.atlassian.net/servicedesk/customer/portal/1) to request one.

All VPCs should be configured with the following:

- Subnets: Public and private subnets in at least two availability zones (three recommended[²](https://www.notion.so/Configuration-Baseline-for-AWS-Resources-1-0-1ae373fd79b280418d69e8dd55a6a694?pvs=21)) for high availability (HA)
- Logging: Flow logs should be configured with a CloudWatch log group
- Internet gateway: Configured on public subnets
- NAT gateway: Each private production subnet should include a NAT gateway; non-production subnets may share a single gateway to reduce costs
- VPC endpoints: [Endpoints](https://docs.google.com/document/d/1gd38E3ZTCX59gF42xT5WwqedzcZLQEkXux7o-Ls6xUI/edit?tab=t.0#heading=h.gwtrhgnvqbni) should be configured for any AWS services that may be accessed from within the VPC
- Security groups: The default security group should not allow *any* inbound or outbound traffic; create purpose-built security groups with minimum openings

## **Subnets**

Private subnets should be used for your compute resources, along with any other resources that will not be directly available from the public Internet. In production environments, each private subnet should include a NAT gateway. You may use a single NAT gateway in non-production environments to reduce costs, but this would not meet the definition of HA.

Public subnets should be used for your edge resources that will be directly available from the public Internet. *Compute resources, whether they be **EC2 instances, databases, lambdas, etc.** should **never be placed in public subnets**.* Use edge resources like load balancers to serve traffic. If you need to connect to EC2 instances in your VPC, you can use [Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html) to do so without the need for an SSH bastion.

## **VPC endpoints**

[VPC endpoints](https://docs.aws.amazon.com/whitepapers/latest/aws-privatelink/what-are-vpc-endpoints.html) enable resources in a VPC to communicate with Amazon’s APIs over a private network. This reduces costs, since traffic doesn’t go through a NAT gateway, and improves security as the traffic does not need to traverse the public Internet.

At a minimum, the following endpoints should be created and attached to your private subnets:

- ec2
- ec2messages
- ecr.api
- ecr.dkr
- guardduty-data
- s3
- ssm
- ssm-contacts
- ssm-incidents
- ssmmessages

# **Resources Not Covered by This Document**

For resources not covered by this document, you are responsible for ensuring the resources you create are secure and meet our compliance requirements. Check the [shared OpenTofu modules](https://github.com/codeforamerica/tofu-modules) to check if someone has already created a module to use as a starting point. Be sure to follow the [additional guidance](https://docs.google.com/document/d/1gd38E3ZTCX59gF42xT5WwqedzcZLQEkXux7o-Ls6xUI/edit?tab=t.0#heading=h.71y3vmvqmyzy) below; the services mentioned will help you to find the proper configuration for your resources. If you require further assistance, don’t hesitate to open a [help desk ticket](https://codeforamerica.atlassian.net/servicedesk/customer/portal/1).

# **Additional Guidance**

AWS provides a number of services to help monitor the security and compliance of your resources. While our security teams monitor our posture regularly, it is ultimately up to service operators to maintain their environments in compliance.

Use the following guidelines to keep your accounts and resources in compliance[³](https://www.notion.so/Configuration-Baseline-for-AWS-Resources-1-0-1ae373fd79b280418d69e8dd55a6a694?pvs=21).

- Update IaC dependencies: Keep your module and provider dependencies up to date to get the latest baseline configurations
- Security Hub: Use [AWS Security Hub](https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html) to monitor the posture of your environment; open a help desk ticket if you believe you have encountered a false positive or need help satisfying controls
- Inspector: Monitor [Amazon Inspector](https://docs.aws.amazon.com/inspector/latest/user/what-is-inspector.html) for vulnerabilities in your instances or container images
- Cost Explorer: Use [AWS Cost Explorer](https://docs.aws.amazon.com/cost-management/latest/userguide/ce-exploring-data.html) to keep an eye on costs; unexpected changes in usage can be a sign of compromised account
- Macie[⁴](https://www.notion.so/Configuration-Baseline-for-AWS-Resources-1-0-1ae373fd79b280418d69e8dd55a6a694?pvs=21): [Amazon Macie](https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html) detects sensitive data in your S3 buckets, along with the configuration of buckets containing sensitive data
- Use a static analysis tool such as [trivy](https://trivy.dev/latest/) to verify your IaC

# **Further Reading**

Links to various services and documentation have been included in the relevant sections. Below you will find links to additional documentation and resources that you mind find helpful.

- [Amazon Web Services on Notion](https://www.notion.so/Amazon-Web-Services-6b8b38f0189940588af9506166075f40?pvs=21)
- [Code for America OpenTofu modules documentation](https://dev.docs.cfa.codes/tofu-modules/index.html)
- [Code for America Infrastructure Guild](https://www.notion.so/Infrastructure-Guild-0a3f4bbe25d34d0fbd363df1e87e3f71?pvs=21)
- [AWS Workshops](https://workshops.aws/)

¹ Amazon Linux 2023 is based on Fedora and CentOS, and comes configured with log and metric collection.

² While only two AZs are required to meet HA, three ensure you remain HA if one AZ goes down.

³ The AWS services in this list are configured by the organization and are available to you with no extra steps.

⁴ Amazon Macie is not currently enabled for all accounts. If you would Macie enabled for your account, please open a help desk ticket.
