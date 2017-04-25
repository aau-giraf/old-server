FROM jenkins:latest
RUN /usr/local/bin/install-plugins.sh google-oauth-plugin android-emulator android-lint oauth-credentials git-client artifactory cas-plugin checkstyle git google-play-android-publisher postbuild-task gradle javadoc junit repository

USER root
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/tools_r25.2.3-linux.zip

RUN cd /opt && curl -o tools.zip $ANDROID_SDK_URL 
RUN cd /opt && unzip tools.zip
COPY intel-android-extra-license /opt/tools/licenses/intel-android-extra-license
COPY android-sdk-license /opt/tools/licenses/android-sdk-license

ENV ANDROID_HOME /opt/tools
ENV PATH $PATH:$ANDROID_HOME/

RUN android update sdk --no-ui

COPY config.xml /var/jenkins_home/config.xml
