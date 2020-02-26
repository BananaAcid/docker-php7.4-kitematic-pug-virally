FROM bananaacid/docker-php7.4-kitematic:latest

LABEL maintainer="Nabil Redmann (BananaAcid) <repo@bananaacid.de>"
LABEL version="1.0"
LABEL description="Apache 2 + currently PHP 7.4 \
With support for external app folder. Using Ubuntu. \
+ NodeJS + pug/less/sass(compass) - Virally.de"

# htaccess enabled?
ENV ALLOW_OVERRIDE True


# all in https://gist.github.com/BananaAcid/93c319ada91c30ed904e9bc93d324a19


# Install basics
RUN apt-get update && apt-get -yq install git-core

# gulp-compass needs ruby + compass
RUN apt-get  -yq install ruby-dev ; \
	gem update --system ; \
	gem install compass
#-n /usr/bin 

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
	npm i -g npm less less-plugin-autoprefix gulp@4 pug-cli fancy-log gulp-changed gulp-less gulp-pug gulp-clean-css gulp-cssmin gulp-uglify gulp-rename gulp-print gulp-sourcemaps \
	gulp-compass

# save some data for the sample page
RUN . /etc/profile.d/nvm.sh && \
	nvm exec npm list -g --depth=0 1>/opt/nvm/_installed_npm_modules.txt 2>/dev/null ; echo ""


# new files
ADD src/sample/ /app/

RUN rm /app/*.* ; rm /var/www/html ; ln -sf /app/www /var/www/html


# Add image configuration and scripts
ADD src/run.sh /run.sh
RUN chmod 755 /*.sh


# NOW:  you can use  bash -lc "cmds ... " to execute 

# example
#   docker exec -it `docker ps -a -q  --filter ancestor=docker-php7.4-kitematic-pug-virally` bash -lc " nvm "
