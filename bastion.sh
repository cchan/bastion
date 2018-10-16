#!/bin/sh
set -e

: ${PUBKEY_HOST?Need public key(s) for host to ssh in}
: ${PUBKEY_CLIENT?Need public key(s) for client to ssh in}
: ${BASTION?Need public ip/domain of bastion}
: ${BASTION_PASSWORD?Need password for bastion}
: ${HOST_USER?Need username for host}

: ${HOST:=host}
: ${CLIENT:=client}
: ${REVTUNNEL_PORT:=32222}

{ echo Hello123; echo Hello123; } | adduser $HOST
mkdir /home/$HOST/.ssh
sh -c "echo '$PUBKEY_HOST' > /home/$HOST/.ssh/authorized_keys"
{ echo "$BASTION_PASSWORD"; echo "$BASTION_PASSWORD"; } | adduser $CLIENT
mkdir /home/$CLIENT/.ssh
sh -c "echo '$PUBKEY_CLIENT' > /home/$CLIENT/.ssh/authorized_keys"
sh -c "echo 'PasswordAuthentication no
ChallengeResponseAuthentication yes
UsePAM yes
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
ClientAliveInterval 120
UseDNS no
PermitRootLogin no
AuthenticationMethods publickey,password publickey,keyboard-interactive
Match User $HOST
   AllowAgentForwarding no
   AllowTcpForwarding yes
   X11Forwarding no
   PermitTunnel no
   GatewayPorts no
   PermitOpen localhost:$REVTUNNEL_PORT
   ForceCommand echo \"This account can only be used for reverse tunnels (ssh -R).\"
Match User $CLIENT
   AllowAgentForwarding no
   AllowTcpForwarding yes
   X11Forwarding no
   PermitTunnel no
   GatewayPorts no
   ForceCommand echo \"This account can only be used for ProxyJump (ssh -J).\"
' > /etc/ssh/sshd_config"
su $CLIENT -c 'google-authenticator --time-based --disallow-reuse --force --qr-mode=utf8 --rate-limit=3 --rate-time=60 --window-size=3'
sh -c "echo 'auth required pam_google_authenticator.so' >> /etc/pam.d/sshd"

echo All done!
echo Now set up the host:
echo "  tmux new -d autossh -M 0 -NvR $REVTUNNEL_PORT:localhost:22 -o ServerAliveInterval=3000 $HOST@$BASTION"
echo And set up your client \~/.ssh/config:
echo "  Host remote"
echo "  Hostname localhost"
echo "  Port $REVTUNNEL_PORT"
echo "  User $HOST_USER"
echo "  ProxyJump $CLIENT@$BASTION"
echo Alternatively, if you have no ProxyJump option:
echo "  ProxyCommand ssh -W %h:%p $CLIENT@$BASTION"
echo
echo After that, you\'re all set! Now we can have some fun:
echo Connect from the client:
echo "  ssh remote"
#echo Alternatively, use mosh for a better connection:
#echo "  apt install mosh"
#echo "  mosh $CLIENT@$BASTION -- ssh $HOST_USER@localhost -p $REVTUNNEL_PORT"
echo Set up a VNC server:
echo "  ssh remote -L 5677:localhost:5677 x11vnc -rfbport 5677 -display :0 -listen localhost -noxdamage"
echo Sshuttle-based VPN:
echo "  apt install sshuttle"
echo "  sshuttle --dns -vvr remote 0/0"
echo SSH file system:
echo "  sshfs remote:~ mountpoint -o reconnect,idmap=user,password_stdin,dev,suid"

exec "$@"
