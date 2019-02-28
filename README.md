# nginx-ot
nginx config with opentracing

demo of nginx plus with opentracing - all docker containers. THis will use a custom docker network for name resolution.

`docker network create --subnet 10.10.220.0/24 TenNet`   

Run NGINX Plus containers for backend application and proxy.

     `docker run -d --network TenNet --name upstream1 --hostname upstream1 nginx-plus`

     `docker run -d --network TenNet --name upstream2 --hostanme upstream2 nginx-plus`

     `docker run -d -p 80:80 -p 443:443 -p 8080:8080 --network TenNet --name nginx-plus --hostname nginx-plus nginx-plus`

     `docker cp hello/* upstream1:/etc/nginx/`
     
     `docker cp hello/* upstream2:/etc/nginx/`
     
     `docker cp nginx.conf nginx-plus:/etc/nginx/nginx.conf`


Install NGINX Plus OpenTracing module on N+ Containers

     `docker exec -ti nginx-plus yum -y install nginx-plus-module-opentracing`

     `docker exec -ti upstream1 yum -y install nginx-plus-module-opentracing`
     
     `docker exec -ti upstream2 yum -y install nginx-plus-module-opentracing`

run the jaegertracing/all-in-one:1.10 with the name jaeger

     `docker run -d --network TenNet --name jaeger jaegertracing/all-in-one:1.10 `
   

Copy the jaeger.json to /etc/

     `docker cp jaeger.json nginx-plus:/etc/jaeger.json`
     
     `docker cp jaeger.json upstream1:/etc/jaeger.json`
     
     `docker cp jaeger.json upstream2:/etc/jaeger.json`
     
Copy the lib64/* to /usr/local/lib64

     `docker cp lib64/ nginx-plus:/usr/local/`
     
     `docker cp lib64/ upstream1:/usr/local/`
     
     `docker cp lib64/ upstream2:/usr/local/`


reload nginx

     `docker exec -ti upstream1 nginx -s reload`

     `docker exec -ti upstream2 nginx -s reload`

     `docker exec -ti nginx-plus nginx -s reload`


