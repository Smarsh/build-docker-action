#!/bin/bash

set -e

credhub login --skip-tls-validation

DOCKER_USERNAME=`credhub get -q -n concourse/devops/docker-hub-username`
DOCKER_PASSWORD=`credhub get -q -n concourse/devops/docker-hub-password`

docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}

home=$PWD

if [[ -z $IMAGE_TO_BUILD ]]; then
      pivnet login --api-token=$PIVNET_TOKEN

      pivnet download-product-files --product-slug='pcf-app-autoscaler' --release-version='2.0.233' --product-file-id=516742
      
      for image in *; do
            if [ "$image" != README.md ] && [ "$image" != .github ] && [ "$image" != test.sh ]; then
                  image_name="${image##*/}"
                  cp autoscaler-for-pcf-cliplugin-linux32-binary-2.0.233 $image_name/
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
      pivnet login --api-token=$PIVNET_TOKEN

      pivnet download-product-files --product-slug='pcf-app-autoscaler' --release-version='2.0.233' --product-file-id=516742
      
      echo "<----------------------- Building smarshops/$IMAGE_TO_BUILD ----------------------->"
      if [[ -z "$ARGS" ]]; then
            docker build $ARGS -t smarshops/$IMAGE_TO_BUILD .
      else
            docker build $ARGS -t smarshops/$IMAGE_TO_BUILD .
      fi
      echo "<----------------------- Pushing smarshops/$IMAGE_TO_BUILD ----------------------->"
      docker push smarshops/$IMAGE_TO_BUILD
fi
