#!/bin/bash

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export TCP_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')

while true
do
curl -v -H "Host: www.simul-shop.com" \
    --resolve "www.simul-shop.com:$SECURE_INGRESS_PORT:$INGRESS_HOST" \
    --cacert exemplos/simul-shop/certs/all.simul-shop.com.crt "https://www.simul-shop.com:$SECURE_INGRESS_PORT/s"
echo
sleep 1
done

# TODO: Configurar certificado para reconhecer simul-shop.com
# while true
# do
# curl -v -H "Host: simul-shop.com" \
#     --resolve "simul-shop.com:$SECURE_INGRESS_PORT:$INGRESS_HOST" \
#     --cacert exemplos/simul-shop/certs/all.simul-shop.com.crt "https://simul-shop.com:$SECURE_INGRESS_PORT/s"
# echo
# sleep 1
# done