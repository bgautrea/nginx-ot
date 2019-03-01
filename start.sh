#!/bin/bash

docker network create --subnet 10.10.220.0/24 TenNet

docker run -d --network TenNet --name upstream1 --hostname upstream1 nginx-plus

docker run -d --network TenNet --name upstream2 --hostname upstream2 nginx-plus

docker run -d -p 80:80 -p 443:443 -p 8080:8080 --network TenNet --name nginx-plus --hostname nginx-plus nginx-plus

docker cp hello/. upstream1:/etc/nginx/
     
docker cp hello/. upstream2:/etc/nginx/
     
docker exec -ti upstream1 rm /etc/nginx/conf.d/default.conf
      
docker exec -ti upstream2 rm /etc/nginx/conf.d/default.conf
     
docker cp nginx.conf nginx-plus:/etc/nginx/nginx.conf

docker exec -ti nginx-plus yum -y install nginx-plus-module-opentracing

docker exec -ti upstream1 yum -y install nginx-plus-module-opentracing
     
docker exec -ti upstream2 yum -y install nginx-plus-module-opentracing

docker run -d --network TenNet --name jaeger -p 16686:16686 jaegertracing/all-in-one:1.10 
   
docker cp jaeger.json nginx-plus:/etc/jaeger.json
     
docker cp jaeger.json upstream1:/etc/jaeger.json
     
docker cp jaeger.json upstream2:/etc/jaeger.json

docker exec -ti upstream1 sed -ei s/nginx/nginx-upstream/ /etc/jaeger.json
     
docker exec -ti upstream2 sed -ei s/nginx/nginx-upstream/ /etc/jaeger.json
     
docker cp lib64/ nginx-plus:/usr/local/
     
docker cp lib64/ upstream1:/usr/local/
     
docker cp lib64/ upstream2:/usr/local/

docker exec -ti upstream1 nginx -s reload

docker exec -ti upstream2 nginx -s reload

docker exec -ti nginx-plus nginx -s reload


