#!/bin/bash

set -eu


credhub login --skip-tls-validation

DOCKER_USERNAME=`credhub get -q -n concourse/devops/docker-hub-username`
DOCKER_PASSWORD=`credhub get -q -n concourse/devops/docker-hub-password`

docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}

home=$PWD

if [ -z $IMAGE_TO_BUILD ]; then
      for image in *; do
            if [ "$image" != README.md ] && [ "$image" != .github ] && [ "$image" != test.sh ]; then
                  image_name="${image##*/}"
                  cd $image_name
                  echo "<----------------------- Building smarshops/$image_name ----------------------->"
                  docker build $ARGS -t smarshops/${image_name} .
                  echo "<----------------------- Pushing smarshops/$image_name ----------------------->"
                  docker push smarshops/${image_name}
                  cd $home
            fi
      done
else
      cd $IMAGE_TO_BUILD
      echo "<----------------------- Building smarshops/$IMAGE_TO_BUILD ----------------------->"
      docker build $ARGS -t smarshops/$IMAGE_TO_BUILD .
      echo "<----------------------- Pushing smarshops/$IMAGE_TO_BUILD ----------------------->"
      docker push smarshops/$IMAGE_TO_BUILD
fi
