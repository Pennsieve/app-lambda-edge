# App Lambda Edge

This Lambda function adds headers to the App's response to a client's request.

## Deployment

__Build and Development Deployment__

Artifacts are built in Jenkins and published to S3. The dev build triggers a deployment of the Lambda function and
creates a "Lambda version" that can be used by Cloudfront.
See steps 4 - 6 below for how to update Cloudfront to use the new version.

__Deployment of an Artifact__

Deployments to production are done via Jenkins.

1. Determine the artifact version you want to deploy (you can find the latest version number in the development
   deployment job).
2. Deploy the Lambda function via Jenkins.
3. Grab the "Lambda version" from output of the Jenkins deployment job.
4. In Cloudfront, access the distribution you want to update. In the `Behaviors` tab tick the checkbox next to
   the `*` `Path Pattern` and click `Edit`.
5. In the `Edit Behavior` page scroll to the bottom. In the `Lambda Function ARN` text box update the `Lambda version`
   at the end of the ARN. The `Event Type` should be `Origin Response`

   For example, to update the Lambda function below, you would update the trailing `6` to the version from the
   environment's Lambda deployment job.

   `arn:aws:lambda:us-east-1:960751427106:function:dev-app-lambda-use1:6`
6. In the `Invalidations` page choose `Create invalidation` with path `/*`. This will force Cloudfront to use the new
   Lambda version.
