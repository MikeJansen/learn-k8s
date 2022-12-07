# Step 4 - Provisioning a CA and Generating TLS Certificates

Scripts, etc for [Step 4](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md).

`gen-certs.sh` takes all the scripts from that page and puts them into one script, driven off the outputs from the main Terraform script in `../step-03-provisioning` which creates all the GCP resources.

This assumes that [gcloud](https://cloud.google.com/sdk/docs/install) is installed and configured, the terraform script has been applied successfully, and that the current project has been set to the provisioned GCP project ID.