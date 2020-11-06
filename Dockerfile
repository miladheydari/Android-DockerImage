FROM ubuntu:20.04

MAINTAINER miladheydari <miladheydari2011@gmail.com>

ARG SDK_TOOLS_VERSION=6514223
ARG GRADLE_VERSION=6.7
ARG DEBIAN_FRONTEND=noninteractive

ENV ANDROID_HOME "/android-sdk-linux"
ENV PATH "$PATH:${ANDROID_HOME}/tools:/opt/gradle/gradle-${GRADLE_VERSION}/bin"

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y git jq wget unzip curl zip openjdk-8-jdk \
	&& apt-get clean

RUN wget --output-document=gradle-${GRADLE_VERSION}-all.zip https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip \
        && mkdir -p /opt/gradle \
        && unzip gradle-${GRADLE_VERSION}-all.zip -d /opt/gradle \
        && rm ./gradle-${GRADLE_VERSION}-all.zip \
        && mkdir -p ${ANDROID_HOME} \
        && wget --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS_VERSION}_latest.zip \
        && unzip ./android-sdk.zip -d ${ANDROID_HOME} \
        && rm ./android-sdk.zip \
        && mkdir -p ~/.android \
        && touch ~/.android/repositories.cfg

RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses \
        && ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --update

ADD packages.txt .
RUN while read -r package; do PACKAGES="${PACKAGES}${package} "; done < ./packages.txt && \
    ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} ${PACKAGES}
