#!/bin/bash

apiToken="  "
chatId="409125565"
# portUp=(2184 9095 2183 9094 2182)
portUp=(80 22 24)
portDown=()

checkport() {
        if nc -zv -w10 $1 $2 <<< '' &> /dev/null
        then
                stt=""
                msg="port $1:$2 up"
        else
                stt="down"
                msg="port $1:$2 down"
        fi
}

send() {
        curl -s \
        -X POST \
        https://api.telegram.org/bot$apiToken/sendMessage \
        -d text="$msg" \
        -d chat_id=$chatId
}

del(){
        for target in "${delete[@]}"; do
          for i in "${!portDown[@]}"; do
            if [[ ${portDown[i]} = "${delete[0]}" ]]; then
              unset 'portDown[i]'
            fi
          done
        done
}

trigger() {
        for i in ${portUp[*]}
        do
           checkport '18.219.219.40' $i
           if [[ ! -z "$stt" ]]; then
                    send
                    portDown+=("$i")
           # else
           #          send
           fi
        done
}

wait_fix(){
        while [[ ! -z "${portDown[*]}" ]]; do
          for i in ${portDown[*]}
          do
             checkport '18.219.219.40' $i
             if [[ -z "$stt" ]]; then
                      send
                      delete=("$i")
                      del
             fi
          echo "Fix port: ${portDown[*]}"
          done
        done
}



trigger
wait_fix
