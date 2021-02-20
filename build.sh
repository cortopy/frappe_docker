#!/bin/sh

set -e

GIT_BRANCH=version-12
CONTAINER_REGISTRY=j3asolutions
FRAPPE_VERSION=v12.15.0
ERPNEXT_VERSION=v12.18.0
SOCKETIO_VERSION=v12.14.0

FRAPPE_NGINX_TAG=$CONTAINER_REGISTRY/frappe-nginx:$GIT_BRANCH
FRAPPE_WORKER_TAG=$CONTAINER_REGISTRY/frappe-worker:$GIT_BRANCH

ERPNEXT_NGINX_TAG=$CONTAINER_REGISTRY/erpnext-nginx:$ERPNEXT_VERSION
ERPNEXT_WORKER_TAG=$CONTAINER_REGISTRY/erpnext-worker:$ERPNEXT_VERSION

SOCKETIO_WORKER_TAG=$CONTAINER_REGISTRY/frappe-socketio:$SOCKETIO_VERSION

#
# NGINX
#

echo "Building image $FRAPPE_NGINX_TAG";

docker build \
  --pull \
  --tag "$FRAPPE_NGINX_TAG" \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --file build/frappe-nginx/Dockerfile \
  .;

docker push $FRAPPE_NGINX_TAG;

echo "Building image $ERPNEXT_NGINX_TAG";

docker build \
  --pull \
  --tag "$ERPNEXT_NGINX_TAG" \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --build-arg DOCKER_REGISTRY_PREFIX=$CONTAINER_REGISTRY \
  --file build/erpnext-nginx/Dockerfile \
  .;

docker push $ERPNEXT_NGINX_TAG;

#
# WORKER
#

echo "Building image $FRAPPE_WORKER_TAG";

docker build \
  --pull \
  --tag "$FRAPPE_WORKER_TAG" \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --file build/frappe-worker/Dockerfile \
  .;

docker push $FRAPPE_WORKER_TAG;


echo "Building image $ERPNEXT_WORKER_TAG";

docker build \
  --pull \
  --tag "$ERPNEXT_WORKER_TAG" \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --build-arg DOCKER_REGISTRY_PREFIX=$CONTAINER_REGISTRY \
  --file build/erpnext-worker/Dockerfile \
  .;

docker push $ERPNEXT_WORKER_TAG;

#
# SCOKETIO
#

echo "Building image $SOCKETIO_WORKER_TAG";

docker build \
  --pull \
  --tag "$SOCKETIO_WORKER_TAG" \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --file build/frappe-socketio/Dockerfile \
  .;

docker push $SOCKETIO_WORKER_TAG;