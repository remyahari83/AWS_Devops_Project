# aws-gitlab-runner-demo

1.In Phase 2, we create the deployment in qa namespace. Already push the image of application to ECR, here it is Qa\_Evaluator application. Specify the image in the container section of deployment. The replica size in deployment is 2.



2.Also for LLM API KEY create a secret. Specify this secrent in env section of container.

kubectl create secret generic qa-evaluator-secrets \\

&#x20; -n qa \\

&#x20; --from-literal=OPENAI\_API\_KEY='key'



Verify -

kubectl get secret qa-evaluator-secrets -n qa





3\. Include service block with  type = "LoadBalancer" with  port = 80 and  target\_port = 8000. This will create an external loadbalancer. Include these subnet tags in vpc.tf to enable the creation of external and internal loadbalancer in public and private subnet of vpc.



public\_subnet\_tags = {
"kubernetes.io/role/elb" = "1"
}

private\_subnet\_tags = {
"kubernetes.io/role/internal-elb" = "1"
}

4\. Push the changes and ensure validate, plan and apply stages succeeded.



5.Access the url provided in apply stage. output parameter called qa\_evaluator\_load\_balancer\_hostname is added in output.tf to obtain this hostname of load balancer. Go to browser and access the application.

