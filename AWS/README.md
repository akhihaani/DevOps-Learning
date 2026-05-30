# AWS

This repository documents hands-on AWS projects focused on core cloud networking and infrastructure fundamentals.
Each assignment builds on the previous one and demonstrates practical DevOps patterns rather than isolated lab exercises.

The goal of this repo is to provide clear proof of understanding, supported by architecture decisions, screenshots, and written explanations.

⸻

# Projects Overview

✅ Assignment 1 – VPC & Networking Fundamentals

Focus: Network segmentation, routing, and secure access design.

What was implemented:
	•	Custom VPC built from scratch (10.0.0.0/16)
	•	Public and private subnets with non-overlapping CIDRs
	•	Internet Gateway for public subnet access
	•	NAT Gateway for private subnet outbound access
	•	Separate route tables for public and private traffic
	•	Public EC2 instance with restricted access
	•	Private EC2 instance with no public IP
	•	Bastion host for secure access into the private subnet

Key concepts demonstrated:
	•	Public vs private networking in AWS
	•	Route table–based traffic control
	•	Least-privilege security group design
	•	Bastion host access patterns

📁 Documentation and screenshots are available in the Assignment 1 section of the repo.

⸻

✅ Assignment 2 – Application Load Balancer

Focus: High availability, traffic management, and security isolation.

What was implemented:
	•	Two EC2 instances deployed across different Availability Zones
	•	Stateless web servers installed via user data
	•	Application Load Balancer spanning public subnets
	•	Target group with health checks on /
	•	ALB as the single public entry point
	•	EC2 instances placed in private subnets
	•	Security groups restricting EC2 access to ALB traffic only
	•	NAT Gateway used to allow private instances outbound internet access

Key concepts demonstrated:
	•	Load balancing and health checks
	•	Security group referencing (ALB → EC2)
	•	Private compute behind public infrastructure
	•	Debugging infrastructure-level connectivity issues

📁 Documentation and screenshots are available in the Assignment 2 section of the repo.

⸻

# Design Philosophy

These projects were completed with an emphasis on:
	•	Correct architecture over “just making it work”
	•	Clear separation of public and private resources
	•	Security by default
	•	Understanding why components are required, not just how to create them

Where issues were encountered, they were investigated using AWS monitoring and resource relationships rather than trial-and-error fixes.

⸻

# Screenshots & Evidence

Each assignment includes:
	•	Architecture-relevant screenshots only (no wizard noise)
	•	Route tables, security groups, and health checks
	•	Functional verification (e.g. load-balanced responses)

Screenshots are intentionally minimal and exist solely to prove intent and correctness.