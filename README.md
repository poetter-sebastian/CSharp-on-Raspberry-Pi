## Docker
Docker is a containerisation technology that makes it possible to achieve lightweight virtualisation. In contrast to VMs, Docker containers do not use hardware emulation, but isolate applications by means of [namespaces](https://lwn.net/Articles/528078/). Docker Containers represent encapsulated units that can be run independently of each other, no matter where they are located. The containers are quickly and efficiently scalable if more instances of an application are needed. The basis of a Docker container is a Docker image that contains all the components to run an application in a platform-independent way. 

## Installation of Docker on the rapsberry pi
Downloading the [installation script](https://get.docker.com) and running this script
```
curl -sSL https://get.docker.com | sh 
```

Give Pi-user permission to run Docker commands 
```
sudo usermod -aG docker pi 
```
After the command, the Raspberry Pi should be restarted or the next commands should be executed with 'Sudo'!

To test whether Docker works, [Hello-World](https://hub.docker.com/_/hello-world) can be executed.
```
docker run hello-world 
```

The output should now be the following if everything is okay:
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

## Own Docker-Image
Writing a Dockerfile is the first step in creating an image of an application. The Dockerfile in the bulletin board application looks like this:
```
# Use the official image as a parent image.
FROM node:current-slim

# Set the working directory.
WORKDIR /usr/src/app

# Copy the file from your host to your current location.
COPY package.json .

# Run the command inside your image filesystem.
RUN npm install

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 8080

# Run the specified command within the container.
CMD [ "npm", "start" ]

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .
```

## Dotnet app as Docker-Image
### Dockerfile
```
FROM mcr.microsoft.com/dotnet/core/runtime:3.1.9-buster-slim-arm32v7

WORKDIR /app

COPY program/bin/Release/netcoreapp3.0/ .
COPY data data

CMD ["./program"]
```
### Update-script
```
#!/bin/bash
cd /home/pi/Projects/docker/program/
git fetch
if git status | grep -q "behind"; then
        git pull
        dotnet build --configuration Release
        cd ..
        docker rm $(docker stop $(docker ps -a -q --filter ancestor=program:1.0 --format="{{.ID}}"))
        docker build --tag program:1.0 .
        docker container run program:1.0
fi
```
### Cronjob
```
5 * * * * /home/pi/Projects/docker/update.sh
```
### Activity diagram
![activity diagram](http://www.plantuml.com/plantuml/png/RSunRiCm38NXsJe5H_i0NPAXkGeZFST4AKgGg1YzVLst1Jfa8_5_17Zhpir7rd0E8JHKi8VfyX2d5HwtQvXafNdKn0xY9uloNP7U5_8DHlCd-XAcwQA54_smw_T-7wA9Kd63KomDnBMgH7OfTehkfHuWVg0Tm9p5qFxT6lQ_B9aVE5CRzYh0ago_xzE-YOBcDyfYmz6fFD6MS3lGoFe5 "Title")
