FROM alpine

RUN apk update && apk upgrade -U -a && apk add --no-cache \
  openssh \
  libqrencode  # libqrencode-dev doesn't work either \
  google-authenticator \
  openssh-server-pam
  #mosh-server
  #python

COPY bastion-setup.sh /
RUN /bastion-setup.sh

COPY bastion.sh /

EXPOSE 2222
ENTRYPOINT ["/bastion.sh"]
CMD ["/usr/sbin/sshd", "-D"]
