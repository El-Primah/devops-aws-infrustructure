# Disaster Recovery Automation for Distributed Cloud Application (AWS)

> ⚠️ **Educational Project Notice**
> 
> This repository contains the source code and infrastructure configurations developed as part of my Bachelor's thesis at Perm State University.
> 
> The project was created for **educational and research purposes only** to demonstrate the implementation of a Hybrid Disaster Recovery architecture using AWS services, Terraform, and Kubernetes. It is not intended for direct production use without additional security auditing and adaptation.

## About

This project implements an automated Disaster Recovery (DR) solution for a distributed microservice application hosted on Amazon Web Services (AWS).

**Key Objectives:**
*   Minimize Recovery Time Objective (RTO) and Recovery Point Objective (RPO).
*   Optimize operational costs using a "Cold Compute" strategy (infrastructure on-demand).
*   Ensure data integrity through cross-region and cross-account replication.

## Tech Stack

*   **Cloud Provider:** Amazon Web Services (AWS)
*   **Infrastructure as Code:** Terraform (multi-account, multi-region)
*   **Orchestration:** Amazon EKS (Kubernetes), Helm charts
*   **Automation:** AWS Lambda, Step Functions, EventBridge Scheduler
*   **CI/CD:** Jenkins, Ansible
*   **Languages:** Python, Bash, HCL

## Repository Structure

```text
.
├── terraform/             # IaC modules and environment configs
│   ├── modules/           # Reusable components (VPC, EKS, RDS)
│   └── environments/      # Prod, DR, and Config account configs
├── charts/                # Helm charts for microservices
├── scripts/               # Automation scripts (DR initialization, utils)
├── ansible/               # Configuration management playbooks
└── docs/                  # Documentation and diagrams
```

## Getting Started (Overview)
Note: This environment requires specific AWS account configurations and permissions. These instructions are for reference only.
Prerequisites: AWS CLI, Terraform, kubectl, Helm installed.
Configuration: Prepare terraform.tfvars with your specific account IDs and region settings.
Replication Setup: Apply the Replication Infrastructure configuration to enable automated snapshot copying.
DR Activation: In case of an incident, use the provided initialization scripts to deploy the Standard Infrastructure in the DR region.
(Refer to the full thesis documentation for detailed deployment guides.)

## License
Copyright (c) 2026 Maxim Perminov.
This project is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.

You are free to:
 - Share — copy and redistribute the material in any medium or format.
 - Adapt — remix, transform, and build upon the material.

Under the following terms:
 - Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made.
 - NonCommercial — You may not use the material for commercial purposes.

See the LICENSE file for the full legal text.
