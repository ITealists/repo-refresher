FROM alpine:latest

#install git and openssh-client for getting repo. install bash cuz that's what we script in
RUN apk add --update \
    bash \
    git \
    openssh-client \
    && rm -rf /var/cache/apk/*

ENV BRANCH 'master'
VOLUME ["/git","/logs"]
#create the pull script so it can be called when container starts
ADD . .
RUN chmod 711 git-* && mv git-* /bin
RUN echo "@reboot git-setup" > /var/spool/cron/crontabs/root
CMD crond -l 2 -f
