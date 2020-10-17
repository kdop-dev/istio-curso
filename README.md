# Istio avançado para iniciantes (The Advanced Istio for Beginners)


## Referências

* [Katacoda - Get Started with Istio and Kubernetes](https://www.katacoda.com/adsantos/courses/istio/deploy-istio-on-kubernetes)
* [Github - asantos2000/katacoda-scenarios](https://github.com/asantos2000/katacoda-scenarios)

## Issues

[Could not get apiVersions from Kubernetes: Unable to retrieve the complete list of server APIs](https://stackoverflow.com/questions/62442679/could-not-get-apiversions-from-kubernetes-unable-to-retrieve-the-complete-list)
Error: UPGRADE FAILED: could not get apiVersions from Kubernetes: unable to retrieve the complete list of server APIs: metrics.k8s.io/v1beta1: the server is currently unable to handle the request

Solution

The steps I followed are:

kubectl get apiservices : If metric-server service is down with the error CrashLoopBackOff try to follow the step 2 otherwise just try to restart the metric-server service using kubectl delete apiservice/"service_name". For me it was v1beta1.metrics.k8s.io .

kubectl get pods -n kube-system and found out that pods like metrics-server, kubernetes-dashboard are down because of the main coreDNS pod was down.

## Gerando carga

Ref: [An Introduction to Load Testing](https://www.digitalocean.com/community/tutorials/an-introduction-to-load-testing#load-testing-basics)

```bash
ab -n 1000 -c 10 http://localhost:8000
```


kubectl apply -n boutique -f exemplos/gcp-microservices-demo/release/kubernetes-manifests.yaml