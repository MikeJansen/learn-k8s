# Step 3 - Provisioning Compute Resources

Scripts and terraform for [Step 3](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/03-compute-resources.md).

## Terraform

The subnets and some of the CIDRs don't match what's in the tutorial.  Just pay attention to the differences.  I put each controller and node in its own subnet.  This could be end up being totally unnecessary.

`main.tf` is really just a wrapper around the module at `../../gcp` to specify 3 each of controller and node and to pass the outputs through.

`terraform plan` to see what it will create.

`terraform apply` to provision.

`terrafrom output` to see the outputs.  This is used with the `-json` flag in other steps to get needed values.

`terraform destroy` to delete all GCP resources, including the project.

## Misc

Any other GCP resources will be provisioned here (like the Load Balancer) even if they are from different steps.  I'll likely need to add a variable to indicate the latest step.  We'll see how it pans out.
