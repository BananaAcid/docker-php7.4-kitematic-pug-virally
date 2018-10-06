# usage `make` or `make image` or `make run` or `make rmi`
# using `make`, use `make kill && make` to rebuild and run
all: image run

# build the image for distribution
image:
	docker build -t docker-php7.2-kitematic-pug-virally .

# test the image on port 8000
run:
	docker run -p 8000:80 -p 8443:443 -d --name virally-test docker-php7.2-kitematic-pug-virally

# just remove the image
rmi:
	docker rmi docker-php7.2-kitematic-pug-virally --force
	echo "reopen Kitematic (BETA) to update correctly"

# stop container and delete its image from docker
kill:
	docker rm `docker stop \`docker ps -a -q  --filter ancestor=docker-php7.2-kitematic-pug-virally\``
	#docker kill `docker ps -a -q  --filter ancestor=docker-php7.2-kitematic-pug-virally`
	docker rmi docker-php7.2-kitematic-pug-virally --force
	echo "reopen Kitematic (BETA) to update correctly"


id:
	docker ps -a -q  --filter ancestor=docker-php7.2-kitematic-pug-virally
	

exec:
	# common part:
	#   docker exec -it `docker ps -a -q  --filter ancestor=docker-php7.2-kitematic-pug-virally` [ . /root/.bashrc > /dev/null ];   ...cmds
	docker exec -it `docker ps -a -q  --filter ancestor=docker-php7.2-kitematic-pug-virally` [ . /root/.bashrc > /dev/null ]; node -v ; lessc -v ; pug --version


# 1. make image, 2. login, 3. tag, 4. push
login:
	docker login

tag:
	docker tag docker-php7.2-kitematic-pug-virally bananaacid/docker-php7.2-kitematic-pug-virally

push:
	# for this, the image name has to be without the username until here
	docker push bananaacid/docker-php7.2-kitematic-pug-virally
