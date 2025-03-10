# ecs-webapp
A basic webapp which accepts a URL with an ethereum wallet address, and returns the balance

![nginx reverse proxy hosted in ECS](https://github.com/user-attachments/assets/335f75a1-b583-40fe-88ba-e05f145a3245)

## Design
This webapp is encapsulated in 2 docker containers: frontend and backend, described below.  Once the containers are published to a public container repository, the included terraform code allows for deployment into AWS ECS, along with some tweakable variables.

### Backend
A simple nodeJS webapp exposing one API endpoint, bassed on the official node alpine image, includes additoinal node packages below.  Accepts 2 params and passes them to a remote API (**eth_getBalance**, hosted at infura.io [requires API Key]).  Included libraries:
Axios -  for sending remote HTTP requests
cors - for handling safe cross-origin resource sharing (cors) should it be necessary
express - for JSON parsing 

### Frontend
Even simpler frontend consisting of a single index.html (HTML, CSS, and JavaScript), based on the official nginx alpine image, which accepts user input (URL containing an ehthereum wallet address in the form of `0x[0-9a-fA-F]{40}`, as expressed via REGEX match).

## Containerization
Tested locally and then built into containers using the public images as a base.  Included in this repo is a Dockerfile for the 2 respective containers, and a docker-compose.yml are included for quick container builds.  Compiled containers were intended to be lightweight, and with included libraries, came out to the following size:
1. Frontend - 48 MB
2. Backend - 138 MB

## AWS Elastic Container Service (ECS)
These containers were uploaded to the ECS registry, which were then referenced in an ECS task definition, run as a ECS service in an ECS cluster.  Fargate serverless instances were utilized as a cost-concious way to optimize the potential scaling.  These containers are intended to be lightweight and with AWS now offering Fargate as an alternative to EC2 instances, further optimizations could be leveraged, not least of which the EC2 instance management complexity.

Workflow for this project can be expressed in this diagram 

![workflow](https://github.com/user-attachments/assets/acf05230-df30-4f6d-b877-bc32906b8947)


