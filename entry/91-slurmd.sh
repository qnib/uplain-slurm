#!/usr/bin/env bash
set -e

MY_IP=$(go-fisherman --print-container-ip)
if [[ "${SLURM_IS_CTLD}" == "true" ]];then
  echo ">> Set /slurmctld/$(hostname) -> ${MY_IP}"
  curl -s http://etcd:2379/v2/keys/slurmctld/$(hostname) -XPUT -d value="${MY_IP}"
else
  echo ">> Set /slurmd/$(hostname) -> ${MY_IP}"
  curl -s http://etcd:2379/v2/keys/slurmd/$(hostname) -XPUT -d value="${MY_IP}"
fi
echo ">> Fork confd"
confd -backend etcd -watch -node http://etcd:2379 &
