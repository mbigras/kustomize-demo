#!/usr/bin/env bash
# Script example.sh runs your app on Kubernetes.

set -e # fail if any commands fail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd) # for an explanation about this arcane command, see https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script/246128#246128 answer.

kubectl config use-context ${CONTEXT:-docker-desktop}

kubectl kustomize "${SCRIPT_DIR}/overlays/env1" \
| tee /dev/stderr \
| kubectl apply --filename=-

kubectl rollout status deployment/app

kubectl port-forward deployment/app 8080:8080 &
kpid=$!

curl --silent --retry 12 --retry-all-errors localhost:8080

kill $kpid

kubectl kustomize "${SCRIPT_DIR}/overlays/env1" \
| kubectl delete --filename=-
