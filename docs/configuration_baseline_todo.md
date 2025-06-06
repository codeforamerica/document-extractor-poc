# Configuration Baseline TODO

This document summarizes all findings from the compliance review of the current infrastructure-as-code (IaC) configuration, based on the [AWS Configuration Baseline Policy](../path/to/policy). Each section below lists areas that are out of compliance or could be improved, along with recommended actions.

## ✅ Implementation Status

**COMPLETED:** 🎉 Major infrastructure baseline compliance work has been completed!

**Key Achievements:**
- ✅ **VPC Infrastructure** - Complete security isolation with private subnets, VPC endpoints, and proper networking
- ✅ **Encryption** - All services using customer-managed KMS keys with proper rotation
- ✅ **Logging & Monitoring** - Comprehensive CloudWatch logging, Security Hub, and cost monitoring
- ✅ **Backup & Recovery** - Automated backups for DynamoDB with proper retention policies
- ✅ **Security Controls** - SSL enforcement, security headers, least privilege IAM policies
- ✅ **Dead Letter Queues** - Error handling for all async processing

**Remaining Items:**
- Cross-region replication for S3 (optional for non-prod)
- WAF integration for CloudFront (optional security enhancement)
- Amazon Macie enablement (requires help desk ticket)
- Datadog integration (if external logging desired)

---

## **CRITICAL: Missing VPC Infrastructure**

### Findings

- **No VPC Defined:**
  All resources are deployed in the default VPC, which doesn't meet baseline requirements.
- **No Subnet Architecture:**
  Missing public/private subnet separation across multiple AZs.
- **No Network Security:**
  No custom security groups, route tables, or network ACLs defined.

### Action Items

- [x] **Create VPC** with proper CIDR block allocation
- [x] **Deploy subnets** in at least 2 AZs (3 recommended) with public/private separation
- [x] **Configure Internet Gateway** for public subnets
- [x] **Deploy NAT Gateways** for each private subnet (production) or shared (non-production)
- [x] **Enable VPC Flow Logs** to CloudWatch with 30-day retention and CMK encryption
- [x] **Create VPC Endpoints** for AWS services (s3, dynamodb, lambda, sqs, ssm, ssmmessages, ec2messages, kms, secretsmanager, logs)
- [x] **Configure Security Groups** with least privilege rules
- [x] **Disable default security group** (no inbound/outbound rules)
- [x] **Move all Lambda functions** to private subnets
- [x] **Configure proper route tables** for public/private subnet routing

---

## S3 Buckets

### Findings

- **Encryption with CMK:**
  No explicit `server_side_encryption_configuration` using a customer-managed KMS key (CMK) is set for S3 buckets.
- **Versioning:**
  Versioning is enabled for the `website_storage` bucket, but not for `document_storage`.
- **Object Lock:**
  No object locking configured to prevent accidental deletions or overwrites.
- **Access Logging:**
  No access logging is configured for any S3 bucket.
- **SSL Enforcement:**
  No bucket policy is present to enforce SSL (deny non-SSL requests).
- **Cross-Region Replication:**
  No cross-region replication is configured for production buckets.
- **Lifecycle Policy:**
  Only the `document_storage` bucket has a lifecycle policy; others may need review.

### Action Items

- [x] Add `server_side_encryption_configuration` with a CMK to all S3 buckets.
- [x] Enable versioning on all S3 buckets.
- [x] **Configure object locking** to prevent accidental deletions or overwrites.
- [x] Configure access logging for all S3 buckets.
- [x] Add a bucket policy to enforce SSL (`"aws:SecureTransport": "false"` deny).
- [ ] Configure cross-region replication for production S3 buckets.
- [x] Review and add lifecycle policies to all buckets as appropriate.

---

## IAM

### Findings

- **Least Privilege:**
  Lambda execution roles have broad permissions (e.g., `dynamodb:*`, `s3:*`, `secretsmanager:*`, `sqs:*`). These should be scoped to only the required actions and resources.

### Action Items

- [x] Refine IAM policies to follow the principle of least privilege, granting only necessary actions on specific resources.

---

## IAM Users

### Findings

- **Service Account Management:**
  No evidence of proper IAM user management for programmatic access.
- **Access Key Rotation:**
  No automated or documented access key rotation process.

### Action Items

