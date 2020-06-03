FROM jenkins/inbound-agent:latest

LABEL maintainer "apolov@devco.com.co"

WORKDIR /

SHELL ["/bin/bash", "-c"]

USER root

# Install OS Dependencies
RUN apt update && apt install -y build-essential ruby-full nodejs npm wget unzip && gem install fastlane

# Android 
ARG ANDROID_SDK_VERSION="sdk-tools-linux-4333796.zip"

RUN wget https://dl.google.com/android/repository/${ANDROID_SDK_VERSION} -P /tmp && \
    unzip -d /opt/android /tmp/${ANDROID_SDK_VERSION}
ENV ANDROID_HOME=/opt/android
ENV PATH "$PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

# sdkmanager
RUN mkdir /root/.android/
RUN touch /root/.android/repositories.cfg
RUN yes Y | sdkmanager --licenses

# clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*   
