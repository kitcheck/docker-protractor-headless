FROM node:slim
MAINTAINER j.ciolek@webnicer.com

WORKDIR /tmp

RUN npm install -g protractor@1.8.0 mocha jasmine && \
    webdriver-manager update

RUN apt-get clean && \
    apt-get update && \
    apt-get install -y xvfb wget openjdk-7-jre libxss1 libnspr4-0d libcurl3 libpango1.0-0 fonts-liberation libappindicator1 xdg-utils git

RUN curl -L -o google-chrome-stable.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable.deb && \
    rm google-chrome-stable.deb && \
    apt-get install -f -y && \
    apt-get clean

# installs Dockito Vault ONVAULT utility
# https://github.com/dockito/vault
RUN apt-get update -y && \
    apt-get install -y curl && \
    curl -L https://raw.githubusercontent.com/dockito/vault/master/ONVAULT > /usr/local/bin/ONVAULT && \
    chmod +x /usr/local/bin/ONVAULT

RUN mkdir /protractor

COPY . /protractor/

WORKDIR /protractor/

# Fix for the issue with Selenium, as described here:
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

ENV NODE_PATH=/protractor/node_modules
RUN ONVAULT npm install --unsafe-perm

ENTRYPOINT ["/protractor/protractor.sh"]
