if [[  -z "$QQ_ACCOUNT" ]] ;then
  echo "QQ_ACCOUNT is null, just start miraiOK"
  echo "QQ_ACCOUNT 为空，直接启动miraiOK"
  ./miraiOK
else
  echo "start create config files with env vars"
  if ! grep '^[[:digit:]]*$' <<< "$QQ_ACCOUNT" ;then
    echo "QQ_ACCOUNT must be pure number"
    echo "QQ_ACCOUNT 必须是纯数字"
    exit 1
  fi

if [[  -z "$QQ_PASSWORD" ]] ;then
  echo "QQ_PASSWORD can not be null"
  echo "QQ_PASSWORD 不能为空"
  exit 1
fi

if ! grep '^[[:digit:]]*$' <<< "$NOTIFY_ACCOUNT" ;then
  echo "NOTIFY_ACCOUNT must be pure number"
  echo "NOTIFY_ACCOUNT 必须是纯数字"
  exit 1
fi

if [[  -z "$REVERSE_HOST" ]] ;then
  echo "REVERSE_HOST can not be null"
  echo "REVERSE_HOST 不能为空"
  exit 1
fi

if [[ -z "$REVERSE_PORT" ]] ;then
  REVERSE_PORT=8000
fi

# create device.json
echo "creating device.json"
if [ ! -f "device.json" ]; then
  cp device.json.example device.json
fi
# creat config.txt
echo "creating config.txt"
if [[ -z "$NOTIFY_ACCOUNT" ]];then
cat>config.txt<<EOF
----------
login $QQ_ACCOUNT $QQ_PASSWORD

EOF
else
cat>config.txt<<EOF
----------
login $QQ_ACCOUNT $QQ_PASSWORD
say $NOTIFY_ACCOUNT MiraiOK_published!

EOF
fi
# create setting.yml
echo "creating setting.yml"
cat>setting.yml<<EOF
"$QQ_ACCOUNT":
  ws_reverse:
    enable: true
    postMessageFormat: string
    reverseHost: $REVERSE_HOST
    reversePort: $REVERSE_PORT
    reversePath: /ws/
    accessToken: null
    reconnectInterval: 3000
EOF
echo "start miraiOK"
./miraiOK
fi
