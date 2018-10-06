# docker-php7.2-kitematic-pug-virally

Simple docker image optimised supporting Kitematic to run PHP 7.2-latest applications on Apache with an external path (VOLUME), easy to setup. Including latest NVM, NodeJS, PUG, LESS. Used by the company Virally.

based on docker-php7.2-kitematic:
![screenshot 2018-09-26](https://user-images.githubusercontent.com/1894723/46049477-e043db80-c12e-11e8-9609-c5c8aa3b08b8.png)

## Intended workflow

1. install docker (and within its menu, Kitematic)
2. get going with this readme
3. place your PHP files in connected folder on your computer to be used by the container

...

4. start the container (e.g. in Kitematic)
5. edit your files, use git or alike
6. use docker exec to trigger the compile of pug/less within the container
7. reload your browser

...

7. stop the container
8. turn off your computer

## simple
------------------------------------

### run docker
```
docker run -p 8000:80 -p 8443:443 --volume "`pwd`/..\":/app  --name my-container bananaacid/docker-php7.2-kitematic-pug-virally
```

### Using gulp
```
docker exec -it my-container bash -cl ' \
   npm link gulp less gulp-less pug gulp-pug gulp-cssmin gulp-sourcemaps ; \
   gulp \
   '
```

`bash -c -l` is alwayas needed, to have the user profile loaded to have the `nvm`, `node`, `npm`, `lessc`, `pug` commands available (l for login), and then execute the commands given.


Using `npm link` will make gulp available (without installing) within the app folder. (`gulp` can not be installed globally, it must always be within the app folder, as well as its requirements)

### Using less cli
```
docker exec -it my-container bash -cl ' lessc ...params '
```

------------------------------------
## Installation & Documentation


see https://github.com/BananaAcid/docker-php7.2-kitematic