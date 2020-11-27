#!/bin/bash

export SOURCE_POD=$(kubectl get pod -l app=sleep -o jsonpath={.items..metadata.name})

while true                                                            
do
kubectl exec "$SOURCE_POD" -c sleep -- curl -sL -D - http://credit.financial/
echo
sleep 1
done