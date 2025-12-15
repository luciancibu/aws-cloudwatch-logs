# PoC – Terraform + Ansible + CloudWatch Logs (Work in Progress)

## Overview

This project provides a Infrastructure-as-Code setup for deploying a **static website served by httpd** on **Amazon EC2 (Amazon Linux 2)**, with **centralized logging to AWS CloudWatch Logs**.

The stack uses:
- **Terraform** for AWS infrastructure provisioning
- **Ansible** for OS, Apache, and logging configuration
- **CloudWatch Logs (awslogs agent)** for log aggregation

All logs are sent directly to CloudWatch Logs.

---

## Architecture

```
Terraform
  ├── EC2 (Amazon Linux 2)
  ├── IAM Role + Instance Profile
  ├── Security Groups
  └── Outputs (EC2 Public IP)

Ansible
  ├── common      → base OS configuration
  ├── httpd       → Apache installation & site setup
  └── awslogs     → CloudWatch Logs agent configuration
```

---

## Repository Structure

```
.
├── ansible/
│   ├── ansible.cfg
│   ├── ansible.log
│   ├── inventory
│   ├── playbook.yml
│   └── roles/
│       ├── awslogs/
│       │   ├── handlers/main.yml
│       │   ├── tasks/main.yml
│       │   └── templates/awslogs.conf.j2
│       ├── common/
│       │   └── tasks/main.yml
│       └── httpd/
│           ├── defaults/main.yml
│           ├── handlers/main.yml
│           ├── tasks/main.yml
│           └── templates/
│
├── terraform/
│   ├── ami.tf
│   ├── iam.tf
│   ├── instances.tf
│   ├── keypar.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── security.tf
│   ├── variables.tf
│   └── templates/deploy.tmpl
│
└── README.md
```

---

## Ansible Roles

### common
- System updates
- Base packages
- Generic OS configuration

### httpd
- httpd installation
- Service enable & start
- Static site deployment
- Handlers for restart/reload

### awslogs
- awslogs agent installation
- Configuration of log sources
- Service enable & start

---

## CloudWatch Logs Configuration

The awslogs agent is configured using the template:

```
roles/awslogs/templates/awslogs.conf.j2
```

### General section

```
[general]
state_file = /var/lib/awslogs/agent-state
```

### Collected logs

#### System logs
```
[/var/log/messages]
datetime_format = %b %d %H:%M:%S
file = /var/log/messages
buffer_duration = 5000
log_stream_name = web-sys-logs
initial_position = start_of_file
log_group_name = httpd-wave-web
```

#### httpd access logs
```
[/var/log/httpd/access_log]
datetime_format = %b %d %H:%M:%S
file = /var/log/httpd/access_log
buffer_duration = 5000
log_stream_name = web-httpd-access
initial_position = start_of_file
log_group_name = httpd-wave-web
```

#### httpd error logs
```
[/var/log/httpd/error_log]
datetime_format = %b %d %H:%M:%S
file = /var/log/httpd/error_log
buffer_duration = 5000
log_stream_name = web-httpd-error
initial_position = start_of_file
log_group_name = httpd-wave-web
```

### Result in CloudWatch

```
Log Group: httpd-wave-web
  ├── web-sys-logs
  ├── web-httpd-access
  └── web-httpd-error
```

---

## Terraform Responsibilities

Terraform is responsible for:
- Selecting the AMI
- Creating the EC2 instance
- Defining IAM Role & Instance Profile
- Configuring Security Groups
- Creating the SSH key pair
- Exporting EC2 public IP
- Generating deployment script via template

---
