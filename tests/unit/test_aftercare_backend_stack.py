import aws_cdk as core
import aws_cdk.assertions as assertions

from aftercare_backend.aftercare_backend_stack import AftercareBackendStack

# example tests. To run these tests, uncomment this file along with the example
# resource in aftercare_backend/aftercare_backend_stack.py
def test_sqs_queue_created():
    app = core.App()
    stack = AftercareBackendStack(app, "aftercare-backend")
    template = assertions.Template.from_stack(stack)

#     template.has_resource_properties("AWS::SQS::Queue", {
#         "VisibilityTimeout": 300
#     })
