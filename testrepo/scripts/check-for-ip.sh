#!/usr/bin/env bash

set -euo pipefail


function usage() {
	echo "Usage: ./$(basename ${0}) service namespace"
}

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


# Get the exposed public IP from Kubernetes --kubeconfig=config-new

if ! service=$(kubectl get service ${service} --namespace ${namespace} -o=json); then
	>&2 echo "FAIL: error getting Kubernetes service ${service}"
	exit 1
fi

# Check if the IP has been set yet for the service

while [[  $(echo ${service} | jq -r '.status.Loadbalancer.ingress[0].ip') == "null" ]]; do
    echo 'IP is being assigned...'
done

echo "IP has been assigned"