- [ ] **Review existing IAM users** and ensure they follow service account best practices
- [ ] **Implement access key rotation** every 90 days for any IAM users
- [ ] **Ensure no console access** for programmatic IAM users
- [ ] **Document IAM user purposes** and usage locations
- [ ] **Consider alternatives** like cross-account roles or IAM Roles Anywhere where possible

**Note:** No IAM users are currently used in this infrastructure - all access is role-based.

---

## Lambda Functions

### Findings

- **CloudWatch Log Groups:**
  No explicit log groups with retention and encryption configured.
- **Dead Letter Queues:**
  No DLQ configuration for failed executions.
- **Reserved Concurrency:**
  Set to unlimited (-1) which could impact other functions.
- **VPC Configuration:**
  Functions are not deployed in VPC private subnets.

### Action Items

- [x] **Create explicit CloudWatch log groups** with 30-day retention for all Lambda functions
- [x] **Enable CMK encryption** for all Lambda log groups
- [x] **Configure Dead Letter Queues** for error handling
- [x] **Review and set appropriate reserved concurrency** limits
- [x] **Deploy Lambda functions in VPC private subnets** (after VPC creation)
- [x] **Add VPC configuration** to Lambda functions with appropriate security groups

---

## API Gateway

### Findings

- **Access Logging:**
  No CloudWatch access logs configured.
- **Execution Logging:**
  No execution logs for debugging and monitoring.
- **X-Ray Tracing:**
  Not enabled for performance monitoring.

### Action Items

- [x] **Enable CloudWatch access logs** for API Gateway with 30-day retention
- [x] **Enable execution logging** for API Gateway
- [x] **Enable X-Ray tracing** for performance monitoring
- [x] **Configure log groups with CMK encryption**

---

## CloudFront

### Findings

- **Access Logging:**
  No access logs configured to S3.
- **Security Headers:**
  No security headers configured (HSTS, CSP, etc.).
- **WAF Integration:**
  No Web Application Firewall configured.

### Action Items

- [x] **Configure CloudFront access logs** to dedicated S3 logging bucket
- [x] **Add security headers** via CloudFront functions or Lambda@Edge
- [ ] **Consider WAF integration** for additional security
- [ ] **Enable real-time logs** if detailed monitoring is needed

---

## Logging & Monitoring

### Findings

- **CloudWatch Log Retention:**
  No explicit log group retention policy is set (should be 30 days).
- **CloudWatch Log Encryption:**
  No evidence that CloudWatch logs are encrypted with a CMK.
- **Resource Logging:**
  No explicit logging configuration for Lambda or other resources.

### Action Items

- [x] Set CloudWatch log group retention to 30 days for all log groups.
- [x] Enable encryption with a CMK for all CloudWatch log groups.
- [x] Ensure all resources (Lambdas, API Gateway, etc.) have logging enabled.
- [ ] **Deploy Datadog forwarder** to all regions for log aggregation
- [ ] **Configure Datadog log ingestion** for CloudWatch and S3 logs

---

## DynamoDB

### Findings

- **Backups:**
  No backup or point-in-time recovery configuration found.
- **Monitoring:**
  No enhanced monitoring or CloudWatch alarms configured.
- **Encryption:**
  No explicit encryption configuration with CMK.

### Action Items

- [x] Enable point-in-time recovery and regular backups for DynamoDB tables.
- [x] Enable enhanced monitoring and set up CloudWatch alarms as appropriate.
- [x] **Configure server-side encryption with CMK**
- [x] **Add backup vault configuration** for long-term retention

---

## KMS

### Findings

- **Key Aliases:**
  No descriptive aliases configured for keys.
- **Key Policies:**
  Using default key policy, should be more restrictive.

### Action Items

- [x] **Add descriptive aliases** for KMS keys
- [x] **Configure custom key policies** following least privilege
- [x] **Enable automatic key rotation** (already enabled)

---

## Secrets Manager

### Findings

- **Automatic Rotation:**
  No automatic rotation configured where applicable.
- **CMK Encryption:**
  Need to verify secrets are encrypted with CMK.

### Action Items

- [ ] **Configure automatic rotation** for applicable secrets
- [x] **Verify CMK encryption** is used for all secrets
- [x] **Add proper resource-based policies** for secret access

---

## Security Groups

### Findings

- **No Custom Security Groups:**
  No security groups defined, using defaults.
