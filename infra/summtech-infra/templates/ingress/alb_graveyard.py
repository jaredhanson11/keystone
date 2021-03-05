# aws lb ingress controller
# alb_ingress_values = {"clusterName": "summtech-cluster-2bc50c6"}
# cluster_name = summtech_cluster.name.apply(lambda name: name)
# alb_ingress_values = {"clusterName": cluster_name}


# def remove_status(obj, opts):
#     if obj["kind"] == "CustomResourceDefinition":
#         del obj["status"]


# def add_name(name):
#     def _add_name(obj, opts):
#         if obj["kind"] == "Kustomization":
#             _metadata = obj.get("metadata", {})
#             if not _metadata.get("name"):
#                 _metadata["name"] = name
#                 obj["metadata"] = _metadata

#     return _add_name

# alb_service_account = pulumi_kubernetes.core.v1.ServiceAccount(
#     "loadbalancer-controller-sa",
#     opts=ResourceOptions(depends_on=[summtech_cluster]),
#     metadata=pulumi_kubernetes.meta.v1.ObjectMetaArgs(
#         namespace="kube-system", cluster_name=cluster_name, annotations={
#             "eks.amazonaws.com/role-arn": "arn:aws:iam::<AWS_ACCOUNT_ID>:role/<IAM_ROLE_NAME>"
#         }
#     ),
# )

# alb_kustomization_crds = pulumi_kubernetes.yaml.ConfigFile(
#     "loadbalancer-crds",
#     file="./crds/crds.yaml",
#     opts=ResourceOptions(depends_on=[summtech_cluster]),
#     transformations=[remove_status],
# )

# alb_kustomization = pulumi_kubernetes.yaml.ConfigFile(
#     "loadbalancer-kustomization",
#     file="./crds/kustomization.yaml",
#     opts=ResourceOptions(depends_on=[summtech_cluster, alb_kustomization_crds]),
#     transformations=[remove_status],
# )

# alb_ingress_controller = pulumi_kubernetes.helm.v3.Chart(
#     "alb-ingress-controller",
#     pulumi_kubernetes.helm.v3.ChartOpts(
#         chart="aws-load-balancer-controller",
#         namespace="kube-system",
#         values=alb_ingress_values,
#         fetch_opts=FetchOpts(repo="https://aws.github.io/eks-charts"),
#         transformations=[remove_status],
#     ),
#     opts=ResourceOptions(depends_on=[summtech_cluster]),
# )


# arn = "arn:aws:acm:us-east-1:668951522996:certificate/66ca387c-8f13-44d5-800f-623c8740f8f9"
# ingress_nginx_svc = (
#     "ingress-nginx-controller"  # helm resource name + values.controller.name
# )

# alb_nginx_controller_ingress_yaml = """apiVersion: extensions/v1beta1
# kind: Ingress
# metadata:
#   name: nginx-ingress-controller-ing
#   namespace: kube-system
#   annotations:
#     kubernetes.io/ingress.class: alb
#     alb.ingress.kubernetes.io/scheme: internet-facing
#     alb.ingress.kubernetes.io/listen-ports: "[{'HTTP': 80}, {'HTTPS': 443}]"
#     alb.ingress.kubernetes.io/target-type: ip
#     alb.ingress.kubernetes.io/certificate-arn: {arn}
#     alb.ingress.kubernetes.io/healthcheck-path: "/healthz"
#     alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'

# spec:
#   rules:
#   - http:
#       paths:
#       - path: /*
#         backend:
#           serviceName: ssl-redirect
#           servicePort: use-annotation
#       - path: /*
#         backend:
#           serviceName: {svc}
#           servicePort: http

# """.format(
#     svc=ingress_nginx_svc,
#     arn=pulumi_config.get("cert-arns"),
# )

# alb_nginx_controller_ingress = pulumi_kubernetes.ConfigGroup(
#     "alb-nginx-controller-ingress",
#     yaml=[alb_nginx_controller_ingress_yaml],
#     opts=ResourceOptions(depends_on=[alb_ingress_controller, nginx_ingress_controller]),
# )

# cluster_ingress = alb_nginx_controller_ingress.get_resource(
#     "extensions/v1beta1/Ingress", "nginx-ingress-controller-ing", "kube-system"
# )
# pulumi.export(
#     "ingress-dns", cluster_ingress.status["loadBalancer"]["ingress"]["hostname"]
# )
