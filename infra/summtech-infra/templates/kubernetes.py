"""Namespace setup for managed kuberenetes"""

from os import path, remove
from pathlib import Path

import pulumi_kubernetes
import yaml
from pulumi.resource import ResourceOptions
from pulumi.stack_reference import StackReference
from pulumi_kubernetes import Provider
from pulumi_kubernetes.helm.v3.helm import FetchOpts, LocalChartOpts
from pulumi_kubernetes.networking.v1beta1 import IngressBackendArgs, IngressSpecArgs

from . import iam_users, utils
from .config import Config
from .resources import summtech_cluster, summtech_nexus_node_group, summtech_node_group

kubeconfig = utils.generate_kube_config(summtech_cluster)
cluster_name = summtech_cluster.name.apply(lambda name: name)
eks_provider = Provider(
    "summtech-cluster-provider",
    kubeconfig=kubeconfig,
    opts=ResourceOptions(depends_on=[summtech_cluster, summtech_node_group]),
)

## CONSTANTS
KUBE_SYSTEM_NS = "kube-system"
NGINX_INGRESS_CHART_NAME = "ingress-nginx"
HELM_REPO_FETCH_OPTS = {
    "ingress-nginx": pulumi_kubernetes.helm.v3.FetchOpts(
        repo="https://kubernetes.github.io/ingress-nginx"
    ),
    "sonatype": pulumi_kubernetes.helm.v3.FetchOpts(
        repo="https://sonatype.github.io/helm3-charts/"
    ),
    "bitnami": pulumi_kubernetes.helm.v3.FetchOpts(
        repo="https://charts.bitnami.com/bitnami"
    ),
    "stable": pulumi_kubernetes.helm.v3.FetchOpts(repo="https://charts.helm.sh/stable"),
    "summtech": pulumi_kubernetes.helm.v3.FetchOpts(
        repo="https://charts.helm.sh/stable"
    ),
}

# # nginx ingress controller deployment
nginx_ingress_values = {
    "controller": {
        "name": "controller",
        "service": {
            "type": "NodePort",
            "targetPorts": {"http": "http", "https": "http"},
        },
        "config": {"use-forwarded-headers": "true"},
    }
}
nginx_ingress_controller = pulumi_kubernetes.helm.v3.Chart(
    "ingress-nginx",
    pulumi_kubernetes.helm.v3.ChartOpts(
        chart=NGINX_INGRESS_CHART_NAME,
        version="3.23.0",
        namespace=KUBE_SYSTEM_NS,
        values=nginx_ingress_values,
        fetch_opts=HELM_REPO_FETCH_OPTS["ingress-nginx"],
    ),
    opts=ResourceOptions(
        depends_on=[summtech_cluster, summtech_node_group], provider=eks_provider
    ),
)

### handle deployments

deploys = Path(Config.get_deploys_dir())
# namespaces come from folders in deploys dir
namespaces = [f.name for f in deploys.iterdir() if f.is_dir()]

namespaces_dict = {}
for _namespace in namespaces:
    namespace = pulumi_kubernetes.core.v1.Namespace(
        resource_name=_namespace,
        opts=ResourceOptions(
            depends_on=[summtech_cluster, summtech_node_group],
            delete_before_replace=True,
            provider=eks_provider,
        ),
    )
    namespaces_dict[_namespace] = namespace.metadata.name.apply(lambda name: name)

manifest: dict = yaml.safe_load(deploys.joinpath("manifest.yaml").read_bytes())
deploy_keys = list(manifest.keys()) if manifest else []
for _deployment in deploy_keys:
    deploys_args = manifest.get(_deployment, [])
    for deploy_args in deploys_args:
        deploy_name = deploy_args["name"]
        namespace = deploy_args["namespace"]
        reponame, chartname = deploy_args["chartName"].split("/")
        values = yaml.safe_load(
            Path(Config.get_deploys_dir())
            .joinpath(namespace)
            .joinpath(f"{deploy_name}.yaml")
            .read_bytes()
        )

        if reponame == "local":
            chart_path = str(
                Path(Config.get_charts_dir()).joinpath(chartname).as_posix()
            )
            chart_opts = pulumi_kubernetes.helm.v3.LocalChartOpts(
                chart_path,
                namespace=namespaces_dict[namespace],
                values=values,
            )
        else:
            chart_opts = pulumi_kubernetes.helm.v3.ChartOpts(
                chart=chartname,
                namespace=namespaces_dict[namespace],
                values=values,
                fetch_opts=HELM_REPO_FETCH_OPTS[reponame],
            )

        deploy = pulumi_kubernetes.helm.v3.Chart(
            _deployment,
            config=chart_opts,
            opts=ResourceOptions(
                depends_on=[summtech_cluster, summtech_nexus_node_group],
                provider=eks_provider,
            ),
        )
