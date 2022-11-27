#!/bin/bash
set -e

# Allow users to pick the foreground flag to be used. This is useful if the
# user wants to log to a file. In this case, set USE_CONFIG_FILE_LOGGING to any
# value. Otherwise, any logging configuration will be ignored and logs will be
# written to STDERR.
FOREGROUND_FLAG="-g"
if [[ -n "${USE_CONFIG_FILE_LOGGING}" ]]; then
  FOREGROUND_FLAG="-f"
fi

# allow arguments to be passed to named
if [[ "${1:0:1}" == '-' ]]; then
    EXTRA_ARGS="${*}"
    set --
elif [[ "${1}" == "named" || "${1}" == "$(command -v named)" ]]; then
    EXTRA_ARGS="${*:2}"
    set --
fi

# The user which will start the named process.  If not specified,
# defaults to 'bind'.
BIND9_USER="${BIND9_USER:-bind}"

# default behaviour is to launch named
if [[ -z "${1}" ]]; then
    echo "Starting named..."
    echo "exec $(which named) -u \"${BIND9_USER}\" \"${FOREGROUND_FLAG}\" \"${EXTRA_ARGS}\""
    exec $(command -v named) -u "${BIND9_USER}" "${FOREGROUND_FLAG}" ${EXTRA_ARGS}
else
    exec "${@}"
fi