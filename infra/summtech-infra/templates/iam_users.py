import json

import pulumi
import pulumi_aws
from pulumi import resource
from pulumi.resource import ResourceOptions
from pulumi_aws import ec2, eks, get_availability_zones, iam
from pulumi_aws.ec2.get_subnet_ids import get_subnet_ids
from pulumi_aws.eks.outputs import ClusterVpcConfig, NodeGroupScalingConfig
from pulumi_aws.iam import user_login_profile

from . import iam_users, utils
from .config import Config

#### IAM ####

summtech_user_group = iam.Group("summtech-user-group", path="/groups/")
summtech_admin_group = iam.Group("summtech-admin-group", path="/groups/")

iam.GroupPolicyAttachment(
    "summtech-user-group-policy-attachment",
    group=summtech_user_group.id,
    policy_arn="arn:aws:iam::aws:policy/AmazonS3FullAccess",
)
iam.GroupPolicyAttachment(
    "summtech-admin-group-policy-attachment",
    group=summtech_admin_group.id,
    policy_arn="arn:aws:iam::aws:policy/AdministratorAccess",
)

# NOTE on user creation:
# To decrypt, with jaredhanson11 private key in keyring
# `pgp -d ./encrypted_pgp_message.asc > decrypted_file.txt`
summtech_users = {
    "jared@goflok.com": [summtech_admin_group, summtech_user_group],
    "harris@goflok.com": [summtech_admin_group, summtech_user_group],
    "anthony@goflok.com": [summtech_admin_group, summtech_user_group],
    "yan@goflok.com": [summtech_admin_group, summtech_user_group],
    "andrew@goflok.com": [summtech_user_group],
}

for _user in summtech_users:
    groups = summtech_users[_user]
    iam_user = iam.User(resource_name=_user, name=_user)
    user_login_profile = iam.UserLoginProfile(
        f"{_user}-login-profile",
        user=iam_user.name,
        pgp_key="keybase:jaredhanson11",
    )
    pulumi.export(f"{_user}-password", user_login_profile.encrypted_password)
    for _i, _group in enumerate(groups):
        iam.UserGroupMembership(
            f"{_user}-{_i}-group-membership",
            opts=ResourceOptions(depends_on=[_group, iam_user]),
            user=iam_user.name,
            groups=[
                _group.name,
            ],
        )
