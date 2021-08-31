Install Rancher, configure a load balancer, install and configure helm, install cert-manager, configure Rancher, walk through the GUI, scale up our cluster, and set up a health check and liveness check! Join me, it’s easy in this straightforward guide.

Watch Video
install

Note: It’s advised you consult the Rancher Support Matrix to get the recommended version for all Rancher dependencies.

https://rancher.com/docs/rancher/v2.x/en/installation/install-rancher-on-k8s/#1-install-the-required-cli-tools

kubectl

#install helm

</pre></td><td class="rouge-code"><pre>curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
</pre></td></tr></tbody>

add helm repo, stable

</pre></td><td class="rouge-code"><pre>helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
</pre></td></tr>

create rancher namespace

</pre></td><td class="rouge-code"><pre> kubectl create namespace cattle-system
</pre></td></tr>

ssl configuration

user rancher generated (default)

install cert-manager

	

</pre></td><td class="rouge-code"><pre> kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.2.0/cert-manager.crds.yaml
</pre></td></tr>

create name-space for cert-manager

	
</pre></td><td class="rouge-code"><pre> kubectl create namespace cert-manager</pre></td></tr>


Add the Jetstack Helm repository


</pre></td><td class="rouge-code"><pre>  helm repo add jetstack https://charts.jetstack.io </pre></td></tr>

update helm repo

</pre></td><td class="rouge-code"><pre> helm repo update</pre></td></tr>


install cert-manager helm chart

*Note: If you receive an “Error: Kubernetes cluster unreachable” message when installing cert-manager, try copying

the contents of “/etc/rancher/k3s/k3s.yaml” to “~/.kube/config” to resolve the issue.*

1
2
3
4

	

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.2.0

check rollout of cert-manager

1

	

kubectl get pods --namespace cert-manager

Be sure each pod is fully running before proceeding

Install Rancher with Helm

Note:If you have “.local” for your private TLD then Rancher will NOT finish the setup within the webUI

1
2
3

	

helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.example.com

check rollout

1

	

kubectl -n cattle-system rollout status deploy/rancher

you should see

1
2
3
4

	

Waiting for deployment "rancher" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "rancher" rollout to finish: 1 of 3 updated replicas are available...
Waiting for deployment "rancher" rollout to finish: 2 of 3 updated replicas are available...
deployment "rancher" successfully rolled out

check status

1

	

kubectl -n cattle-system rollout status deploy/rancher

you should see

1

	

deployment "rancher" successfully rolled out

load balancer

If you are using k3s you can use the traefik ingress controller that ships with k3s

run

1

	

kubectl get svc --all-namespaces -o wide

look for

1

	

kube-system     traefik                LoadBalancer   10.43.202.72   192.168.100.10   80:32003/TCP,443:32532/TCP   5d23h   app=traefik,release=traefik

then create a DNS entry for rancher.example.com 192.168.100.10

This can be a host entry on your machine, or a DNS entry in your local DNS system (router, pi hole, etc…)

otherwise you can use nginx

nginx lb

https://rancher.com/docs/rancher/v2.x/en/installation/resources/k8s-tutorials/infrastructure-tutorials/nginx/
other considerations

Separating Rancher Cluster from your User Cluster

https://rancher.com/docs/rancher/v2.x/en/overview/architecture-recommendations/#separation-of-rancher-and-user-clusters
