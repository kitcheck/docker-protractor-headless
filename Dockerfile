FROM node:slim
MAINTAINER j.ciolek@webnicer.com

WORKDIR /tmp

RUN npm install -g protractor@1.8.0 mocha jasmine && \
    npm install && \
    webdriver-manager update

RUN apt-get clean && \
    apt-get update && \
    apt-get install -y xvfb wget openjdk-7-jre libxss1 libnspr4-0d libcurl3 libpango1.0-0 fonts-liberation libappindicator1 xdg-utils

RUN curl -L -o google-chrome-stable.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable.deb && \
    rm google-chrome-stable.deb && \
    apt-get install -f -y && \
    apt-get clean

RUN mkdir /protractor

ADD protractor.sh /protractor.sh
# Fix for the issue with Selenium, as described here:
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
WORKDIR /protractor
ENTRYPOINT ["/protractor.sh"]
