#! /usr/bin/env bash

REGION=us-west-2
USER=AWS
CLUSTER=learn-elixir-lander
SERVICE=learn-elixir-lander-service
DOCKER_IMAGE=learn-elixir-landing
ECR_URL=991072479495.dkr.ecr.us-west-2.amazonaws.com
ECR_REPO=$ECR_URL/$DOCKER_IMAGE

function active-tasks() {
  # --profile $USER \
  aws ecs list-tasks \
    --cluster=$CLUSTER \
    --region=$REGION \
  | pcregrep -Mo ": \[\K[^]]*" \
  | awk '{print $1}' \
  | sed '/^$/d' \
  | sed 's/,//' \
  | xargs -n1 \
  | sed -E 's/^.+task\/(.*)/\1/'
}

function stop-active-tasks() {
      # --profile=$USER \
  ACTIVE_TASKS=$(active-tasks)
  echo "Killing active tasks $ACTIVE_TASKS..."
  IFS='
  '
  for TASK in $ACTIVE_TASKS
  do
    aws ecs stop-task \
      --cluster=$CLUSTER \
      --region=$REGION \
      --task=$TASK > /dev/null
  done
}

function update-service-with-new-deployment() {
  echo "Deploying $SERVICE in $REGION on $CLUSTER..."
  # --profile=$USER \
  aws ecs update-service \
    --region=$REGION \
    --cluster=$CLUSTER \
    --service=$SERVICE \
    --force-new-deployment > /dev/null
  echo "Deployment ran"
}

function build-docker-image() {
  docker build -t $DOCKER_IMAGE -f Dockerfile . &&
  docker tag $DOCKER_IMAGE:latest $ECR_REPO:latest &&
  aws ecr get-login-password --region $REGION | docker login --username $USER --password-stdin $ECR_URL &&
  docker push $ECR_REPO:latest
}

build-docker-image && stop-active-tasks && update-service-with-new-deployment
