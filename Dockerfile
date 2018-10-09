FROM alpine

RUN apk add \
  openssh \
  libqrencode \
  google-authenticator \
  openssh-server-pam
  #mosh-server
  #python

COPY bastion-setup.sh /
RUN /bastion-setup.sh

COPY bastion.sh /

EXPOSE 22
ENTRYPOINT ["/bastion.sh"]
CMD ["/usr/sbin/sshd", "-D"]