- **Default Security Group:**
  Default security group likely allows traffic.

### Action Items

- [x] **Create purpose-built security groups** with minimal required access
- [x] **Ensure default security group denies all traffic**
- [x] **Apply security groups to all resources** following least privilege

---

## General Recommendations

- [ ] Review and update IaC dependencies regularly to inherit latest security baselines.
- [ ] Use static analysis tools (e.g., trivy) to scan IaC for misconfigurations.
- [ ] Document all exceptions and justifications for any deviations from the baseline.
- [x] **Deploy VPC infrastructure first** before addressing other compliance items.
- [ ] **Consider using Code for America's OpenTofu modules** for baseline-compliant configurations.

---

## Databases (Future Consideration)

### Findings

- **No Database Resources:**
  Current infrastructure uses DynamoDB only, but baseline requirements apply if RDS/Aurora are added.

### Action Items (If databases are added)

- [ ] **Deploy in private subnets** only
- [ ] **Enable enhanced monitoring** for Aurora/RDS
- [ ] **Configure backup strategy**: Daily (31 days), Monthly (13 months), Yearly (3 years)
- [ ] **Test restores quarterly**
- [ ] **Copy backups to another region**
- [ ] **Use approved AMIs** if using EC2-based databases

---

## EC2 Instances (Future Consideration)

### Findings

- **No EC2 Instances:**
  Current infrastructure doesn't use EC2 instances, but baseline requirements apply if they are added.

### Action Items (If EC2 instances are added)

- [ ] **Deploy in private subnets** only, never public subnets
- [ ] **Use approved AMIs** (Amazon Linux 2023, Amazon Linux 2, Ubuntu Server 24.04 LTS, Ubuntu Server 22.04 LTS)
- [ ] **Configure IAM instance profiles** with Session Manager permissions
- [ ] **Install and configure CloudWatch agent** for logs and metrics
- [ ] **Enable detailed monitoring**
- [ ] **Implement patching strategy**: Zero-day (24h), Critical (15 days), High (30 days), Regular (monthly)
- [ ] **Use ephemeral instances** where possible instead of long-running instances
- [ ] **Configure appropriate security groups** with minimal required access
- [ ] **Right-size instances** using compute optimizer recommendations
- [ ] **Use Session Manager** instead of SSH for access

---

## SQS

### Findings

- **Encryption:**
  SQS queue is encrypted with KMS - compliant.
- **Dead Letter Queue:**
  No evidence of DLQ configuration for failed message handling.

### Action Items

- [x] **Configure Dead Letter Queue** for failed message handling
- [x] **Set appropriate message retention** and visibility timeout settings
- [x] **Enable CloudWatch metrics** and alarms for queue monitoring

---

## Monitoring & Compliance Tools

### Findings

- **AWS Security Hub:**
  Not configured for continuous compliance monitoring.
- **Amazon Inspector:**
  Not enabled for vulnerability scanning (if applicable to future EC2 instances or container images).
- **AWS Cost Explorer:**
  No mention of cost monitoring setup.
- **Amazon Macie:**
  Not configured for sensitive data detection in S3 buckets.

### Action Items

- [x] **Enable AWS Security Hub** for compliance posture monitoring
- [ ] **Configure Amazon Inspector** for vulnerability scanning (when EC2 instances are deployed)
- [x] **Set up AWS Cost Explorer** monitoring and alerts for unexpected usage
- [ ] **Request Amazon Macie enablement** via help desk ticket for sensitive data detection
- [x] **Configure cost anomaly detection** to identify potential security issues

---

## Next Steps

**Deploy the Infrastructure:**

```bash
cd iac
opentofu plan
opentofu apply
```

**Post-Deployment Actions:**

1. **Update Email Address:** In `iac/monitoring.tf`, update the email address in the cost anomaly subscription from `admin@example.com` to your actual email address, then redeploy.

2. **Validate Deployment:**
   - Check Security Hub findings in AWS Console
   - Verify VPC Flow Logs are working
   - Test Lambda functions in VPC
   - Confirm CloudWatch logs are encrypted

3. **Review Configuration:** Use static analysis tools (e.g., trivy) to scan IaC for any remaining misconfigurations.

**Note:** This infrastructure uses OpenTofu (open-source Terraform fork) for all IaC management. All `terraform` commands should be replaced with `opentofu` commands.

---

_Last updated: December 2024_
