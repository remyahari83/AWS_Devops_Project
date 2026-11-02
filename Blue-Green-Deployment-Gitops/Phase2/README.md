
Below mentioned are the changes in Phase2 which is to create a deployment and access the application through external loadbalancer. 


1.Pushed the image of application to ECR, here it is Qa_Evaluator application. Specify the image in the container section of deployment. The replica size in deployment is specified as 2.

2.Also for LLM API KEY create a secret. Opted to create it manually. Specify this secrent in env section of container.

kubectl create secret generic qa-evaluator-secrets \\
 -n qa \\
--from-literal=OPENAI_API_KEY='key'
Verify secret creation - kubectl get secret qa-evaluator-secrets -n qa

3.Include service block with  type = "LoadBalancer" with  port = 80 and  target_port = 8000 in svc_lb.tf. This will create an external loadbalancer. Include these subnet tags in vpc.tf to enable the creation of external and internal loadbalancer in public and private subnet of vpc.

resource "aws_ec2_tag" "public_subnet_elb" {
  for_each = toset(module.vpc.public_subnets)

  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "private_subnet_internal_elb" {
  for_each = toset(module.vpc.private_subnets)

  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}
4.Push the changes and ensure validate, plan and apply stages succeeded.

5.Access the url provided in apply stage.Output parameter called qa_evaluator_load_balancer_hostname is added in output.tf to obtain this hostname of load balancer. Go to browser and access the application and check if application is accesible and response is 200.