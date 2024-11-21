#!/bin/bash
source env.sh

LOG_GROUP="/${INFRA_NAME}-devops-${ENV_NAME_LOWER}/infra"
LOG_STREAM="${INFRA_NAME}-${ENV_NAME_LOWER}-pipes"

EVENT_TIME=$(date +%s000)
MESSAGE="Bitbucket Pipeline Run"

AUTH="Authorization: Bearer ${PIPEINFO_TOKEN}"
PIPE_URL=https://api.bitbucket.org/2.0/repositories/avd/${BITBUCKET_REPO_SLUG}/pipelines/${BITBUCKET_PIPELINE_UUID}
STEP_URL=https://api.bitbucket.org/2.0/repositories/avd/${BITBUCKET_REPO_SLUG}/pipelines/${BITBUCKET_PIPELINE_UUID}/steps/${BITBUCKET_STEP_UUID}
PIPE_INFO=$(curl -s --request GET -g --url "$PIPE_URL" --header "$AUTH")
STEP_INFO=$(curl -s --request GET -g --url "$STEP_URL" --header "$AUTH")

PIPE_NAME=$(echo $PIPE_INFO | jq --raw-output '.target.selector.pattern')
PIPE_CREATOR=$(echo $PIPE_INFO | jq --raw-output '.creator.display_name')
STEP_NAME=$(echo $STEP_INFO | jq --raw-output '.name')

APP_IMAGE="${APP_IMAGE:-NA}"
APP_TAG="${APP_TAG:-NA}"

OUTPUT=$(jq -n \
  --arg Event_Time "${EVENT_TIME}" \
  --arg Message "${MESSAGE}" \
  --arg INFRA_NAME "${INFRA_NAME}" \
  --arg ENV_NAME "${ENV_NAME}" \
  --arg BITBUCKET_REPO_SLUG "${BITBUCKET_REPO_SLUG}" \
  --arg BITBUCKET_BRANCH "${BITBUCKET_BRANCH}" \
  --arg BITBUCKET_BUILD_NUMBER ${BITBUCKET_BUILD_NUMBER} \
  --arg BITBUCKET_COMMIT ${BITBUCKET_COMMIT} \
  --arg BITBUCKET_PIPELINE_UUID ${BITBUCKET_PIPELINE_UUID} \
  --arg PIPE_NAME "${PIPE_NAME}" \
  --arg PIPE_CREATOR "${PIPE_CREATOR}" \
  --arg BITBUCKET_STEP_UUID ${BITBUCKET_STEP_UUID} \
  --arg STEP_NAME "${STEP_NAME}" \
  --arg APP_IMAGE ${APP_IMAGE} \
  --arg APP_TAG ${APP_TAG} \
  '{
    Message:$Message,
    INFRA:$INFRA_NAME,
    ENV:$ENV_NAME,
    REPO:$BITBUCKET_REPO_SLUG,
    PIPE:$PIPE_NAME,
    STEP:$STEP_NAME,
    CREATOR:$PIPE_CREATOR,
    PIPE_NUMBER:$BITBUCKET_BUILD_NUMBER,
    BRANCH:$BITBUCKET_BRANCH,
    COMMIT:$BITBUCKET_COMMIT,
    PIPE_UUID:$BITBUCKET_PIPELINE_UUID,
    STEP_UUID:$BITBUCKET_STEP_UUID,
    APP_IMAGE:$APP_IMAGE,
    APP_TAG:$APP_TAG,
    Event_Time:$Event_Time
  }' \
)

LOG_MESSAGE=$(echo $OUTPUT | sed 's/"/\\"/g') 

aws logs put-log-events --log-group-name $LOG_GROUP --log-stream-name $LOG_STREAM --log-events timestamp=$(date +%s000),message=\""$LOG_MESSAGE"\"
