# DevOps Challenge Documentation

## Overview

This document outlines the steps taken to address the DevOps challenge presented, including automating deployment processes, containerizing applications, orchestrating containers, and managing infrastructure-as-code.

## Tasks Accomplished

1. **Dockerization of Application (CD-1)**
    - The Python-based `pokemons-service` application was containerized using Docker. 
    - A Dockerfile was created to build an image for the application using the multistage approach to allow the Docker image to be built in stages, ensuring that only the necessary components (like the application binaries and dependencies) are included in the final image. This reduces the image size and potential attack surface.
    - The flask version had to be updated to 2.2.5 as `flask-sqlalchemy 3.1.0 depends on flask>=2.2.5`

2. **Kubernetes Deployment (CD-2)**
    - Designed a StatefulSet for the application to ensure persistent storage and stable network identifiers.
    - Defined Persistent Volume (PV) and Persistent Volume Claim (PVC) to manage storage resources. The PersistentVolumeClaim ensures that the SQLite database persists data even if the pod restarts.
    - Configured resource limits to optimize and safeguard the Kubernetes environment.
    - Defined kubernetes service.
    - Before deploying the application to your kubernetes cluster first generate a secret with your dockerhub account details (for security purposes this wasn't commited to the repository).
        - To create the secret:
            ```
            kubectl create secret docker-registry dockerhub-credentials \
            --docker-server=https://index.docker.io/v1/ \
            --docker-username=DOCKERHUB_USERNAME \
            --docker-password=DOCKERHUB_PASSWORD \
            --docker-email=DOCKERHUB_EMAIL
            ```
    - Deploy the init container configmap that initialises the database:
            ```
            kubectl apply -f kubernetes/configmap.yaml
            ```
3. **Continuous Integration and Deployment (CD-3)**
    - Implemented a GitHub Actions workflow for CI/CD.
    - The workflow checksout the code, then runs the tests under the tests folder using an in memory database, builds the Docker image, tags it with the commit SHA for traceability, pushes it to Docker Hub, updates the Kubernetes manifest with the new image tag, and deploys it to a Kubernetes cluster.

4. **Infrastructure-as-Code with Terraform (CD-4)**
    - Created Terraform configurations to manage Azure resources, following IAM requirements.
    - Defined Azure AD application, service principal, role definition, group, and user resources.
    - Organized Terraform configurations modularly into `main.tf`, `variables.tf`, and `providers.tf`.

## Application Modifications

1. **Database Initialization with an Init Container**:
    - Modification: Used an init container in the Kubernetes StatefulSet to handle the initialization of the SQLite database.
    - Reason: An init container ensures that certain prerequisites (like database initialization) are met before the main application container starts. This decouples the application logic from the database setup.

2. **Database Auto-increment**:
    - Modification: Updated the SQLite database schema to make the id column in the pokemons table auto-increment. Adjusted application logic and init script accordingly.
    - Reason: This allows the database to automatically assign a unique ID to each new entry, ensuring consistency and avoiding manual ID management.

3. **Configuration File Update**:
    - Modification: Updated config.py to set the SQLite database path to the mounted volume in the Kubernetes pod.
    - Reason: This change ensures that the application reads/writes data from/to the persistent volume, allowing data to survive pod restarts.

## Rationale Behind Each Step

1. **Dockerization**: Containerizing the application ensures a consistent environment from development to production, simplifies dependency management, and facilitates scalability and portability.

2. **Kubernetes Deployment**: Kubernetes offers automated deployment, scaling, and management of containerized applications. Using a StatefulSet guarantees the order and uniqueness of pod deployment, which is beneficial for applications that require stable network identifiers or persistent storage.

3. **CI/CD**: Automating the build and deployment process reduces manual errors, ensures code quality, accelerates release cycles, and ensures that every code change is traceable and deployable.

4. **Terraform**: Managing infrastructure-as-code with Terraform allows for consistent, reproducible, and scalable infrastructure deployments. It also enables version control of infrastructure, collaboration, and automation.

## Instructions to Run Locally

1. **Install and Start Minikube**:
    - Install minikube by following this instructions based on your OS: https://minikube.sigs.k8s.io/docs/start/
    - Start Minikube 
        ```
        minikube start
        ```

2. **Use Minikube's Docker Daemon**:
    - Set your terminal to use Minikube's Docker daemon instead of the default:
        ```
        eval $(minikube docker-env)
        ```
    - Note: if you don't have minikube you can create a local registry and push your image there like this:
        ```
        docker run -d -p 5002:5000 --name registry registry:2
        docker build -t pokemons-service:latest .
        docker tag pokemons-service:latest localhost:5002/pokemons-service:latest
        docker push localhost:5002/pokemons-service:latest
        ```
3. **Docker**:
    ```
        docker build -t pokemons-service:latest .
    ```
4. **Kubernetes**:
    - Update Kubernetes Manifests: In your Kubernetes manifests (StatefulSet), you can reference the image just by its name and tag, without needing to pull from a remote registry:
        ```
        spec:
        containers:
        - name: pokemons-service
            image: pokemons-service:latest
        ```
    - Apply the kubernetes manifests:
        ```
            kubectl apply -f kubernetes/service.yaml
            kubectl apply -f kubernetes/configmap.yaml
            kubectl apply -f kubernetes/statefulset.yaml
        ```

5. **GitHub Actions CI/CD**: 
    - Save the provided GitHub Actions workflow to `.github/workflows/ci-cd.yml` in your repository.
    - Store necessary secrets (`DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`) in the GitHub repository's secrets settings.
    - Push changes to the `main` branch to trigger the workflow.
         - Note: It's possible to test the github actions pipeline locally using the following: https://github.com/nektos/act

6. **Terraform**:
    - Generate a .tfvars file with your variables values
    - Initialize the Terraform directory:
        ```bash
        cd terraform
        terraform init
        ```
    - Plan the Terraform configuration:
        ```bash
        terraform plan -var-file="values.tfvars"
        ```
    - Apply the Terraform configuration:
        ```bash
        terraform apply -var-file="values.tfvars"
        ```

---

## Pokemons API

This is an application to store and get information about Pokemons.

## How can get Pokemons

Using this url
https://localhost/pokemons

## How to store new Pokemons

```
curl -X POST -H "Content-Type: application/json" -d '{"name":"Squirtle","type":"Water"}' http://localhost:5000/pokemons
```
Of course! Here's a detailed markdown document summarizing the tasks we accomplished, the reasoning behind each step, and instructions on how to run everything:

---
