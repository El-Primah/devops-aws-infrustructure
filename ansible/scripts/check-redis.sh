#!/bin/bash
set +x

NAMESPACE="dfg"
POD_NAME="comp-redis-0"
ENV="Automation"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/ASD123QWE/ASD123QWE/aSdsdfDSFV2SDFVASD"

send_slack_message() {
    local message="$1"
    curl -X POST -H 'Content-type: application/json' --data {"text":"${message}"} "$SLACK_WEBHOOK_URL"
}


get_pod_info() {
    current_restart_count=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.status.containerStatuses[0].restartCount}')
    current_started_at=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.status.containerStatuses[0].state.running.startedAt}')
}

previous_restart_count=0
previous_started_at=""

while true; do
    get_pod_info
    current_started_timestamp=$(date -d "$current_started_at" +%s)
    previous_started_timestamp=$(date -d "$previous_started_at" +%s)
    if [[ "$current_restart_count" -gt "$previous_restart_count" ]]; then
        curl -X POST -H 'Content-type: application/json' --data '{"text":"WARNING! Pod '$POD_NAME' in namespace '$NAMESPACE' was restarted. Restarts count: $current_restart_count. ENV: $ENV"}' "$SLACK_WEBHOOK_URL"
        echo "WARNING! Pod '$POD_NAME' in namespace '$NAMESPACE' was restarted. Restarts count: $current_restart_count. ENV: $ENV"
    fi
        echo $current_started_timestamp
        echo $previous_started_timestamp

     if [[ "$current_started_timestamp" -lt "$previous_started_timestamp" ]]; then
         curl -X POST -H 'Content-type: application/json' --data '{"text":"WARNING! Pod comp-redis-0 in namespace dfg was restarted, since the working time has decreased. ENV: Automation"}' "$SLACK_WEBHOOK_URL"
         echo "WARNING! Pod '$POD_NAME' in namespace '$NAMESPACE' was restarted, since the working time has decreased. ENV: $ENV"
     fi

    previous_restart_count="$current_restart_count"
    previous_started_at="$current_started_at"

    sleep 10

done