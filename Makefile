# usage `make` or `make image` or `make run` or `make rmi`
# using `make`, use `make image && make run && make kill` to rebuild and run and stop + clear docker afterwards
all: image run

# build the image for distribution
image:
	docker build -t docker-php7.4-kitematic-pug-virally .

# test the image on port 8000
run:
	docker run -p 8000:80 -d --name virally-test docker-php7.4-kitematic-pug-virally
run-dir:
	#docker run -p 8000:80 -d --volume $(CURDIR)/src/sample:/app --name virally-test docker-php7.4-kitematic-pug-virally
	docker attach virally-test || docker-compose -f ./docker-compose.yml up

# just remove the image
rmi:
	docker rmi docker-php7.4-kitematic-pug-virally --force
	echo "reopen Kitematic to update correctly / use CTRL+R to reload / CMD+R to reload"

# stop container and delete its image from docker
kill:
	docker rm `docker stop \`docker ps -a -q  --filter ancestor=docker-php7.4-kitematic-pug-virally\``
	#docker kill `docker ps -a -q  --filter ancestor=docker-php7.4-kitematic-pug-virally`
	docker rmi docker-php7.4-kitematic-pug-virally --force
	echo "reopen Kitematic to update correctly / use CTRL+R to reload / CMD+R to reload"


id:
	docker ps -a -q  --filter ancestor=docker-php7.4-kitematic-pug-virally
	

exec:
	# common part:
	#   docker exec -it `docker ps -a -q  --filter ancestor=docker-php7.4-kitematic-pug-virally` [ . /root/.bashrc > /dev/null ];   ...cmds
	docker exec -it `docker ps -a -q  --filter ancestor=docker-php7.4-kitematic-pug-virally` bash -lc "nvm --version ; node -v ; lessc -v ; pug --version"


# 1. make image, 2. login, 3. tag, 4. push
publish:
	make image && make login && make tag && make push

login:
	docker login

tag:
	docker tag docker-php7.4-kitematic-pug-virally bananaacid/docker-php7.4-kitematic-pug-virally

push:
	# for this, the image name has to be without the username until here
	docker push bananaacid/docker-php7.4-kitematic-pug-virally
