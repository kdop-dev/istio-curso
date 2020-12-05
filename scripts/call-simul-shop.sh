#!/bin/bash

while true
do
## Sem modificar o /etc/hosts
#curl -v --header "Host: simul-shop.com" http://localhost/s
#curl -v -H "Host: www.simul-shop.com" --resolve "www.simul-shop.com:80:127.0.0.2" http://www.simul-shop.com/s
## Resolvendo pelo /etc/hosts
curl -v http://simul-shop.com/s
echo
sleep 1
done