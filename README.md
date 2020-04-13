# AWS Terraform VPC Endpoint

How to wire up both sides of the AWS VPC Endpoint.

## Without Endpoints

Create a Workspace with the `/use` folder.

* Set the cloud credentials via ENV variables.
* Do not set `aws_private_endpoints`.
* Create an ENV Variable `TF_LOG` = `DEBUG`.

Run a plan and notice:

```sh
**provider-aws_v2.57.0_x4: ---[ REQUEST POST-SIGN ]-----------------------------
**provider-aws_v2.57.0_x4: POST / HTTP/1.1
**provider-aws_v2.57.0_x4: Host: sts.amazonaws.com
**provider-aws_v2.57.0_x4: User-Agent: aws-sdk-go/1.30.5 (go1.13.7; linux; amd64) APN/1.0 HashiCorp/1.0 Terraform/0.12.23 (+https://www.terraform.io)
**provider-aws_v2.57.0_x4: Content-Length: 43

# and

**provider-aws_v2.57.0_x4: ---[ REQUEST POST-SIGN ]-----------------------------
**provider-aws_v2.57.0_x4: POST / HTTP/1.1
**provider-aws_v2.57.0_x4: Host: ec2.us-west-1.amazonaws.com
```

Now set `aws_private_endpoints` as a Terraform Variable, inserting values from the VPC endpoints you have already created:

```hcl
{
  ec2 = "vpce-xxxxxxxxxxxxxxxxx-zzzzzzzz.ec2.us-west-1.vpce.amazonaws.com",
  sts = "vpce-xxxxxxxxxxxxxxxxx-zzzzzzzz.sts.us-west-1.vpce.amazonaws.com"
}
```

Run a **new** plan and notice:

```sh
**provider-aws_v2.57.0_x4: ---[ REQUEST POST-SIGN ]-----------------------------
**provider-aws_v2.57.0_x4: POST / HTTP/1.1
**provider-aws_v2.57.0_x4: Host: vpce-xxxxxxxxxxxxxxxxx-zzzzzzzz.sts.us-west-1.vpce.amazonaws.com
**provider-aws_v2.57.0_x4: User-Agent: aws-sdk-go/1.30.5 (go1.13.7; linux; amd64) APN/1.0 HashiCorp/1.0 Terraform/0.12.23 (+https://www.terraform.io)

# and

**provider-aws_v2.57.0_x4: ---[ REQUEST POST-SIGN ]-----------------------------
**provider-aws_v2.57.0_x4: POST / HTTP/1.1
**provider-aws_v2.57.0_x4: Host: vpce-xxxxxxxxxxxxxxxxx-zzzzzzzz.ec2.us-west-1.vpce.amazonaws.com
**provider-aws_v2.57.0_x4: User-Agent: aws-sdk-go/1.30.5 (go1.13.7; linux; amd64) APN/1.0 HashiCorp/1.0 Terraform/0.12.23 (+https://www.terraform.io)
```
