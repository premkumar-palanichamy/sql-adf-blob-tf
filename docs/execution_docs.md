# End-to-End Data Pipeline: SQL Server, ADF, Azure Blob, and Power BI

## 1. Configure Azure Data Factory (ADF)

### 1.1 Create Linked Services

- **SQL Server Linked Service** (via SHIR) to securely connect on-premises SQL Server.
- **Blob Storage Linked Service** for data destination.
- **Power BI Linked Service** to automate report refreshes.

### 1.2 Create Datasets

- **SQL Dataset:** Extract data from SQL tables/views.
- **Blob Storage Dataset:** Define structured formats (Parquet, CSV, JSON).
- **Power BI Dataset:** Ensure compatibility with ingested data for direct querying.

### 1.3 Design ADF Pipeline

1. **Lookup Activity:** Query SQL metadata.
2. **Copy Data Activity:** Move data from SQL Server to Blob Storage.
3. **Data Flow Activity:** Perform transformations (joins, aggregations, schema enforcement).
4. **Web Activity:** Trigger Power BI dataset refresh after ingestion.
5. **Trigger:** Configure **Event-Based Triggers** or **Time-Based Triggers** for execution.

### 1.4 Security & Networking Considerations

#### **1.4.1 Networking**

- **ExpressRoute/VPN:** Ensures secure connectivity between on-premises and Azure.
- **Azure Private Endpoints:** Restrict public exposure of ADF, Blob Storage, and Power BI.
- **DNS Private Resolver:** Ensure private endpoint name resolution.

#### **1.4.2 Security Best Practices**

- **Azure Key Vault:** Secure credentials and connection strings.
- **Managed Identity for ADF:** Minimize credential exposure.
- **NSG Rules:** Allow only necessary traffic between ADF, SHIR, and Blob Storage.
- **Azure Policy & Defender for Cloud:** Enforce compliance and monitor security threats.
- **RBAC & IAM:** Grant least-privilege access to ADF, Storage, and Power BI.
- **Audit Logging:** Enable diagnostic logs for ADF and SQL Server.

## 2. CI/CD Automation

### 2.1 Terraform & PowerShell in Azure DevOps

**Infrastructure as Code (IaC)**

- Store Terraform scripts in Git.
- Automate deployment using **Azure DevOps Pipeline**:

```yaml
target:
  branches:
    - main
jobs:
  - job: Terraform_Deploy
    steps:
      - task: TerraformTaskV1
        inputs:
          command: 'apply'
          environmentServiceName: 'Azure-Connection'
```

- Deploy using **Azure DevOps Agent** or GitHub Actions.
- Automate **Power BI dataset refresh** using Azure Automation.

### 2.2 Monitoring & Logging

- **Log Analytics Workspace:** Collect ADF pipeline run logs.
- **Azure Monitor Alerts:** Detect failures and notify via Teams/Slack.
- **Activity Logs:** Track ADF pipeline execution, failures, and triggers.
- **Power BI Monitoring Dashboard:** Visualize ingestion trends and errors.

## 3. Power BI Integration & Automation

### 3.1 Power BI Embedded for Reporting

- **Connect Power BI to Azure Blob:** Direct Query for real-time analytics.
- **Use Power BI Dataflows:** Preprocess large datasets before visualization.
- **Optimize DAX Queries & Aggregations:** Improve report performance.

### 3.2 Automating Power BI Dataset Refresh via Azure Automation

- **Azure Automation Runbook:** Create a Runbook to refresh Power BI datasets automatically.

  ```powershell
  $tenantId = "<TENANT_ID>"
  $clientId = "<CLIENT_ID>"
  $clientSecret = "<CLIENT_SECRET>"
  $workspaceId = "<WORKSPACE_ID>"
  $datasetId = "<DATASET_ID>"

  $tokenUri = "https://login.microsoftonline.com/$tenantId/oauth2/token"
  $body = @{ 
      grant_type    = "client_credentials"
      client_id     = $clientId
      client_secret = $clientSecret
      resource      = "https://analysis.windows.net/powerbi/api"
  }
  $tokenResponse = Invoke-RestMethod -Uri $tokenUri -Method Post -Body $body
  $accessToken = $tokenResponse.access_token

  Invoke-RestMethod -Uri "https://api.powerbi.com/v1.0/myorg/groups/$workspaceId/datasets/$datasetId/refreshes" -Method Post -Headers @{ Authorization = "Bearer $accessToken" }
  ```
- **Scheduled Execution:** Run the Automation Runbook at desired intervals.
- **Event-Based Trigger:** Invoke Runbook via ADF Web Activity after data ingestion.

### 3.3 Power BI Security & Governance

- **Row-Level Security (RLS):** Restrict data visibility per user role.
- **Data Sensitivity Labels:** Classify and protect critical information.
- **Audit Logs & Usage Reports:** Monitor user access and report performance.

## 4. Troubleshooting

| Issue                       | Solution                                            |
| --------------------------- | --------------------------------------------------- |
| ADF pipeline failing        | Check Linked Services and integration runtime.      |
| Terraform apply fails       | Verify credentials and Terraform plan output.       |
| Network connectivity issues | Ensure NSG and Private Endpoints are correctly set. |
| Secrets exposure risk       | Store sensitive data in Key Vault.                  |
| Power BI refresh failures   | Check Azure Automation Runbook execution logs.      |

## 5. Conclusion

By following this guide, you can securely deploy an end-to-end data pipeline integrating **SQL Server, ADF, Azure Blob Storage, and Power BI Embedded**. With **Terraform, PowerShell, and Azure DevOps**, the setup is fully automated and adheres to security best practices. 🚀

