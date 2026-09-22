1. Create an EC2 instance

In AWS Console:

EC2 → Instances → Launch instance

Use approximately:

Setting	Recommendation
Name	gitlab-runner
AMI	Ubuntu Server 24.04 LTS
Instance type	Free-Tier eligible instance shown by your account
Key pair	Create/select your SSH key
Storage	20–30 GB gp3
Security group	SSH port 22 from My IP
Public IP	Yes

You don't need HTTP/HTTPS inbound ports for the runner itself because the runner normally makes outbound connections to GitLab.

Important: AWS Free Tier eligibility depends on your account's current offer and instance/region, so check the EC2 launch page's Free Tier label rather than assuming a particular instance is free.

2. Connect to the EC2 server

From Windows PowerShell:

ssh -i "your-key.pem" ubuntu@<EC2-PUBLIC-IP>

For example:

ssh -i "gitlab-runner.pem" ubuntu@3.xx.xx.xx

Then:

sudo apt update
sudo apt upgrade -y
3. Install Docker

Since you want to use this as a proper DevOps lab, I recommend the Docker executor.

GitLab Runner's Docker executor runs each CI job in a Docker container.

Install Docker:

sudo apt install -y docker.io

Start it:

sudo systemctl enable docker
sudo systemctl start docker

Check:

docker --version

Test:

sudo docker run hello-world
4. Install GitLab Runner

GitLab provides an official repository for Ubuntu/Debian installations.

Run:

curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" \
-o script.deb.sh

Then:

sudo bash script.deb.sh

Install:

sudo apt install -y gitlab-runner

Check:

gitlab-runner --version

And:

sudo systemctl status gitlab-runner
5. Give GitLab Runner access to Docker

The gitlab-runner user needs permission to communicate with Docker.

Run:

sudo usermod -aG docker gitlab-runner

Then restart:

sudo systemctl restart gitlab-runner

You can verify:

sudo -u gitlab-runner docker ps

If you see the Docker container list without a permission error, you're good.

6. Create a Runner in GitLab

Go to your GitLab project.

Then:

Project → Settings → CI/CD → Runners

Depending on the current GitLab UI, you'll see an option to create a project runner.

Create one such as:

Name:
aws-ec2-runner

Tags:
aws
docker

Run untagged jobs:
Enable

GitLab will provide a runner authentication token for registration.

Don't post that token publicly or commit it to GitHub.

7. Register the runner on EC2

On your EC2 machine:

sudo gitlab-runner register

It will ask questions.

GitLab instance URL

Enter:

https://gitlab.com/
Token

Paste the token GitLab gave you.

Runner description

For example:

aws-ec2-runner
Tags

For example:

aws,docker
Executor

Enter:

docker
Default Docker image

Use:

ubuntu:24.04

The Docker executor requires a default image unless your .gitlab-ci.yml defines one.

8. Verify the runner

Run:

sudo gitlab-runner list

You should see something similar to:

aws-ec2-runner
Executor=docker
URL=https://gitlab.com/

Also:

sudo systemctl status gitlab-runner
9. Create a test GitLab pipeline

Create .gitlab-ci.yml in your repository:

stages:
  - test

test_runner:
  stage: test

  image: ubuntu:24.04

  script:
    - echo "Hello from GitLab Runner!"
    - echo "Running on AWS EC2"
    - uname -a
    - cat /etc/os-release

Commit and push:

git add .gitlab-ci.yml
git commit -m "Add GitLab CI pipeline"
git push

Go to:

GitLab → Build → Pipelines

You should see:

Pipeline
   |
   v
test_runner
   |
   v
AWS EC2 GitLab Runner
   |
   v
Docker container
   |
   v
echo "Hello from GitLab Runner!"
10. Then make it a real DevOps project

Once the basic test works, I would not stop there.

For your portfolio, build this progression:

                    GitLab
                       |
                       | git push
                       v
                GitLab CI Pipeline
                       |
             +---------+---------+
             |                   |
             v                   v
          Validate              Test
             |                   |
             +---------+---------+
                       |
                       v
                 Docker Build
                       |
                       v
                Docker Image
                       |
                       v
              Amazon ECR
                       |
                       v
                 AWS Deployment

gitlab-runner register  --url https://gitlab.com  --token glrt-nZHLxYzfp0fQCWThJX2DfWM6MQpvOjEKcDoxZm1hZzAKdDozCnU6bzRwaGoc.01.1o0xoy4dv
 The runner authentication token glrt-nZHLxYzfp0fQCWThJX2DfWM6MQpvOjEKcDoxZm1hZzAKdDozCnU6bzRwaGoc.01.1o0xoy4dv  displays here for a short time only. After you register the runner, this token is stored in the config.toml and cannot be accessed again from the UI.

Step 2
Choose an executor when prompted by the command line. Executors run builds in different environments. Not sure which one to select? 

Step 3 (optional)
Manually verify that the runner is available to pick up jobs.

gitlab-runner run

-----------------------------------------------------------------------------------------------------------
Create bucket.

aws s3api put-bucket-versioning \
  --bucket aws-gitlab-terraform-state-12345 \
  --versioning-configuration Status=Enabled



aws s3api create-bucket \
  --bucket aws-gitlab-terraform-state-12345 \
  --region us-east-1

-----------------------------------------------------

No VM guests are running outdated hypervisor (qemu) binaries on this host.
ubuntu@ip-172-31-27-204:~$ aws sts get-caller-identity
{
    "UserId": "AROAXS65HQZDWSPKWBKJS:i-0f00f7a969ac54369",
    "Account": "521765619271",
    "Arn": "arn:aws:sts::521765619271:assumed-role/instanceRole/i-0f00f7a969ac54369"
}

---------------------------------------------------------
Install docker on runner.
--------------------------------------------------------
Create instance role called Instance role with below policy and grant to the runner ec2.

---------------------------------------------------------

Commit changes to code and push to branch. Check in Gitlab>build>pipelines.
-----------------------------------------------------------
Once apply stage is completed, Go to cloud console, loadbalancer, copy the dns, paste in browser.

http://url
eg: http://my-load-balancer-1548099333.us-east-1.elb.amazonaws.com
