Aim of this project is to use Jenkins tool to  build the image after Testing with SonarQube Or manually push the image after building locally in docker to ECR. 
Create cloud environment with Vpc, subnet, EKS, deployment, external load balancer. The deployment uses the image from ECR. Install Argo CD, Argo Rollouts and perform Blue green deployment. 
Output is captured in Screenshots in outputs folder. This was performed in Different phases. 

Install Argo CD
GitLab
   ↓
Jenkins/Push image directly to ECR
   ├── Test
   ├── SonarQube
   ├── Docker build
   └── Push image → ECR
                    ↓
              GitOps repository
                    ↓
                  Argo CD
                    ↓
                   EKS
                    ↓
             Argo Rollouts
              ↙          ↘
          BLUE             GREEN
        version N       version N+1
              ↓
        promote/rollback


This project/exercise was done in 4 Phases. 
Phase1 - To create the Infrastructure. Vpc, Subnets, EKS
Phase2 - Create deployment, service, load balancer.
Phase3 - Install ArgoCD/ rollouts.
Phase4 - Update Service preview, service-active, rollout gitops mainifest, test and rollout changes for green deployment from blue. 