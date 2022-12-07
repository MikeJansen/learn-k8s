#!/bin/env bash

pushd ../step-03-provisioning

terraform destroy

cd ..
rm -rf artifacts
rm -rf step-04-certs/output

popd
