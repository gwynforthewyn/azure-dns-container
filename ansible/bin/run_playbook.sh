#!/bin/bash -el

THIS_SCRIPT_DIR=$(cd "$(dirname $0)" && pwd)
cd "${THIS_SCRIPT_DIR}/.."

source bin/playtechnique_docker.env

if [[ -z "${PLAYTECHNIQUE_LOGIN_USER}" ]]; then
  echo "Set PLAYTECHNIQUE_LOGIN_USER"
  exit 1
fi

if [[ -z "${PLAYTECHNIQUE_AZURE_DOCKER_PAT}" ]]; then
 echo "Set PLAYTECHNIQUE_AZURE_DOCKER_PAT in the env." >&2
 exit 2
fi


ansible-playbook -i inventory.yaml playbook.yaml --extra-vars "docker_user=${PLAYTECHNIQUE_LOGIN_USER} docker_pw=${PLAYTECHNIQUE_AZURE_DOCKER_PAT}" "$@"
