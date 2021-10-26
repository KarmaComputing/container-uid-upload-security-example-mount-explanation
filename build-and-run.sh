#! /bin/bash

docker build -t test .

docker kill test

docker run -p 8081:80 test
