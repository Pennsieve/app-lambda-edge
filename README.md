# App Lambda Edge

This Lambda function adds headers to the App's response to a client's request.

## Deployment

__Build and Development Deployment__

Artifacts are built in Jenkins and published to S3. The dev build triggers a deployment of the Lambda function and creates a "Lambda version" that is used by Cloudfront.

__Deployment of an Artifact__

Deployments to production are done via Jenkins.

1. Determine the artifact version you want to deploy (you can find the latest version number in the development deployment job). 
2. Deploy the Lambda function via Jenkins.
3. Grab the "Lambda version" from output of the Jenkins deployment job.
4. In Cloudfront, access the distribution you want to update. In the `Behaviors` tab tick the checkbox next to the `*` `Path Pattern` and click `Edit`.
5. In the `Edit Behavior` page scroll to the bottom. In the `Lambda Function ARN` text box update the `Lambda version` at the end of the ARN. The `Event Type` should be `Origin Response`

For example, to update the Lambda function below, you would update the trailing `4` to the version from the environemnt's Lambda deloyment job1.

`arn:aws:lambda:us-east-1:960751427106:function:dev-app-lambda-use1:4`

