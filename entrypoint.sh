#!/bin/bash

set -eu


credhub login --skip-tls-validation

DOCKER_USERNAME=`credhub get -q -n concourse/devops/docker-hub-username`
DOCKER_PASSWORD=`credhub get -q -n concourse/devops/docker-hub-password`

docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}

home=$PWD

for image in *; do
      if [ "$image" != README.md ] && [ "$image" != .github ]; then
            image_name="${image##*/}"
            cd $image_name
            echo "<----------------------- Building smarshops/$image_name ----------------------->"
            docker build -t smarshops/${image_name} .
            echo "<----------------------- Pushing smarshops/$image_name ----------------------->"
            docker push smarshops/${image_name}
            cd $home
      fi
done
