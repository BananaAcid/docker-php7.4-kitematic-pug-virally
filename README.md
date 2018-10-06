# docker-php7.2-kitematic-pug-virally

Simple docker image optimised supporting Kitematic to run PHP 7.2-latest applications on Apache with an external path (VOLUME), easy to setup. Including latest NodeJS, PUG, LESS. Used by the company Virally.

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

------------------------------------
## Installation & Documentation


see https://github.com/BananaAcid/docker-php7.2-kitematic