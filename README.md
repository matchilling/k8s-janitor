![K8S Janitor](./icon.png)

# K8S Janitor 🧹

The janitor does what the janitor has to do.

## Usage

### Deploy as a CRON job on K8S

1) Create a deployment.yaml 

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: k8s-janitor
spec:
  schedule: "0 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          serviceAccountName: MY_SERVICE_ACCOUNT_NAME
          containers:
            - name: k8s-janitor
              image: matchilling/k8s-janitor
              args:
                - /bin/sh
                - /opt/k8s-janitor/script/remove_completed_jobs.sh
              env:
                - name: MATTERMOST_URL
                  value: MY_MATTERMOST_URL
          restartPolicy: OnFailure
```

2) Create the resource

```shell
$ kubectl create -f deployment.yaml
```

### Usage for development purposes

```shell
# Run locally using an interactive session
$ make run-local

# Run on K8S an interactive session
$ SERVICE_ACCOUNT=my-service-account \
  NAMESPACE=my-namespace \
  MATTERMOST_URL \
  make run-k8s
```

## Support & Contact

Having trouble with this repository? Check out the documentation at the repository's site or contact
m@matchilling.com and we'll help you sort it out.

Happy Coding

:v:
