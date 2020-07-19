if [ ! -f "config.txt" ]; then
  cp config.txt.example config.txt
fi
if [ ! -f "setting.yml" ]; then
  cp setting.yml.example setting.yml
fi
if [ ! -f "device.json" ]; then
  cp device.json.example device.json
fi
# docker run --rm -it --name miraiok -v $(pwd)/config.txt:/workdir/config.txt -v $(pwd)/setting.yml:/workdir/plugins/CQHTTPMirai/setting.yml -v $(pwd)/device.json:/workdir/device.json -v $(pwd)/log:/workdir/log lqbing/miraiok

docker run --rm -it -d --name miraiok -v $(pwd)/config.txt:/workdir/config.txt -v $(pwd)/setting.yml:/workdir/plugins/CQHTTPMirai/setting.yml -v $(pwd)/device.json:/workdir/device.json -v $(pwd)/log:/workdir/log lqbing/miraiok
