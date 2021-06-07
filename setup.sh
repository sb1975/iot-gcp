#!/bin/bash

echo "Data Streaming Pipeline setup will begin..."
echo ""

#Enable Cloud PubSub & Cloud IoT Core APIs
gcloud services enable compute.googleapis.com pubsub.googleapis.com cloudiot.googleapis.com 
echo "Cloud PubSub & Cloud IoT Core APIs are enabled..."
echo ""

#Create a PubSub topic
gcloud pubsub topics create data-streaming-topic
echo "data-streaming-topic pubsub topic created..."
echo ""

#Create a Subscription for this PubSub topic created above for testing purpose
gcloud pubsub subscriptions create data-streaming-sub --topic=data-streaming-topic
echo "data-streaming-sub pubsub subscription created for testing purpose..."
echo ""

#Create the Cloud IoT Core Device Registry
gcloud iot registries create data-streaming-iot-core-registry --event-notification-config=topic=data-streaming-topic --region=us-central1 --no-enable-http-config
echo "data-streaming-iot-core-registry Cloud IoT Core Device Registry created..."
echo ""

#Generate a device key pair prefer RS256
openssl req -x509 -newkey rsa:2048 -keyout rsa_private.pem -nodes -out rsa_cert.pem -subj "/CN=unused"
openssl pkcs8 -topk8 -inform PEM -outform DER -in rsa_private.pem -nocrypt > rsa_private_pkcs8
echo "RS256 key paid generated..."
echo ""

#Add a device to the registry using the keys you generated
gcloud iot devices create device-1 --registry=data-streaming-iot-core-registry --region=us-central1 --public-key=path=./rsa_cert.pem,type=RS256
echo "device-1 is added to data-streaming-iot-core-registry registry"
echo ""

echo "Data Streaming Pipeline setup is completed..."