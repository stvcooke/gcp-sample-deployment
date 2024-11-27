# gcp-sample-deployment
Sample deployment to GCP Cloud Run for an API endpoint

## Purpose of this repository
The purpose of this repository is to demonstrate a working knowledge of Terraform, it's scalability with modules, as well as my understanding of important supporting aspects, such as monitoring, security and ease-of-use.

## Requirements (paraphrased)
Deploy an API endpoint, as well as supporting infrastructure and access, such as a bucket and a message bus.

## Architectural design
This section to be completed later, after exploring an AI tool that builds a diagram based on Terraform code.

## My thought process
This section will describe how I'm going through this 

### Initial todo:
1. Copy a hello world app in Go to use as a test subject. Ignore lack of tests.
1. Create a project in GCP to deploy this to.
1. Do some quick Terraform writing to create a VPC, the bucket, the message bus, all privately accessible. Possibly use public modules.
1. Look more into Cloud Run, determine if an API Gateway is necessary, and determine if there is security functionality such as a WAF that can be paired with it.
1. Look into visibility metrics and native support in GCP for out of the box monitoring and logging.
1. Determine if necessary to create an image registry for the container image to run on Cloud Run.
1. Build out the Terraform for the Cloud Run function, image support, API Gateway/WAF (if necessary) and logging and metric support.


### Things I'd like to do, but won't have time to do:
1. Ability to create a custom service account that only has access to deploy what is necessary.
1. Build a pipeline that includes auto-building the container image (if necessary) and deploying the infrastructure. These repositories could also be split up, so developing the app happens in one repository and supporting infrastructure is deployed in another. I'm not sure which is exactly the best route, due to my unfamiliarity with specific deployment strategies in Cloud Run.
1. Creating a re-usable module for anyone to run container workloads on Cloud Run, with built in logging and metric support (and maybe a container registry).