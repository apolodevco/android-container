FROM ubuntu:18.04

LABEL maintainer "apolov@devco.com.co"

WORKDIR /

SHELL ["/bin/bash", "-c"]

RUN apt update && apt install -y openjdk-8-jdk wget unzip libglu1 libpulse-dev libasound2 libc6  libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxi6  libxtst6 libnss3

# gradle
ENV GRADLE_USER_HOME=/cache
VOLUME $GRADLE_USER_HOME

# android 
ARG ANDROID_EMULATOR_PACKAGE_x86="system-images;android-R;google_apis;x86"
ARG ANDROID_PLATFORM_VERSION="platforms;android-R"
ARG ANDROID_SDK_VERSION="sdk-tools-linux-4333796.zip"
ARG ANDROID_SDK_PACKAGES="${ANDROID_EMULATOR_PACKAGE_x86} ${ANDROID_PLATFORM_VERSION} platform-tools emulator"

RUN wget https://dl.google.com/android/repository/${ANDROID_SDK_VERSION} -P /tmp && \
    unzip -d /opt/android /tmp/${ANDROID_SDK_VERSION}
ENV ANDROID_HOME=/opt/android
ENV PATH "$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

# sdkmanager
RUN mkdir /root/.android/
RUN touch /root/.android/repositories.cfg
RUN yes Y | sdkmanager --licenses 
RUN yes Y | sdkmanager --verbose --no_https ${ANDROID_SDK_PACKAGES} 

# avdmanager
RUN echo "no" | avdmanager --verbose create avd --force --name "GOOGLE_PIXEL_EMULATOR" --device "pixel" --package "${ANDROID_EMULATOR_PACKAGE_x86}"
ENV LD_LIBRARY_PATH "$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib"

# clean up
RUN  apt-get remove -y unzip wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*   

ADD start.sh /
RUN chmod +x start.sh
