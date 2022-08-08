#!/bin/bash 

set -e 

eval "$(jq -r '@sh "FILEPATH=\(.filepath)"')" 

MIME=$(file --brief --mime-type $FILEPATH)

jq -n --arg mime "$MIME" '{"mime":$mime}'