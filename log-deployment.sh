#!/bin/bash
set -e

STAGE=${1}

FILE_NAME='entries.json'

EVENT_NAME=${EVENT_NAME:-serviceDeployed}
EVENT_SOURCE=${EVENT_SOURCE:-deployments}
EVENT_BUS_NAME_PREFIX=${EVENT_BUS_NAME_PREFIX:-deployments-event-bus}

IS_DEPLOYMENT_ROLLBACK=${IS_DEPLOYMENT_ROLLBACK:-false}
IS_A_PACKAGE=${IS_A_PACKAGE:-false}

REPO_NAME=$(echo "${GITHUB_REPOSITORY}" | sed 's/'"${ORG_PREFIX:-lemonenergy}"'\///')

cat > "${FILE_NAME}" <<EOL
[
    {
    "DetailType": "${EVENT_NAME}",
    "Source": "${EVENT_SOURCE}",
    "EventBusName": "${EVENT_BUS_NAME_PREFIX}-${STAGE}",
    "Detail": "{ \"layer\": \"${REPOSITORY_LAYER}\", \"repository\": \"${REPO_NAME}\", \"commit\": \"${GITHUB_SHA}\", \"author\": \"${GITHUB_ACTOR}\", \"rollback\": ${IS_DEPLOYMENT_ROLLBACK}, \"package\": ${IS_A_PACKAGE}}"
  }
]
EOL

echo 'created entries.json with content:'

cat "${FILE_NAME}"

OUTPUT=$(aws events put-events --entries "file://${FILE_NAME}" --region "${CONTAINER_AWS_REGION:-us-east-2}")
echo "${OUTPUT}"

echo "${OUTPUT}" | grep '"FailedEntryCount": 0'

rm "${FILE_NAME}"
