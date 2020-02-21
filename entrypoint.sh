#!/bin/bash

set -eu

for image in ./*; do
      image_name="${image##*/}"
      #pipeline_name="${filename%.*}"

      cd ${image_name}

      echo ${DOCKER_PASSWORD} > my_password.txt
    
      cat my_password.txt | docker login -u ${DOCKER_USERNAME} --password-stdin

      docker build -t smarshops/${image_name} .

      docker push smarshops/${image_name}

      cd ../
done