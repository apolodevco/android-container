FROM jenkins/inbound-agent:latest

LABEL maintainer "apolov@devco.com.co"

WORKDIR /

SHELL ["/bin/bash", "-c"]

USER root

# Install OS Dependencies
RUN apt update && apt install -y build-essential ruby-full nodejs npm wget unzip && gem install fastlane

# Android 
ARG ANDROID_SDK_VERSION="sdk-tools-linux-4333796.zip"
ARG ANDROID_PLATFORM_TOOLS="platform-tools-latest-linux.zip"

RUN wget https://dl.google.com/android/repository/${ANDROID_SDK_VERSION} -P /tmp && \
    unzip -d /opt/android /tmp/${ANDROID_SDK_VERSION}
RUN wget https://dl.google.com/android/repository/${ANDROID_PLATFORM_TOOLS} -P /tmp/ && \
    unzip -d /opt/android /tmp/${ANDROID_PLATFORM_TOOLS}
ENV ANDROID_HOME=/opt/android
ENV PATH "$PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

# Install gradlew
RUN mkdir /opt/gradle
RUN wget https://services.gradle.org/distributions/gradle-6.5-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-6.5-bin.zip
ENV PATH "$PATH:/opt/gradle/gradle-6.5/bin"

# sdkmanager
RUN mkdir /root/.android/
RUN touch /root/.android/repositories.cfg
RUN yes Y | sdkmanager --licenses

# clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*   
