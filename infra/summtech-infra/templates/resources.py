import json

import pulumi
import pulumi_aws
import pulumi_postgresql
from pulumi.resource import ResourceOptions
from pulumi_aws import ec2, eks, get_availability_zones, iam
from pulumi_aws.ec2 import security_group
from pulumi_aws.ec2.get_subnet_ids import get_subnet_ids
from pulumi_aws.ec2.security_group import (
    SecurityGroupEgressArgs,
    SecurityGroupIngressArgs,
)
from pulumi_aws.eks.outputs import ClusterVpcConfig, NodeGroupScalingConfig
from pulumi_postgresql import Database

from . import utils
from .config import Config

config = pulumi.Config()
postgresql_config = pulumi.Config("postgresql")

#### IAM ####
## EKS Cluster Role

pulumi_user = iam.get_user(user_name="pulumi-user")
pulumi_group = iam.Group("pulumi-iam-group")

iam.GroupPolicyAttachment(
    "pulumi-policy-attachment",
    group=pulumi_group.id,
    policy_arn="arn:aws:iam::aws:policy/job-function/SystemAdministrator",
)

iam.UserGroupMembership(
    "pulumi-user-group-membership",
    user=pulumi_user.user_name,
    groups=[pulumi_group.id],
)


eks_role = iam.Role(
    "eks-iam-role",
    assume_role_policy=json.dumps(
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "sts:AssumeRole",
                    "Principal": {"Service": "eks.amazonaws.com"},
                    "Effect": "Allow",
                    "Sid": "",
                }
            ],
        }
    ),
)

iam.RolePolicyAttachment(
    "eks-service-policy-attachment",
    role=eks_role.id,
    policy_arn="arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
)


iam.RolePolicyAttachment(
    "eks-cluster-policy-attachment",
    role=eks_role.id,
    policy_arn="arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
)


## Ec2 NodeGroup Role

ec2_role = iam.Role(
    "ec2-nodegroup-iam-role",
    assume_role_policy=json.dumps(
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "sts:AssumeRole",
                    "Principal": {"Service": "ec2.amazonaws.com"},
                    "Effect": "Allow",
                    "Sid": "",
                }
            ],
        }
    ),
)

iam.RolePolicyAttachment(
    "eks-workernode-policy-attachment",
    role=ec2_role.id,
    policy_arn="arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
)


iam.RolePolicyAttachment(
    "eks-cni-policy-attachment",
    role=ec2_role.id,
    policy_arn="arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
)

iam.RolePolicyAttachment(
    "eks-ecr-policy-attachment",
    role=ec2_role.id,
    policy_arn="arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
)


