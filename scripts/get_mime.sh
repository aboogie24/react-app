#!/bin/bash 

set -e 

eval "$(jq -r '@sh "FILEPATH=\(.filepath)"')" 

if [[ ${FILEPATH} == *.css ]]; then
  MIME="text/css"
else
  MIME=$(file --brief --mime-type $FILEPATH)
fi

jq -n --arg mime "$MIME" '{"mime":$mime}'