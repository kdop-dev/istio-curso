#!/bin/bash

SECURE_INGRESS_PORT=443
INGRESS_HOST=localhost

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