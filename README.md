STEP 1: Dockerize
# Build Image:
docker build -t brain-app .

# Run Container:
docker run -p 3000:80 brain-app

# Access: 
http://localhost:300    

----------------------------------------------
STEP 2: DockerHub PUSH
# Create Docker Hub Account:

# Login from Terminal:
docker login
  Enter: Username/Password

# Tag Image for Docker Hub
docker tag <local-image> <dockerhub-username>/<repo-name>:tag
eg: docker tag brain-app john123/brain-app:latest

# Push to Docker Hub
docker push john123/brain-app:latest

# Accessible
john123/brain-app:latest

-----------------------------------------------
STEP 3: Setup Kubernetes (EKS)
# create EKS cluster
eksctl create cluster \
--name brain-cluster \
--region us-east-1 \
--nodegroup-name brain-nodes \
--node-type t2.micro \
--nodes 2

# Connect kubectl to EKS
aws eks --region us-east-1 update-kubeconfig --name brain-

# Verify Cluster
kubectl get nodes

-----------------------------------------------
STEP 4: Deploy to EKS
# Create deployment.yaml and service.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get svc
check for EXTERNAL-IP

-----------------------------------------------
STEP 5: ENABLE CODEBUILD LOGS (Logs are automatically enabled by default)
# Create CodeBuild Project  (under source provider, choose GitHub)
  AWS Console → CodeBuild → Create Project

# Configure Logging
  Logs Section
    CloudWatch Logs → Enabled
    Group name → auto or custom
    Stream name → auto  

# Enable Privileged Mode
  Enable: Privileged (without this Docker build will FAIL)    

# Run Build
  Start Build

# View logs
  CodeBuild → Your Project → Build → Logs  
  CloudWatch → Logs → Log groups

# CodeBuild Role
  AWS Console → CodeBuild → Your Project
  search Service Role: codebuild-brain-service-role

# Attach permissions
  IAM → Roles → that role
    AmazonEKSClusterPolicy
    AmazonEKSWorkerNodePolicy
    AmazonEC2ContainerRegistryReadOnly (optional) 

# Add locally
  kubectl edit configmap aws-auth -n kube-system
  -----------------------------------------------------------
  mapRoles:
  - rolearn: arn:aws:iam::<ACCOUNT_ID>:role/codebuild-role
    username: codebuild
    groups:
      - system:masters
  ------------------------------------------------------------      


# Automating trigger
Step 1: Create CodePipeline
    AWS Console → CodePipeline → Create Pipeline (brain-app-pipeline)

Step 2: Source Stage
    Choose:
        Source provider: GitHub
        Connect your repo     
    Enable: Detect changes (Webhooks)

Step 3: Build Stage
    Provider: CodeBuild
    Select your existing CodeBuild project
    (This will run buildspec.yml)




