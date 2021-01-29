#!/usr/bin/env bash

if [ -f "/var/run/secrets/kubernetes.io/serviceaccount/namespace" ]; then
  NAMESPACE=$(cat "/var/run/secrets/kubernetes.io/serviceaccount/namespace")
fi

if [ -z "$NAMESPACE" ]; then
  prinft "Environment variable \"NAMESPACE\" must not be empty", "NAMESPACE"
  exit 1
fi

readonly RELEASES=$(kubectl get job --namespace="$NAMESPACE" --output=jsonpath='{range .items[?(@.status.succeeded==1)]}{@.metadata.annotations.meta\.helm\.sh/release-name}{"\n"}{end}')
for RELEASE in $RELEASES; do
  helm uninstall --namespace "$NAMESPACE" "$RELEASE"
done

if [[ -n "$MATTERMOST_URL" ]]; then


  if [ -z "$RELEASES" ]; then
      curl -i -X POST \
        -H 'Content-Type: application/json' \
        -d '{"username": "K8S Janitor", "icon_url": "https://raw.githubusercontent.com/matchilling/k8s-janitor/main/icon.png", "text": "No delete candidates found in namespace '"$NAMESPACE"' :tada:"}' \
        "$MATTERMOST_URL"
    else
      curl -i -X POST \
        -H 'Content-Type: application/json' \
        -d '{"username": "K8S Janitor", "icon_url": "https://raw.githubusercontent.com/matchilling/k8s-janitor/main/icon.png", "text": "Uninstalled to following releases (namespace: '"$NAMESPACE"'):\n'"$(echo "$RELEASES" | tr '\n' ',')"'\n:tada:"}' \
        "$MATTERMOST_URL"
  fi
fi
