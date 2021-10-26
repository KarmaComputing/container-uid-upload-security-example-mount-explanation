# docker apache php file write directory docker-compose

> Please check **all** commits on this repo, every one is a step-by-step improvement to explain each stage.


Basic image php + apache + write to file, working, with mounted uploads directory, note the difference is:

1. create uploads directory on your **host** machine (outside the container)
2. mkdir uploads; # See it's in the .gitignore file (we don't want to store user data in a repo, nor in a container
3. Change the ownership of your **host** folder called `uploads` to the same user `id` of the user in the container
   for this example, the user is www-data, and that user's id is `33`. How to find out? exec inside the container and
   type `id www-data` , it will tell you the user id.
3. Run the container with the mount: `docker run -v $PWD/uploads:/var/www/html/uploads -p 8081:80 test`
   now the index.php script will be able to write to your local 'uploads' folder http://127.0.0.1:8081

In summary: `chown` your local `uploads` directory on your local machine to the same id as the id used in the container.

Why is there for docker-compose.yml? It's the same settings as `docker run` just in yaml, Pull requests welcome :) 


# Explanation

- Decide to store uploaded filed outside the container in a folder on the host
- This creates a challange because ownership permissions are not in sync
  - To be exact, the user namespace (user id) of the process running 'in the container' is different
    from the host, so when the process tries to write to the files, the owner `id` is the host machine,
    not the container's process id owner.
- There's no such thing as a process running 'in a container' really, it's running on the host, within a namespace,
  so it's seperated
- ? Security question: So does this mean that if my roo user `id` is `33` and my container has a user which also has the
   user `id` `33`, can the container read the root filesystem? yes. 🎃.  If by mistake, a user id in a container is the same as a real user id on the host, it can be big trouble. 
   
   This is why some container ecosystems (e.g. Openshift eforce containers always have a user id > greater than 10000, (and random) to reduce the risk of the user id used in a container is never the same id as a user on the host machine.  


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
