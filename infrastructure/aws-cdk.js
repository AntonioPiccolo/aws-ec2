#!/usr/bin/env node
const cdk = require('aws-cdk-lib');
const { AwsEc2Stack } = require('./aws-cdk-ec2-stack');

const app = new cdk.App();

new AwsEc2Stack(app, 'AwsEc2Stack', {
  env: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_DEFAULT_REGION,
  },
});