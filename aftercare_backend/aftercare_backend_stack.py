from os import path

import aws_cdk as cdk
from aws_cdk import (
    # Duration,
    Stack,
    # aws_sqs as sqs,
)
from aws_cdk import aws_apigateway as apigw
from aws_cdk import aws_ec2 as ec2
from aws_cdk import aws_lambda as _lambda
from aws_cdk import aws_lambda_nodejs as nodejs
from aws_cdk import aws_rds as rds
from aws_cdk import aws_secretsmanager as secrets_manager
from aws_cdk.aws_secretsmanager import SecretStringGenerator
from constructs import Construct

# Global variables
environment = "dev"
app_name = "aftercare"
base_service_name = environment + "-" + app_name


def create_service_name(string):
    return base_service_name + "-" + string


class AftercareBackendStack(Stack):
    # create function that returns a string made up of the passed argument
    # create a function that returns a string made up of the passed argument

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        database_name = create_service_name("database").replace("-", "")
        master_db_name_username = "masteradmin"

        # Create a VPC
        vpc = ec2.Vpc(self, create_service_name("database-vpc"), max_azs=2, subnet_configuration=[
            ec2.SubnetConfiguration(
                name="Public",
                subnet_type=ec2.SubnetType.PUBLIC
            )
        ])

        # create a secret in aws secrets manager
        secret = secrets_manager.Secret(self, 'Secret',
                                        secret_name=create_service_name("admin-database-password"),
                                        generate_secret_string=SecretStringGenerator(
                                            secret_string_template='{"username": "' + master_db_name_username + '"}',
                                            generate_string_key="password",
                                            exclude_characters="/@\" ",
                                            include_space=False,
                                            password_length=12, )
                                        )
        # Create the Serverless PostgreSQL cluster
        if environment == "prod":
            cluster = rds.ServerlessCluster(self, create_service_name("postgres-cluster"),
                                            engine=rds.DatabaseClusterEngine.aurora_postgres(
                                                version=rds.AuroraPostgresEngineVersion.VER_13_4),
                                            credentials=rds.Credentials.from_secret(secret),  # Use generated secret
                                            default_database_name=database_name,
                                            deletion_protection=True,
                                            vpc=vpc,
                                            scaling=rds.ServerlessScalingOptions(
                                                auto_pause=cdk.Duration.minutes(5),
                                                min_capacity=rds.AuroraCapacityUnit.ACU_2,
                                                max_capacity=rds.AuroraCapacityUnit.ACU_4
                                            ))
        else:  # publicly accessible database

            cluster = rds.ServerlessCluster(self, create_service_name("postgres-cluster"),
                                            engine=rds.DatabaseClusterEngine.aurora_postgres(
                                                version=rds.AuroraPostgresEngineVersion.VER_13_4),
                                            # credentials=rds.Credentials.from_secret(secret),  # Use generated secret
                                            default_database_name=database_name,
                                            vpc=vpc,
                                            vpc_subnets=ec2.SubnetSelection(subnet_type=ec2.SubnetType.PUBLIC),
                                            enable_data_api=True,
                                            # Make cluster publicly accessible
                                            scaling=rds.ServerlessScalingOptions(
                                                auto_pause=cdk.Duration.minutes(5),
                                                min_capacity=rds.AuroraCapacityUnit.ACU_2,
                                                max_capacity=rds.AuroraCapacityUnit.ACU_4
                                            ))
            # todo: add a security group to allow access from the internet
            cluster.connections.allow_default_port_from_any_ipv4("Allow connections from the internet")

        # Define a new Node.js Lambda function and specify the details
        lambda_func = nodejs.NodejsFunction(
            self,
            id=create_service_name("backend-mono-lambda"),
            runtime=_lambda.Runtime.NODEJS_18_X,
            entry=path.join("./src/index.ts"),  # Path to Lambda handler code
            handler="handler",  # Exported function in file
        )

        # Define a new API Gateway REST API resource backed by our "handler" function.
        apigw.LambdaRestApi(
            self,
            create_service_name("api-gateway"),
            handler=lambda_func,
            default_cors_preflight_options=apigw.CorsOptions(
                allow_origins=apigw.Cors.ALL_ORIGINS,
                allow_methods=apigw.Cors.ALL_METHODS,
            ),
            proxy=True
        )
