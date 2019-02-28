# nginx-ot
nginx config with opentracing

demo of nginx plus with opentracing - all docker containers


Run NGINX Plus container in a custom docker network.
`docker network create --subnet 10.10.220.0/24 TenNet`   
`docker run -d -p 80:80 -p 443:443 -p 8080:8080 --network TenNet --name nginx-plus nginx-plus`
`docker cp nginx.conf nginx-plus:/etc/nginx/nginx.conf`
   
Install NGINX Plus OpenTracing module on N+ Container
   `docker exec -ti nginx-plus yum -y install nginx-plus-module-opentracing`

run the jaegertracing/all-in-one:1.10 with the name jaeger
   `docker run -d --network TenNet --name jaeger jaegertracing/all-in-one:1.10 `
   
Copy the jaeger.json to /etc/
   `docker cp jaeger.json nginx-plus:/etc/jaeger.json`
   
Copy the lib64/* to /usr/local/lib64
   `docker cp lib64/ nginx-plus:/usr/local/`

reload nginx
   `docker exec -ti nginx-plus nginx -t`
   `docker exec -ti nginx-plus nginx -s reload`


