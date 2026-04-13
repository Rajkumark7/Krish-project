docker build -t react-app .
docker run -d -p 80:80 react-app

----------------------------------------------------------------------------------------------------
🖥️ EC2-1 → Jenkins Server

Purpose:

Runs Jenkins
Builds Docker image
Pushes to Docker Hub
Triggers deployment

#Docker install
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu

#Jenkins setup
sudo apt install openjdk-11-jdk -y
sudo apt install jenkins -y

 #Jenkins Access
 http://<IP>:8080        

 S1: Install plugins
    Git plugin
    Docker Pipeline plugin

 S2: Create Jenkins Pipeline Job
    New Item → Pipeline → Create

    Configure:
    Pipeline Definition: Select -> Pipeline script from SCM
    SCM: Git
    Repo URL: 
    Branch: 

 S3: Add credentials in Jenkins
  1. Docker Hub credentials
    username
    password

       Manage Jenkins → Credentials
       (Global) → Add Credentials
       Kind: Username with password
       username: rajkumartst
       password:
       ID: docker-hub-creds


 2. SSH key (VERY IMPORTANT)
        ssh ubuntu@EC2-2  
    Add in Jenkins:
        Credentials → SSH Username with private key
        ID: ec2-ssh-key

        Manage Jenkins → Credentials → Global → Add Credentials
         kind: SSH Username with private key
         username: ubuntu
         private key: paste
         Id: ec2-ssh-key    

 S4: Trigger pipeline

    click “Build Now” manually OR use webhook/polling later   


    ACCESS YOUR APP -> http://<IP>   

    For Monitoring
     docker run -d -p 3001:3001 --name uptime-kuma louislam/uptime-kuma  
     http://<server-ip>:3001

----------------------------------------------------------------------------------------------------

SG (Jenkins)

| Port | Source     | Purpose                      |
| ---- | ---------- | ---------------------------- |
| 22   | YOUR_IP/32 | Only you can SSH             |
| 8080 | 0.0.0.0/0  | Anyone can access Jenkins UI |


SG (App)

| Port | Source      | Purpose            |
| ---- | ----------- | ------------------ |
| 22   | YOUR_IP/32  | You can SSH        |
| 22   | EC2-1-IP/32 | Jenkins can deploy |
| 80   | 0.0.0.0/0   | Public app access  |


































🖥️ EC2-2 → App Server

Purpose:
Runs your Docker container
Hosts your React app

#Docker install
sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu

------------------------------------
🖥️ EC2-1 → Jenkins Server

Used for:

Running Jenkins
Running pipeline
Building Docker images
Pushing to Docker Hub
🖥️ EC2-2 → App Server (Production)

Used for:

Running your final Docker container
Hosting your React app
--------------------

GH configuration

http://<JENKINS_PUBLIC_IP>:8080/github-webhook/