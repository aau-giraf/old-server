FROM jenkins:latest
RUN /usr/local/bin/install-plugins.sh google-oauth-plugin android-emulator android-lint oauth-credentials git-client artifactory cas-plugin checkstyle git google-play-android-publisher postbuild-task gradle javadoc junit repository

USER root
RUN apt-get update
RUN apt-get install -y curl libunwind8 gettext
RUN curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?linkid=847105
RUN mkdir -p /opt/dotnet
RUN tar zxf dotnet.tar.gz -C /opt/dotnet
RUN ln -s /opt/dotnet/dotnet /usr/bin/dotnet
RUN rm dotnet.tar.gz


ENV ANDROID_SDK_URL https://dl.google.com/android/repository/tools_r25.2.3-linux.zip

RUN cd /opt && curl -o tools.zip $ANDROID_SDK_URL 
RUN cd /opt && unzip tools.zip
COPY intel-android-extra-license /opt/tools/licenses/intel-android-extra-license
COPY android-sdk-license /opt/tools/licenses/android-sdk-license
COPY jobs /var/jenkins_home/jobs

ENV ANDROID_HOME /opt/tools
ENV PATH $PATH:$ANDROID_HOME/

RUN echo y | android update sdk --no-ui

COPY config.xml /var/jenkins_home/config.xml
