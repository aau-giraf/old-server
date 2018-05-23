#https://hub.docker.com/r/yesnault/docker-phabricator/
FROM yesnault/docker-phabricator

WORKDIR /opt
RUN curl http://pear.php.net/go-pear.phar -o go-pear.phar && php go-pear.phar
RUN curl https://developer.jasig.org/cas-clients/php/current.tgz -o current.tgz && pear install current.tgz && rm current.tgz go-pear.phar

RUN git clone https://github.com/iodragon/phabricator-cas && ./phabricator/bin/config set load-libraries '["phabricator-cas/src/"]'

RUN curl -L https://github.com/wikimedia/phabricator-extensions-Sprint/archive/release/2017-03-08/1.tar.gz | tar -xzf -
RUN mv phabricator-extensions-Sprint* sprint && ./phabricator/bin/config set load-libraries '["sprint/src"]'
