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

## To do this on ubuntu
- Locally `scp bastion.sh env.list bastion:~`
- On bastion `sudo apt install libqrencode-dev libpam-google-authenticator mosh python`
- On bastion `sudo su`
  - `. env.list` - need to change these to `export`s
  - `./bastion.sh service ssh restart`
- On bastion, lock your sudoer account out, for example with `google-authenticator --time-based --disallow-reuse --force --qr-mode=utf8 --rate-limit=3 --rate-time=60 --window-size=3 >/dev/null`

Notes:
- GCP disallows root ssh login, and creates an account according to the username field of your ssh key (as long as it's not root).
