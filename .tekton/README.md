## Run the pipeline

### Instructions for mac.


1. Download/install minikuke:
   -  You'll need Docker: https://docs.docker.com/desktop/install/mac-install/ 
   -  https://minikube.sigs.k8s.io/docs/start/

2. start minikube: `minikube start`

3. Download tekton:
   - pipelines: `kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml`
   - triggers:
```kubectl apply --filename \
https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml

kubectl apply --filename \
https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml
```
   - github status task: `kubectl apply -f https://api.hub.tekton.dev/v1/resource/tekton/task/github-set-status/0.4/raw`

3a: verify the installation: `kubectl get pods --namespace tekton-pipelines --watch`

4: install ngrok to easily expose your pipline pods to the internet: `brew install ngrok/ngrok/ngrok`

5. run ngrok: `ngrok http 8080`. leave this window open.

6: Add the webhook: Take the `Forwarding url` from the ngrok terminal window above (something like `https://b0dc-0x-42-42-42.ngrok.io`) and add it to github -> settings -> webooks -> add webhook. 
Additional fields:
   - Secret: `1234567` (matches the secret.yaml file).
   - Events: Only check pull request for now.
   - Type: json

A successful delivery header from Github will look like:
```
Request URL: https://0269-68-193-137-109.ngrok.io
Request method: POST
Accept: */*
content-type: application/json
User-Agent: GitHub-Hookshot/5473b54
X-GitHub-Delivery: 5a38e970-bd61-11ed-9c6e-7298a114e0ce
X-GitHub-Event: pull_request
X-GitHub-Hook-ID: 404051636
X-GitHub-Hook-Installation-Target-ID: 609247654
X-GitHub-Hook-Installation-Target-Type: repository
X-Hub-Signature: sha1=c22332454d089c47637e37f90d7667462eca30c7
X-Hub-Signature-256: sha256=9422cc65f04a5c2bd155da90c9099c468b6b540333307bdd8b578644e4645641
```

7. Create the namespace `kubectl create namespace tekton-awl`

8. Run: `kubectl -n tekton-awl apply -f .`

9. Enable port forwarding, this will forward external web traffic to your listener service `kubectl port-forward service/el-github-listener 8080`

9a: Run the `curl.sh` script to test out the pipeline locally. You should get a `202 Accepted` response if all is well.

10. Create a kubectl secret with the api key: `kubectl create secret generic github --from-literal=GITHUB_TOKEN=<access-token>`. This is for the github status reporting.

11. That should be it - try it out by opening a PR to this repo and see what isn't working (ie - what I missed) :) 

## Run the tekton dashboard

1. Download/install the dashboard: `kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml`
1a. Verify the pod is running: `kubectl get pods --namespace tekton-pipelines --watch`

2. Enable port forwarding: `kubectl port-forward -n tekton-pipelines service/tekton-dashboard 9097:9097`
3. Access the dashboard in your favorite web browser: `http://localhost:9097`



