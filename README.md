Unanswered questions:
- How do I deploy this to GCP? Can I just pull directly from github? (docker build github.com/... works)
  - Can I upload a config to GCP? Or do I have to manually enter the env vars?
- How do I get the QR code to actually display? (might have to use qrencode myself)
  - libqrencode isn't found I think.
- Check that the bastion is verifying all three of client's key, password, and 2FA.
  - Check that the host is verifying only client's key (ForwardAgent yes)
- Force it to always ask for password + 2FA code before saying no

```
docker build -t bastion .
docker run -d -p 2222:22 --env-file env.list --name bastion-instance bastion
```


Notes:
- GCP disallows root ssh login
