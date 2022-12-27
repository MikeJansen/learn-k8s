source gcloud-login.sh

pushd terraform
terraform destroy --auto-approve -var project_id=$(gcloud config get project) || exit 1
popd

