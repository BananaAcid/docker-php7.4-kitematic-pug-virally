FROM bananaacid/docker-php7.2-kitematic:latest

MAINTAINER Nabil Redmann (BananaAcid) <repo@bananaacid.de>
LABEL version="1.3"
LABEL description="Apache 2 + currently PHP 7.2 \
With support for external app folder. Using Ubuntu. \
+ NodeJS + pug/less - Virally.de"

# htaccess enabled?
ENV ALLOW_OVERRIDE True


# all in https://gist.github.com/BananaAcid/93c319ada91c30ed904e9bc93d324a19


# Install basics
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -yq install git-core


# install nvm only for logged in user:
# RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash && \
# 	export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \


# install nvm for all users (centralized)
RUN groupadd nvm && usermod -aG nvm root && \
	mkdir /opt/nvm && chown :nvm /opt/nvm && chmod -R g+ws /opt/nvm && \
	git clone https://github.com/creationix/nvm.git /opt/nvm && \
	mkdir /opt/nvm/.cache /opt/nvm/versions /opt/nvm/alias

RUN printf "#!/bin/bash\n\nexport NVM_DIR=\"/opt/nvm\" \n[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"\n" > /etc/profile.d/nvm.sh && \
	chmod +x /etc/profile.d/nvm.sh ; \
	printf "\n. /etc/profile.d/nvm.sh\n" >> /etc/bash.bashrc

# nvm availability for logged in user
RUN printf "export NVM_DIR=\"/opt/nvm\"\n[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"\n[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"\n" > $HOME/.profile


ENV PATH="/opt/nvm:${PATH}"


# install newest node using nvm + npm install required modules (docker -> will have an env change here)
RUN . /etc/profile.d/nvm.sh && \
	nvm install ` nvm ls-remote | tail -1` && \
	npm i -g npm less less-plugin-autoprefix gulp@4 pug-cli gulp-cli fancy-log gulp-changed gulp-less gulp-pug gulp-clean-css gulp-cssmin gulp-uglify gulp-rename gulp-print gulp-sourcemaps

ADD sample/* /app/www/

RUN rm /app/*.* ; rm /var/www/html ; ln -sf /app/www /var/www/html

#append to run
#RUN printf "\necho start.\n" >> /run.sh

# crete a nother run script, that loads the original one
#ADD run2.sh /run2.sh
#RUN chmod 755 /*.sh
#CMD ["/run2.sh"]


# NOW:  you can use  bash -lc "cmds ... " to execute 

# example
#   docker exec -it `docker ps -a -q  --filter ancestor=docker-php7.2-kitematic-pug-virally` bash -lc " nvm "

