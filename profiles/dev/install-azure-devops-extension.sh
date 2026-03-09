#!/bin/bash

source ${ROOT_DIR}/colors.sh
source ${ROOT_DIR}/functions.sh

msg "Installing Azure DevOps extension"
run az extension add --name azure-devops

az devops configure --defaults organization=https://dev.azure.com/ns-topaas project=NSAPP