aws_lb_controller_policy = iam.Policy(
    "eks-loadbalancer-controller-policy",
    policy=json.dumps(
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": [
                        "acm:DescribeCertificate",
                        "acm:ListCertificates",
                        "acm:GetCertificate",
                    ],
                    "Resource": "*",
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "ec2:AuthorizeSecurityGroupIngress",
                        "ec2:CreateSecurityGroup",
                        "ec2:CreateTags",
                        "ec2:DeleteTags",
                        "ec2:DeleteSecurityGroup",
                        "ec2:DescribeAccountAttributes",
                        "ec2:DescribeAddresses",
                        "ec2:DescribeInstances",
                        "ec2:DescribeInstanceStatus",
                        "ec2:DescribeInternetGateways",
                        "ec2:DescribeNetworkInterfaces",
                        "ec2:DescribeSecurityGroups",
                        "ec2:DescribeSubnets",
                        "ec2:DescribeTags",
                        "ec2:DescribeVpcs",
                        "ec2:ModifyInstanceAttribute",
                        "ec2:ModifyNetworkInterfaceAttribute",
                        "ec2:RevokeSecurityGroupIngress",
                    ],
                    "Resource": "*",
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "elasticloadbalancing:AddListenerCertificates",
                        "elasticloadbalancing:AddTags",
                        "elasticloadbalancing:CreateListener",
                        "elasticloadbalancing:CreateLoadBalancer",
                        "elasticloadbalancing:CreateRule",
                        "elasticloadbalancing:CreateTargetGroup",
                        "elasticloadbalancing:DeleteListener",
                        "elasticloadbalancing:DeleteLoadBalancer",
                        "elasticloadbalancing:DeleteRule",
                        "elasticloadbalancing:DeleteTargetGroup",
                        "elasticloadbalancing:DeregisterTargets",
                        "elasticloadbalancing:DescribeListenerCertificates",
                        "elasticloadbalancing:DescribeListeners",
                        "elasticloadbalancing:DescribeLoadBalancers",
                        "elasticloadbalancing:DescribeLoadBalancerAttributes",
                        "elasticloadbalancing:DescribeRules",
                        "elasticloadbalancing:DescribeSSLPolicies",
                        "elasticloadbalancing:DescribeTags",
                        "elasticloadbalancing:DescribeTargetGroups",
                        "elasticloadbalancing:DescribeTargetGroupAttributes",
                        "elasticloadbalancing:DescribeTargetHealth",
                        "elasticloadbalancing:ModifyListener",
                        "elasticloadbalancing:ModifyLoadBalancerAttributes",
                        "elasticloadbalancing:ModifyRule",
                        "elasticloadbalancing:ModifyTargetGroup",
                        "elasticloadbalancing:ModifyTargetGroupAttributes",
                        "elasticloadbalancing:RegisterTargets",
                        "elasticloadbalancing:RemoveListenerCertificates",
                        "elasticloadbalancing:RemoveTags",
                        "elasticloadbalancing:SetIpAddressType",
                        "elasticloadbalancing:SetSecurityGroups",
                        "elasticloadbalancing:SetSubnets",
                        "elasticloadbalancing:SetWebAcl",
                    ],
                    "Resource": "*",
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "iam:CreateServiceLinkedRole",
                        "iam:GetServerCertificate",
                        "iam:ListServerCertificates",
                    ],
                    "Resource": "*",
                },
                {
                    "Effect": "Allow",
                    "Action": ["cognito-idp:DescribeUserPoolClient"],
                    "Resource": "*",
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "waf-regional:GetWebACLForResource",
                        "waf-regional:GetWebACL",
                        "waf-regional:AssociateWebACL",
                        "waf-regional:DisassociateWebACL",
                    ],
                    "Resource": "*",
                },
                {
                    "Effect": "Allow",
                    "Action": ["tag:GetResources", "tag:TagResources"],
                    "Resource": "*",
                },
                {"Effect": "Allow", "Action": ["waf:GetWebACL"], "Resource": "*"},
                {
                    "Effect": "Allow",
                    "Action": [
                        "wafv2:GetWebACL",
                        "wafv2:GetWebACLForResource",
                        "wafv2:AssociateWebACL",
                        "wafv2:DisassociateWebACL",
                    ],
                    "Resource": "*",
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "shield:DescribeProtection",
                        "shield:GetSubscriptionState",
                        "shield:DeleteProtection",
                        "shield:CreateProtection",
                        "shield:DescribeSubscription",
                        "shield:ListProtections",
                    ],
                    "Resource": "*",
                },
            ],
        }
    ),
)

iam.RolePolicyAttachment(
    "eks-loadbalancercontroller-policy-attachment",
    role=ec2_role.id,
    policy_arn=aws_lb_controller_policy.arn,
)


depends_on_iam = ResourceOptions(depends_on=[eks_role, ec2_role])

#### NETWORKING ####

valid_availability_zones = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1d",
    "us-east-1f",
]

public_vpc = ec2.get_vpc(default=True)
public_vpc_subnet_ids = ec2.get_subnet_ids(
    filters=[
        ec2.GetSubnetIdsFilterArgs(
            name="availabilityZone", values=valid_availability_zones
        )
    ],
    vpc_id=public_vpc.id,
)

public_vpc_useast1a_subnet_ids = ec2.get_subnet_ids(
    filters=[
        ec2.GetSubnetIdsFilterArgs(name="availabilityZone", values=["us-east-1a"])
    ],
    vpc_id=public_vpc.id,
)

#### EKS ####

# Create an EKS cluster.
summtech_cluster = eks.Cluster(
    resource_name="summtech-cluster",
    role_arn=eks_role.arn,
    tags={"Name": "summtech-eks-cluster"},
    vpc_config=ClusterVpcConfig(
        public_access_cidrs=["0.0.0.0/0"],
        subnet_ids=public_vpc_subnet_ids.ids,
    ),
)

summtech_node_group = eks.NodeGroup(
    resource_name="summtech-node-group",
    cluster_name=summtech_cluster.name,
    node_role_arn=ec2_role.arn,
    instance_types=["t2.small"],
    tags={"Name": "summtech-cluster-nodegroup"},
    labels={"summtech.io/nodegroup": "summtech-cluster-nodegroup"},
    scaling_config=NodeGroupScalingConfig(max_size=3, min_size=1, desired_size=3),
    subnet_ids=public_vpc_subnet_ids.ids,
)

