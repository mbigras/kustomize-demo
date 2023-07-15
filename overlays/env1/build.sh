#!/usr/bin/env bash
# Script build.sh builds your kustomization--see https://kubectl.docs.kubernetes.io/references/kustomize/glossary/#kustomization page.

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd) # for an explanation about this arcane command, see https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script/246128#246128 answer.

kustomize build "$SCRIPT_DIR"
