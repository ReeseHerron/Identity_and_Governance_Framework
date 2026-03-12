# Azure Identity and Governance Framework

## Project Overview
This project demonstrates the implementation of a Zero Trust identity and access management framework within Azure. It focuses on automating the lifecycle of users and security groups in Microsoft Entra ID and enforcing granular resource access through Role-Based Access Control (RBAC). 

The goal was to build a scalable, secure environment suitable for an enterprise setting, aligning with requirements for the AZ-900 and AZ-104 certifications.

## Architecture
The framework follows the Principle of Least Privilege (PoLP) by scoping permissions to specific resource containers rather than the entire subscription.



## Tech Stack
| Category          | Technology |
| :---              | :--- |
| Cloud Provider    | Microsoft Azure |
| Identity Provider | Microsoft Entra ID |
| Automation        | PowerShell (Az and Microsoft Graph modules) |
| Methodology       | Infrastructure as Code (IaC) principles |

## Key Features
* **Automated Provisioning:** Utilized PowerShell and the Microsoft Graph API to bulk-import users from CSV data, ensuring consistent attribute mapping across the directory.
* **Identity Governance:** Established Security Groups to manage access by job function, reducing administrative overhead and improving auditability.
* **RBAC Implementation:** Applied the Reader and Contributor roles at the Resource Group scope to prevent unauthorized access to sensitive production environments.
* **Resource Protection:** Enforced Resource Locks (CanNotDelete) to prevent accidental deletion of critical infrastructure by authorized administrators.

## How to Use
1. **Prerequisites:** Install the Az and Microsoft Graph PowerShell modules.
2. **Setup:** Update the users.csv template with test data and set your TenantId in the deployment script.
3. **Deployment:** Run the deployment script to provision the identity structure and resource groups.
4. **Validation:** Verify group memberships and role assignments via the Azure Portal or the provided verification commands.

## Lessons Learned
* Navigating cross-module authentication between the Identity Plane and the Management Plane.
* Troubleshooting PowerShell data types and array handling within the Microsoft Graph SDK.
* Managing Role Inheritance and effective permissions across different Azure scopes.
