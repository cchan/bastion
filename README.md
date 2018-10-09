Unanswered questions:
- How do I deploy this to GCP? Can I just pull directly from github? (docker build github.com/... works)
  - Can I upload a config to GCP? Or do I have to manually enter the env vars?
- How do I get the QR code to actually display? (might have to use qrencode myself)

```
docker build -t bastion .
docker run -d -p 2222:22 --env-file env.list --name bastion-instance bastion
```


Notes:
- GCP disallows root ssh login
