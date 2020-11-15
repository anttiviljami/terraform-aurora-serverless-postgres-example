# Terraform Aurora Serverless Postgres example

[![License](http://img.shields.io/:license-mit-blue.svg)](https://github.com/anttiviljami/terraform-aurora-serverless-postgres-example/blob/master/LICENSE)

Minimal Terraform Setup for Aurora Serverless PostgreSQL

Creates:

- Aurora Serverless Cluster
  - Pausing enabled
  - Data API enabled
- Secrets Manager Secret for RDS master credentials

## Usage

```
terraform init
terraform apply
```

