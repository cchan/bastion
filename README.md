Unanswered questions:
- How do I deploy this to GCP? Can I just pull directly from github? (docker build github.com/... works)
  - Can I upload a config to GCP? Or do I have to manually enter the env vars?
  - When it's pushed to GCP, it does not set up the networking correctly. How do I?
- How do I get the QR code to actually display? (might have to use qrencode myself)
  - libqrencode isn't found I think.
- Check that the bastion is verifying all three of client's key, password, and 2FA.
  - Check that the host is verifying only client's key (ForwardAgent yes)
- Force it to always ask for password + 2FA code before saying no

```
docker build -t bastion .
docker run -d -p 2222:22 --env-file env.list --name bastion-instance bastion
```

## To do this on Debian GNU/Linux 9 on GCP
- Start an instance, give it appropriate restrictions and firewall and external ip and ssh pubkey etc.
- Go into the GCP web ssh console and check key fingerprints: `for pubkey in /etc/ssh/ssh_host_*_key.pub; do ssh-keygen -lf $pubkey; done`
- Go into the GCP web ssh console and check the key fingerprints before connecting from your own computer:
- Locally `scp bastion.sh env.list bastion:~`
- On bastion `sudo apt update && sudo apt dist-upgrade && sudo apt install libqrencode-dev libpam-google-authenticator mosh python`
- On bastion `sudo su`
  - `. env.list`
  - `. bastion.sh service ssh restart`
- Test out all the connections suggested in the instructions!
- Everyone on the server should be now locked out of SSH shell, so keep this shell open if you want it. It's probably good to do a quick check with `who` to check that there's exactly one session (you) and `sudo netstat -tulpna | grep 'ESTABLISHED'` to check that any sshd-related connections are yours.

Notes:
- GCP disallows root ssh login, and creates an account according to the username field of your ssh key (as long as it's not root).