summtech_nexus_node_group = eks.NodeGroup(
    resource_name="summtech-nexus-group",
    cluster_name=summtech_cluster.name,
    node_role_arn=ec2_role.arn,
    instance_types=["t3.medium"],
    tags={"Name": "summtech-nexus-nodegroup"},
    labels={"summtech.io/nodegroup": "summtech-nexus-nodegroup"},
    scaling_config=NodeGroupScalingConfig(max_size=2, min_size=1, desired_size=2),
    subnet_ids=public_vpc_subnet_ids.ids,
)

# # Export the cluster's kubeconfig.
pulumi.export("cluster-name", summtech_cluster.name)
pulumi.export("kube-config", utils.generate_kube_config(summtech_cluster))


#### MANAGED POSTGRES ####
whitelisted_ips = ["98.42.95.217/32", "52.175.251.223/32"]

postgres_security_group = pulumi_aws.ec2.SecurityGroup(
    "postgres-whitelist",
    ingress=[
        SecurityGroupIngressArgs(
            from_port=5432, to_port=5432, cidr_blocks=whitelisted_ips, protocol="TCP"
        ),
        SecurityGroupIngressArgs(
            from_port=5432,
            to_port=5432,
            security_groups=[summtech_cluster.vpc_config.cluster_security_group_id],
            protocol="TCP",
        ),
    ],
    description="Whitelist for IPs outside of AWS allowed to access postgres.",
    opts=ResourceOptions(depends_on=[summtech_cluster]),
)

summtech_postgres = pulumi_aws.rds.Instance(
    "summtech-postgres",
    allocated_storage=20,
    max_allocated_storage=50,
    engine="postgres",
    engine_version="12.5",
    instance_class="db.t3.small",
    deletion_protection=True,
    name="summtech_admin",
    username="summtech_admin",
    password=postgresql_config.get("password"),
    publicly_accessible=True,
    # vpc_security_group_ids=[postgres_security_group.id, eks_cluster_security_group.id],
    vpc_security_group_ids=[postgres_security_group.id],
    opts=ResourceOptions(depends_on=[postgres_security_group]),
)

postgres_user = pulumi_postgresql.Role(
    "summtech-user",
    name="summtech-user",
    password=config.get("summtech-user-postgres-pw"),
    login=True,
    opts=ResourceOptions(depends_on=[summtech_postgres]),
)

flok_production_db = Database(
    "flok-production",
    name="flok_production",
    owner="summtech-user",
    opts=ResourceOptions(
        depends_on=[summtech_postgres],
    ),
)

flok_staging_db = Database(
    "flok-staging",
    name="flok_staging",
    owner="summtech-user",
    opts=ResourceOptions(
        depends_on=[summtech_postgres],
    ),
)

pigeon_staging_db = Database(
    "pigeon-staging",
    name="pigeon_staging",
    owner="summtech-user",
    opts=ResourceOptions(
        depends_on=[summtech_postgres],
    ),
)

#### S3 ####

flok_s3_bucket = pulumi_aws.s3.Bucket(
    resource_name="flok",
    cors_rules=[
        pulumi_aws.s3.BucketCorsRuleArgs(
            allowed_headers=["*"],
            allowed_methods=["PUT", "POST", "GET"],
            allowed_origins=["*"],
        )
    ],
)

pulumi.export("flok-s3-bucket-name", flok_s3_bucket.bucket)

#### RabbitMQ Broker ####

rabbitmq_config = pulumi.Config("rabbitmq")
rmq_broker = pulumi_aws.mq.Broker(
    "rabbitmq-broker-1",
    broker_name="rabbitmq-broker-1",
    engine_type="RabbitMQ",
    engine_version="3.8.11",
    deployment_mode="SINGLE_INSTANCE",
    host_instance_type="mq.t3.micro",
    apply_immediately=True,  # probably should remove for prod deploy
    publicly_accessible=True,  # can remove with https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/accessing-web-console-of-broker-without-public-accessibility.html
    subnet_ids=public_vpc_useast1a_subnet_ids.ids,
    users=[
        pulumi_aws.mq.BrokerUserArgs(
            username="summtech-user",
            password=rabbitmq_config.get("password"),
        ),
    ],
)

pulumi.export("rmq-broker-1-console", rmq_broker.instances[0].console_url)
pulumi.export("rmq-broker-1-endpoint", rmq_broker.instances[0].endpoints[0])
