## Run the pipeline

### Instructions for mac.


1. Download/install minikuke:
   -  You'll need Docker: https://docs.docker.com/desktop/install/mac-install/ 
   -  https://minikube.sigs.k8s.io/docs/start/

2. start minikube: `minikuke start`

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

6: Add the webhook: Take the `Forwarding url` from the ngrok terminal window above (something like `https://b0dc-0x-42-42-42.ngrok.io`) and add it to settings -> webooks -> add webhook For a free version of ngrok, this link expires in 2 hours, at which point you will have to restart and edit the webook to use the new link. You can see the webhook is working if you see a successful read/write in the recent deliveries tab under your link.

7. Create the namespace `kubectl create namespace tekton-awl`

8. Run: `kubectl -n tekton-awl apply -f .`

9. Enable port forwarding, this will forward external web traffic to your listener service `kubectl port-forward service/el-github-listener 8080`

9a: Run the `curl.sh` script to test out the pipeline locally. You should get a `202 Accepted` response if all is well.

10. Create a kubectl secret with the api key: `kubectl create secret generic github --from-literal=GITHUB_TOKEN=<access-token>`

11. That should be it - try it out by opening a PR to this repo and see what isn't working. :) 

## Run the tekton dashboard

1. Download/install the dashboard: `kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml`
1a. Verify the pod is running: `kubectl get pods --namespace tekton-pipelines --watch`
2. Access the dashboard in your favorite web browser: http://localhost:8001/api/v1/namespaces/tekton-pipelines/services/tekton-dashboard:http/proxy/#/about



