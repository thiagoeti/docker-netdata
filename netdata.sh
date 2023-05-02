#!/bin/sh

# pull
docker pull "netdata/netdata"

# volume
docker volume create "netdataconfig"
docker volume create "netdatalib"
docker volume create "netdatacache"
ln -s "/var/lib/docker/volumes/netdataconfig" "/data/volume/"
ln -s "/var/lib/docker/volumes/netdatalib" "/data/volume/"
ln -s "/var/lib/docker/volumes/netdatacache" "/data/volume/"

# run
docker run --name "netdata" \
  -p 19999:19999 \
  -v "netdataconfig":"/etc/netdata" \
  -v "netdatalib":"/var/lib/netdata" \
  -v "netdatacache":"/var/cache/netdata" \
  -v "/etc/passwd":"/host/etc/passwd:ro" \
  -v "/etc/group":"/host/etc/group:ro" \
  -v "/proc":"/host/proc:ro" \
  -v "/sys":"/host/sys:ro" \
  -v "/etc/os-release":"/host/etc/os-release:ro" \
  -v "/var/run/docker.sock":"/var/run/docker.sock:ro" \
  --restart "unless-stopped" \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  -d "netdata/netdata"

# netdata

netdata-claim.sh -token=??? -rooms=??? -url=https://app.netdata.cloud

# drop
docker rm -f "netdata"

#
