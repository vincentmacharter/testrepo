#!/usr/bin/env bash

set -euo pipefail

# Functions

function usage() {
	echo "Usage: ./$(basename ${0}) service namespace dnsname"
}

# Init

service=${1:-}
if [[ -z ${service} ]]; then
	>&2 echo "Missing argument 'service'."
	>&2 usage
	exit 1
fi

namespace=${2:-}
if [[ -z ${namespace} ]]; then
	>&2 echo "Missing argument 'namespace'."
	>&2 usage
	exit 1
fi

dnsName=${@:3}
if [[ -z ${dnsName} ]]; then
	>&2 echo "Missing argument 'dnsname'."
	>&2 usage
	exit 1
fi

# Main

if ! az account show &>/dev/null; then
	az login
else
	echo "INFO: Already logged in to Azure"
fi

# Get the exposed public IP from Kubernetes

if ! service=$(kubectl get service ${service} --namespace ${namespace} -o=json); then
	>&2 echo "FAIL: error getting Kubernetes service ${service}"
	exit 1
fi

serviceIP=$(echo ${service} | jq -r '.status.loadBalancer.ingress[0].ip')

# Get the corresponding public IP from Azure

if ! publicIP=$(az network public-ip list | jq ".[] | select(.ipAddress == \"${serviceIP}\")"); then
	>&2 echo "FAIL: error getting Azure public IP ${serviceIP}"
	exit 1
fi

# Update the Azure public IP DNS name

publicIPID=$(echo ${publicIP} | jq -r '.id')

if ! publicIP=$(az network public-ip update --ids ${publicIPID} --dns-name=${dnsName}); then
	>&2 echo "FAIL: error updating Azure public IP ${publicIPID}"
	exit 1
else
	fqdn=$(echo ${publicIP} | jq -r '.dnsSettings.fqdn')
	echo "SUCCESS: Updated Azure public IP ${publicIPID} to resolve ${fqdn}."
fi
