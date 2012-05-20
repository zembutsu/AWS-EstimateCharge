#!/bin/sh

DAT=/var/lib/munin/plugin-aws-cloudwatch/EstimatedCharges_services.dat

export AWS_CLOUDWATCH_HOME=/home/zem/develop/aws/cloudwatch/CloudWatch-1.0.12.1
export PATH=$PATH:/home/zem/develop/aws/cloudwatch/CloudWatch-1.0.12.1/bin
export EC2_REGION=us-east-1
export JAVA_HOME=/usr/local/jdk1.6/
export AWS_CREDENTIAL_FILE=/home/zem/develop/aws/cloudwatch/CloudWatch-1.0.12.1/credential

start=`date --iso-8601=seconds --date '6 hour ago 1 minutes ago'`
end=`date --iso-8601=seconds --date '1 minutes ago'`

echo -n > $DAT

for METRICS in AmazonEC2 AmazonRDS AmazonS3 AmazonRoute53 AmazonSimpleDB AmazonSNS AWSDataTransfer ; do
	echo -n "${METRICS}.value " >> $DAT
	/home/zem/develop/aws/cloudwatch/CloudWatch-1.0.12.1/bin/mon-get-stats \
		 EstimatedCharges \
		--statistics "Maximum" \
		--namespace "AWS/Billing" \
		--dimensions "ServiceName=${METRICS},Currency=USD" \
		--start-time $start --end-time $end | tail -1 | cut -f4 -d' ' >> $DAT
done



