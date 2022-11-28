#!/bin/bash -el

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd ${THIS_SCRIPT_DIR}

THIS_SCRIPT_NAME=$(basename $0)
ENV_FILE="${THIS_SCRIPT_DIR}/build.env"
NO_CACHE=""
GIT="false"
PUSH="false"
RUN="false"

function usage() {
  cat <<EOS
  Usage: ${THIS_SCRIPT_NAME} - builds the container
  Arguments:
    -v            -- Version number to tag the build with. Defaults to latest.
    --no-cache    -- Pass the --no-cache flag through to docker build
    -g            -- add and tag/commit in git
    -p            -- push to docker hub
    -r            -- run the container after a build. Will exit after running exits.
EOS
}

for arg in "$@"
do
  case $arg in
    "--no-cache"       )  NO_CACHE="--no-cache"; shift;;
    "-g"               )  GIT="true"; shift;;
    "--env-file"       )  shift; ENV_FILE=$arg; shift;;
    "-h" | "--help"    )  show_help="true"; shift;;
    "-p" | "--push"    )  PUSH="true"; shift;;
    "-r"               )  RUN="true"; shift;;
  esac
done

if [[ "${show_help}" == "true" ]]; then
  echo $(usage)
  exit 0
fi

if [[ -f "${ENV_FILE}" ]]; then
  source "${ENV_FILE}"
else
  echo "ERROR: No such variables file <${ENV_FILE}>. This must exist and be readable."
  exit 1
fi

docker build ${NO_CACHE} -t "${IMAGE_TAG}:${IMAGE_VERSION}" .
if [[ "${RUN}" == "true" ]]; then
  docker run -it ${IMAGE_TAG}:${IMAGE_VERSION}
  exit 0
fi


if [[ "${GIT}" == "true" ]]; then
  git add .
  git tag ${IMAGE_VERSION}
  git commit -m "Source for version ${IMAGE_VERSION}"
fi

if [[ "${PUSH}" == "true" ]]; then
  docker push "${IMAGE_TAG}:${IMAGE_VERSION}"
fi
