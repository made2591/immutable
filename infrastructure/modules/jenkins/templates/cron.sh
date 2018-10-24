#!/bin/bash

access_key=$1
secret_key=$2
s3_bucket=$3

JENKINS_HOME=/opt/jenkins_home

(crontab -l 2>/dev/null; echo "*/2 * * * *      /usr/bin/docker run --env aws_key=${access_key} --env aws_secret=${secret_key} --env cmd=sync-local-to-s3 --env DEST_S3=s3://${s3_bucket}/jenkins_home/  -v $JENKINS_HOME:/opt/src/$(/bin/date +\%Y\%m\%d) garland/docker-s3cmd") | crontab -
(crontab -l 2>/dev/null; echo "1-59/2 * * * *      /usr/bin/docker run --env aws_key=${access_key} --env aws_secret=${secret_key} --env cmd=sync-s3-to-local --env SRC_S3=s3://${s3_bucket}/jenkins_home/  -v $JENKINS_HOME:/opt/src/$(/bin/date +\%Y\%m\%d) garland/docker-s3cmd") | crontab -
