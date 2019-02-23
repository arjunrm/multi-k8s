# build all the images
docker build -t arjunrm/multi-client:latest -t arjunrm/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t arjunrm/multi-server:latest -t arjunrm/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t arjunrm/multi-worker:latest -t arjunrm/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# push all the images to dockerhub
docker push arjunrm/multi-client:latest
docker push arjunrm/multi-server:latest
docker push arjunrm/multi-worker:latest

docker push arjunrm/multi-client:$SHA
docker push arjunrm/multi-server:$SHA
docker push arjunrm/multi-worker:$SHA

# apply kubernetes configfiles
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=arjunrm/multi-server:$SHA
kubectl set image deployments/client-deployment client=arjunrm/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=arjunrm/multi-worker:$SHA
