                     GitLab
                       |
                       v
                  GitLab Runner
                   Default VPC
                       |
                  AWS / K8s API
                       |
                       v
              +------------------+
              |   EKS Control    |
              |      Plane       |
              +--------+---------+
                       |
              Private Subnets
                       |
             +---------+---------+
             |                   |
        EKS Worker 1        EKS Worker 2
          t3.small             t3.small
             |                   |
       +-----+-----+       +-----+------+
       |           |       |            |
     CRUD       Prometheus CRUD      Grafana
                         |
                    Alertmanager

The objective of this project is to setup Observability with Prometheus/Grafana stack. The project was done in three phases. 
Phase 1: Setup the cloud environment with VPC, Public and private subnets, required IAM permissions, EKS setup and managed node groups.
Phase 2: Upload image of application to ECR. Grant all required IAM permissions. Setup deployment with sevice exposed to external load balancer.
Phase 3: Create Bastion in private subnet for controlled access to Internal Grafana NLB. Configure Prometheus, Grafana, Alertmanger resources , Grafana service as load balancer. Specify an internal loadBalancer class for Network loadbalancer. Create IAM policy and role attach them. Create service account and associate the role. This is for create and managing AWS NLB. Create the kubeprometheus stack, LoadBalancer Controller from Helm chart. 
Create tunnel to Bastion and access the Grafana url. 
