# deploy.sh
#! /bin/bash

SHA1=$1

# Deploy image to Docker Hub
docker push deveska/qwil-deploy:$HA1

# Create new Elastic Beanstalk version
EB_BUCKET=hello-bucket-ska
DOCKERRUN_FILE=$SHA1-Dockerrun.aws.json
sed "s/<TAG>/$SHA1/" < Dockerrun.aws.json.template > $DOCKERRUN_FILE
aws s3 cp $DOCKERRUN_FILE s3://$EB_BUCKET/$DOCKERRUN_FILE

sed "s/<EMAIL>/$DOCKER_EMAIL/;s/<AUTH>/$DOCKER_AUTH/" < .dockercfg.template > ~/.dockercfg
aws s3 cp ~/.dockercfg s3://$EB_BUCKET/dockercfg

aws elasticbeanstalk create-application-version --application-name hello \
  --version-label $SHA1 --source-bundle S3Bucket=$EB_BUCKET,S3Key=$DOCKERRUN_FILE

# Update Elastic Beanstalk environment to new version
aws elasticbeanstalk update-environment --environment-name hello-env \
    --version-label $SHA1
