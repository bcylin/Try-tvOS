#!/bin/sh

if [ "$CONFIGURATION" = "Release" ] && [ "$CI" != true ]; then
  FABRIC_APIKEY=$(cat ${SRCROOT}/keys/fabric.apikey);
  FABRIC_BUILDSECRET=$(cat ${SRCROOT}/keys/fabric.buildsecret);
  ${PODS_ROOT}/Fabric/run ${FABRIC_APIKEY} ${FABRIC_BUILDSECRET};
else
  echo "Skip Fabric setup"
fi
