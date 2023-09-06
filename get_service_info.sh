#!/bin/bash
if [ -z "$1" ]; then
  echo -e "Usage:\n\t${0} <SERVICE_GUID>"
  exit 1
fi
SERVICE_GUID="$1"
SVC_INFO=$(cf curl "/v2/service_instances/${SERVICE_GUID}" | jq -cs '.')
ERROR=$(echo $SVC_INFO | jq -r '.[].error_code')

if [ $ERROR != "null" ];then
  echo -e "An error was encountered retrieving the service\n"
  echo -e "\t${ERROR}"
  exit 100
fi

SVC_NAME=$(echo $SVC_INFO | jq -r '.[].entity.name')
SVC_BINDINGS_URL=$(echo $SVC_INFO | jq -r '.[].entity.service_bindings_url')
SVC_SPACE_URL=$(echo $SVC_INFO | jq -r '.[].entity.space_url')

SVC_SPACE_INFO=$(cf curl $SVC_SPACE_URL | jq -cs '.')
SVC_SPACE_NAME=$(echo $SVC_SPACE_INFO | jq -r '.[].entity.name')
SVC_ORG_URL=$(echo $SVC_SPACE_INFO | jq -r '.[].entity.organization_url')
SVC_ORG_NAME=$(cf curl $SVC_ORG_URL | jq -r '.entity.name')

echo -e "SERVICE NAME:\t${SVC_NAME}"
echo -e "\tORG:\t${SVC_ORG_NAME}"
echo -e "\tSPACE:\t${SVC_SPACE_NAME}"

echo -e "BOUND APPLICATIONS:"
for app_url in $(cf curl $SVC_BINDINGS_URL | jq -r '.resources[].entity.app_url');do
  APP_INFO=$(cf curl $app_url | jq -cs '.')
  APP_NAME=$(echo $APP_INFO | jq -r '.[].entity.name')
  APP_SPACE_URL=$(echo $APP_INFO | jq -r '.[].entity.space_url')

  SPACE_INFO=$(cf curl $APP_SPACE_URL | jq -cs '.')
  SPACE_NAME=$(echo $SPACE_INFO | jq -r '.[].entity.name')
  SPACE_ORG_URL=$(echo $SPACE_INFO | jq -r '.[].entity.organization_url')

  ORG_NAME=$(cf curl $SPACE_ORG_URL | jq -r '.entity.name')
  echo -e "\tAPPLICATION NAME:\t${APP_NAME}"
  echo -e "\t\tSPACE:\t${SPACE_NAME}"
  echo -e "\t\tORG:\t${ORG_NAME}"
done
