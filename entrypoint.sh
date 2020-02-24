#!/bin/bash

set -eu

echo ${DOCKER_PASSWORD} > my_password.txt

cat my_password.txt | docker login -u ${DOCKER_USERNAME} --password-stdin

for image in *; do
      image_name="${image##*/}"

      if [$image != "README.MD"] || [$image != ".github"] ; then

            cd ${image_name}

            docker build -t smarshops/${image_name} .

            docker push smarshops/${image_name}

            cd ../
      fi
done