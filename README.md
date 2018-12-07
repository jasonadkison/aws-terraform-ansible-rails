**Work in progress, use at your own risk!**

This is a discovery project to play with configuration management and infrastructure orchestration tools. Please understand the risks of using the provided code.

# Prerequisites
- ruby (>= 2.3.1)
- terraform (>= 0.11.8)
- ansible (>= 2.7.4)

# Infrastructure

All terraform related files are located in the `./ops/terraform` directory.

This project is launched on AWS. Ensure you have valid AWS credentials before proceeding. All terraform variables are currently using environment variables that you'll need to have setup on your end.

I'm using [direnv](https://direnv.net/) to setup my env vars.

```bash
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx
export AWS_DEFAULT_REGION=us-east-1
export TF_VAR_public_key=path/to/your/key.pub
```

The instance will be launched in the default VPC. The ubuntu server AMI provided by Amazon is being used.

*Warning*: for simplicity, the instance will be wide open to all inbound traffic and all ports. You definitely need to restrict access to before using this in a real-world scenario.

Aside from creating resources, `terraform apply` does the following:

- uses user-data to bootstrap the instance (ansible requires python to be installed)
- creates the ansible inventory file automatically using the new instance's public IP address
