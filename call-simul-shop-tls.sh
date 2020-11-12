SECURE_INGRESS_PORT=443
$INGRESS_HOST=localhost

while true
do
curl -v -HHost:www.simul-shop.com --resolve "www.simul-shop.com:$SECURE_INGRESS_PORT:$INGRESS_HOST" --cacert simul-shop.com.crt "https://www.simul-shop.com:$SECURE_INGRESS_PORT/s"
echo
sleep 1
done