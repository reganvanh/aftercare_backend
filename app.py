#!/usr/bin/env python3
import os

import aws_cdk as cdk

from aftercare_backend.aftercare_backend_stack import AftercareBackendStack

app = cdk.App()
AftercareBackendStack(app, "AftercareBackendStack",
                      # If you don't specify 'env', this stack will be environment-agnostic.
                      # Account/Region-dependent features and context lookups will not work,
                      # but a single synthesized template can be deployed anywhere.

                      # Uncomment the next line to specialize this stack for the AWS Account
                      # and Region that are implied by the current CLI configuration.

                      env=cdk.Environment(account=os.getenv('aftercare'), region=os.getenv('us-east-1')),

                      # Uncomment the next line if you know exactly what Account and Region you
                      # want to deploy the stack to. */

                      # env=cdk.Environment(account='791697229688', region='us-east-1'),

                      # For more information, see https://docs.aws.amazon.com/cdk/latest/guide/environments.html
                      )

app.synth()
