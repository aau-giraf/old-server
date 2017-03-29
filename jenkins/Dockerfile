FROM jenkins:latest
RUN /usr/local/bin/install-plugins.sh google-oauth-plugin:0.3 PrioritySorter:3.0 ldap:1.11 analysis-core:1.71 locale:1.2 android-emulator:2.13.1 android-lint:2.2 oauth-credentials:0.3 ant:1.2 mailer:1.15 git-client:1.17.0 antisamy-markup-formatter:1.3 mapdb-api:1.0.6.0 artifactory:2.3.0 build-timeout:1.14.1 matrix-auth:1.3 cas-plugin:1.2.0 checkstyle:3.42 matrix-project:1.4 credentials:1.22 pam-auth:1.2 cvs:2.12 port-allocator:1.8 email-ext:2.40.1 git:2.3.5 external-monitor-job:1.4 google-play-android-publisher:1.3.1 postbuild-task:1.8 preSCMbuildstep:0.3 gradle:1.24 publish-over-ftp:1.11 jacoco:1.0.19 publish-over-ssh:1.12 javadoc:1.3 maven-plugin:2.9 python:1.2 junit:1.6 scm-api:0.2 parameterized-trigger:2.26 project-inheritance:1.5.3 reverse-proxy-auth-plugin:1.4.0 script-security:1.14 shelve-project-plugin:1.5 ssh-credentials:1.11 ssh-slaves:1.9 subversion:2.5 token-macro:1.10 translation:1.12 windows-slaves:1.0 repository

#ENV ANDROID_SDK_URL https://dl.google.com/android/repository/tools_r25.2.3-linux.zip

#USER root
#RUN cd /opt && curl -o tools.zip $ANDROID_SDK_URL 
#RUN cd /opt && unzip tools.zip

#USER jenkins
#ENV ANDROID_HOME /opt/tools
#ENV PATH $PATH:$ANDROID_HOME/

USER root
#RUN android update sdk --no-ui

COPY config.xml /var/jenkins_home/config.xml
COPY jobs /var/jenkins_home/
