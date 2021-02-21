#!/bin/sh

set -e

GIT_BRANCH=version-13-beta
CONTAINER_REGISTRY=j3asolutions
FRAPPE_VERSION=v13.0.0-beta.10
ERPNEXT_VERSION=v13.0.0-beta.11
SOCKETIO_VERSION=v13.0.0-beta.10

FRAPPE_NGINX_TAG=$CONTAINER_REGISTRY/frappe-nginx:$GIT_BRANCH
FRAPPE_WORKER_TAG=$CONTAINER_REGISTRY/frappe-worker:$GIT_BRANCH

ERPNEXT_NGINX_TAG=$CONTAINER_REGISTRY/erpnext-nginx:$ERPNEXT_VERSION
ERPNEXT_WORKER_TAG=$CONTAINER_REGISTRY/erpnext-worker:$ERPNEXT_VERSION

SOCKETIO_WORKER_TAG=$CONTAINER_REGISTRY/frappe-socketio:$SOCKETIO_VERSION

#
# WORKER
#

echo "Building image $FRAPPE_WORKER_TAG";

podman build \
  --pull \
  --tag "$FRAPPE_WORKER_TAG" \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --file build/frappe-worker/Dockerfile \
  .;

podman push $FRAPPE_WORKER_TAG;


echo "Building image $ERPNEXT_WORKER_TAG";

podman build \
  --pull \
  --tag "$ERPNEXT_WORKER_TAG" \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --build-arg DOCKER_REGISTRY_PREFIX=$CONTAINER_REGISTRY \
  --file build/erpnext-worker/Dockerfile \
  .;

podman push $ERPNEXT_WORKER_TAG;

#
# NGINX
#

echo "Building image $FRAPPE_NGINX_TAG";

podman build \
  --pull \
  --tag "$FRAPPE_NGINX_TAG" \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --file build/frappe-nginx/Dockerfile \
  .;

podman push $FRAPPE_NGINX_TAG;

echo "Building image $ERPNEXT_NGINX_TAG";

podman build \
  --pull \
  --tag "$ERPNEXT_NGINX_TAG" \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --build-arg DOCKER_REGISTRY_PREFIX=$CONTAINER_REGISTRY \
  --file build/erpnext-nginx/Dockerfile \
  .;

podman push $ERPNEXT_NGINX_TAG;

#
# SCOKETIO
#

echo "Building image $SOCKETIO_WORKER_TAG";

podman build \
  --pull \
  --tag "$SOCKETIO_WORKER_TAG" \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --file build/frappe-socketio/Dockerfile \
  .;

podman push $SOCKETIO_WORKER_TAG;