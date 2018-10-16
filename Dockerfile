FROM alpine

RUN apk add \
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
