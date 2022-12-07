#!/bin/env bash

pushd ../step-03-provisioning

terraform destroy

cd ..
rm -rf artifacts

popd
