# aws-gitlab-runner-demo

Phase 3:
1.monitoring_values.yaml (grafana). Create loadbalancer type service for grafana deployment, load balancer(internal), Bastion host for internal access. loadBalancerClass: service.k8s.aws/nlb.
2.iam_lb_controller.tf -Create policy for loadbalancer(AWSLoadBalancerControllerIAMPolicy), role(AmazonEKSLoadBalancerControllerRole) , policy attachment and grant to service account (aws-load-balancer-controller).
3.helm.tf - Install kubeprometheus stack. Specify the values from monitoring-values.yaml which has specification for prometheus, grafana, alert-manager resources. Specify the service acccount created in step 2 here.     {
      name  = "serviceAccount.name"
      value = kubernetes_service_account.aws_load_balancer_controller.metadata[0].name
    }
 name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

4.provider.tf - helm Provider. 

5.bastion.tf - Iam roles , security groups , ingress rules, ec2 instance to create grafana bastion. 