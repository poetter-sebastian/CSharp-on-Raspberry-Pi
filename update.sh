#!/bin/bash
cd /home/pi/Projects/docker/program/
git fetch
if git status | grep -q "behind"; then
	git pull
	dotnet build --configuration Release
	cd ..
	#docker rm $(docker stop $(docker ps -a -q --filter ancestor=program:1.0 --format="{{.ID}}"))
	docker build --tag program/:1.0 .
	docker container run program:1.0
fi
