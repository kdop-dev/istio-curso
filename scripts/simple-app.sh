for i in $(seq 1 100);
do kubectl exec svc/simple-app -c simple-app -- curl simple-app:80;
done