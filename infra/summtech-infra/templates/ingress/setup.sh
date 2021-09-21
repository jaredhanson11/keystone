kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

helm repo add eks https://aws.github.io/eks-charts

helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName=summtech-cluster-734afcb \
  -n kube-system

k apply -f ingress.yaml

# There still is a step missing where you need to attach a global Accelerator
# I did this all via the console first time around for ease of use, but it shouldn't be challenging
# To include pulumi scripts for it.

# The global accelerator gives static IP's for the ALB. We need static IP's for a
# A record at the root DNS and not a CNAME because CNAME was affecting email deliverability
# since TXT records weren't being picked up properly when root has CNAME.