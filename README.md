# docker apache php file write directory docker-compose


Basic image php + apache + write to file, working, because `chown` permissions corrected.
is owned by root. 

```
./build-and-run.sh
```

visit http://127.0.0.1:8081


Bash history, keep checking `ps` and `ls -l` to validate 
ownership is correct

```
(base) (master)$ docker ps
CONTAINER ID   IMAGE                 COMMAND                  CREATED          STATUS                PORTS                                   NAMES
47c31ea21c14   test                  "docker-php-entrypoi…"   10 seconds ago   Up 9 seconds          0.0.0.0:8081->80/tcp, :::8081->80/tcp   nice_aryabhata
3783854192c5   mysql:5.6.49          "docker-entrypoint.s…"   2 weeks ago      Up 3 days             3306/tcp                                ground2control-prod-repo-clean_db_1
c539f36394dd   postgres:9.5-alpine   "docker-entrypoint.s…"   12 months ago    Up 3 days (healthy)   5432/tcp                                interview-accountapi_postgresql_1
(base) (master)$ docker exec -it 47c31ea21c14 bahs
OCI runtime exec failed: exec failed: container_linux.go:380: starting container process caused: exec: "bahs": executable file not found in $PATH: unknown
(base) (master)$ docker exec -it 47c31ea21c14 bash
root@47c31ea21c14:/var/www/html# ls
index.php  uploads
root@47c31ea21c14:/var/www/html# ls -l
total 8
-rw-rw-r-- 1 root     root      165 Oct 26 22:15 index.php
drwxr-xr-x 1 www-data www-data 4096 Oct 26 22:21 uploads
root@47c31ea21c14:/var/www/html#  
```
