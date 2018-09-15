#!/bin/bash

FREEBOX_URL=$1
HOST_TO_CHECK=$2
MY_APP_ID=$3
MY_APP_TOKEN=$4

SLEEP=5
FAILS=0

while true; do
    if ping -qc 4 $HOST_TO_CHECK >/dev/null; then
        echo "$(date '+%d-%m-%Y %H:%M:%S') IPV4 UP !"
    else
        echo "$(date '+%d-%m-%Y %H:%M:%S') IPV4 down..."

        # source the freeboxos-bash-api
        source ./freeboxos_bash_api.sh

        # login
        login_freebox "$MY_APP_ID" "$MY_APP_TOKEN"

        # router mode
        answer=$(call_freebox_api_put 'lan/config/' '{"mode":"router","ip":"192.168.1.254","name":"Freebox Server","name_dns":"freebox-server","name_mdns":"Freebox-Server","name_netbios":"Freebox_Server"}') || return 1
        _check_success "$answer" || return 1
        mode=$(get_json_value_for_key "$answer" result.mode)
        echo "$(date '+%d-%m-%Y %H:%M:%S') Mode $mode activé"

        # wait 1 sec
        sleep 1

        # bridge mode
        answer=$(call_freebox_api_put 'lan/config/' '{"mode":"bridge","ip":"192.168.1.254","name":"Freebox Server","name_dns":"freebox-server","name_mdns":"Freebox-Server","name_netbios":"Freebox_Server"}') || return 1
        _check_success "$answer" || return 1
        mode=$(get_json_value_for_key "$answer" result.mode)
        echo "$(date '+%d-%m-%Y %H:%M:%S') Mode $mode activé"

        # wait for ipv4 to come back
        echo "$(date '+%d-%m-%Y %H:%M:%S') Waiting for IPV4 to come back"

        until ping -c1 $HOST_TO_CHECK &>/dev/null; do
            FAILS=$[FAILS + 1]
            echo "Waiting..."

            if [ $FAILS -gt 5 ]; then
                FAILS=0
                echo "$(date '+%d-%m-%Y %H:%M:%S') Failed to get IPV4 back, retrying..."
                break
            fi
            sleep 1
        done

        echo "$(date '+%d-%m-%Y %H:%M:%S') IPV4 is back"
    fi
    sleep $SLEEP #check again in SLEEP seconds
done
