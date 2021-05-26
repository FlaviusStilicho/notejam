### About the implementation
I have decided top use the Spring Boot version of notejam - this is the framework I am most familiar with. The most important architectural decisions I have made are:
* I swapped the hsqldb with a dockerized MySQL database.
* I used the maven jib plugin to easily dockerize the application
* I deploy the application to AWS EKS. I use terraform to construct resources such as a vpc, the EKS cluster, and an AWS RDS MySQL instance. I deploy the app using Helm. I expose the app with a standard load balancer service, no route53 domain because I am cheap :)
* I added Spring actuator for metrics, e.g. <domain>:<port>/health or <domain>:<port>/metrics

####Building the app:
#####Requirements:
* Java 8+
* A public container repo account (I use Docker Hub), in order to build the app directly into a docker image
* Maven (with your docker repo credentials configured)
    
#####Steps:
1. In the pom.xml file, change the repo and image name (<image>registry.hub.docker.com/alexbakker/notejam-alex</image>) to your own choice
2. From the <project rootroot>\spring dir, run "mvn clean compile jib:build". The container will be uploaded to your image repo immediately.
    
####Deploying the app to a local k8s cluster:
#####Requirements:
* A local k8s cluster (for example, with Docker Desktop on windows)
* Kubectl (with pre-configured config for the local cluster)
* Your docker image, see above

#####Steps:
0. Change the image name in the deployment to your image name
1. After having built the image, run "kubectl apply -f <project root>\k8s\localdev". I have not yet added logic to make the app await the creation of the database, so you could also deploy the db first, then the app.
2. The app will be available on http://localhost:30001/

####Deploying the app to AWS:
#####Requirements:
* An AWS account
* AWS cli installed and configured with credentials for your account (and an IAM role, unless you use the root account)
* Terraform installed, version <14.0.0 (13.7.0 recommended) - the modules I use to create the VPC and EKS cluster are version limited 
* Helm installed
        
#####Steps:
0. Change the image name in the helm chart to your image name
1. First, create the VPC and EKS cluster:
    * Go to <project root>\terraform\modules\aws-vpc-eks-cluster
    * In case you are *not* running on windows, go to eks.tf and delete the line "wait_for_cluster_interpreter = ["C:/Program Files/Git/bin/sh.exe", "-c"]"
    * Run "terraform init"
    * Run "terraform apply --var-file=variables_dev.tfvars "
    * Run "terraform destroy --var-file="variables_dev.tfvars" " to tear down your deployment afterwards.
        * I have not yet implemented a storage location for the terraform state, though I would eventually. For now, I save the state file locally. Don't delete it until after teardown!  
2. Deploy the RDS MySQL database: 
    *  go to <project root>\terraform\modules\aws-rds-mysql
    * run "terraform init"
    * run "terraform apply --var-file="variables_dev.tfvars" "
    * run "terraform destroy --var-file="variables_dev.tfvars" " to tear down your deployment afterwards.
3. Deploy the app:
    * Go to <project root>\k8s\notejam
    * find the endpoint of the RDS database and paste it in values.yaml under db.url (I would eventually use an initcontainer to fetch the endpoint programatically)
    * Run "aws eks update-kubeconfig --name k8s-dev" to configure your kubectl to the new EKS cluster
    * Run "helm install notejam notejam"
    * Run "kubectl get service notejam". The app will be available under <elb endpoint>/signin.
    * Run "helm uninstall notejam" to tear down your deployment afterwards.
    
#####Future improvements:
In reality, this application is not production ready. See below an (inexhaustive) list of features that would be needed to get the application production ready:
- a proper deployment pipeline
- add a proper load balancer, ingress and domain name
- ssl (both on the load balancer and the database)
- waf
- add a liveness/readiness probe to the application pod
- making the application multi-regional (for example, by replication either the database itself or its backup to another region)
- sending application logs to a logging solution such as splunk or CloudWatch. I was looking at using Fluent Bit.
- using some sort of mail solution, perhaps AWS SES, to send emails.
- gathering metrics using prometheus, perhaps also adding custom metrics with micrometer
- alerting / monitoring on logs and metrics
- ...