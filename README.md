<<<<<<<<<<<<<Prerequisits>>>>>>>>>>>>>>>>>>
--------------------
Git
Docker
AWS CLI
Terraform Kubectl
--------------------
|AWS Configure|

Once after clone,
    npm install
    npm start
    node server.js
    node app.js
    open http://localhost:3000
<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>

-----------------------------------------------------------------
STEP 1: Dockerizing the app

After Dockerfile:
 ##Build image
 docker build -t trend-app .  

 ##Run container  
 docker run -p 3000:3000 trend-app 

 ##Test
 http://localhost:3000

------------------------------------------------------------------
 STEP 2: Push Image to DockerHub (Later AWS pull image from DockerHub)
 docker login
 docker tag trend-app your-dockerhub-username/trend-app:v1
 docker push your-dockerhub-username/trend-app:v1

------------------------------------------------------------------
 STEP 3: Create AWS Infrastructure using Terraform
  mkdir terraform && cd terraform
   VPC, EC2(Jenkins), IAM roles, EKS

-----------------------------------------------------------------------
 STEP 4: Configure Kubernetes (EKS)
 Connect to cluster: 
 aws eks update-kubeconfig --name trend-eks --region us-east-1  
 kubectl get nodes
 kubectl apply -f deployment.yaml
 kubectl apply -f service.yaml
 kubectl get svc (shouls ee EXTERNAL-IP → http link) --> open in browser

-----------------------------------------------------------------------------
 STEP 5: Install Jenkins on EC2
 sudo apt update
 sudo apt install openjdk-17-jdk -y

 curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
 /usr/share/keyrings/jenkins-keyring.asc > /dev/null

 echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
 https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
 /etc/apt/sources.list.d/jenkins.list > /dev/null

 sudo apt update
 sudo apt install jenkins -y
 sudo systemctl start jenkins

 Open http://<EC2-IP>:8080

------------------------------------------------------------------------------
 STEP 6:Jenkins Plugins to Install

    Install:
    Git plugin
    Docker plugin
    Pipeline plugin
    Kubernetes CLI plugin

--------------------------------------------------------------------------------
 STEP 7: Create Jenkins CI/CD Pipeline   

-------------------------------------------------------------------------------
 STEP 8: GitHub Webhook (Auto Deploy)
 In GitHub:
   Repo → Settings → Webhooks:
      http://<jenkins-ip>:8080/github-webhook/
      Trigger: Push events

-------------------------------------------------------------------------------
 STEP 9: Monitoring Setup
 Install monitoring stack on EKS:

    Install Prometheus + Grafana
    kubectl create namespace monitoring
    helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring     

    Access Grafana: kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
                    http://localhost:3000
    Login: admin / prom-operator

    Alias: https://your-loadbalancer.amazonaws.com