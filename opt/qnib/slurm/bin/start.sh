#!/bin/bash
set -xe

confd -backend etcd -onetime -node http://etcd:2379
 
if [[ "${SLURM_IS_CTLD}" == "true" ]];then
  slurmctld -D -vvvv
else
  slurmd -D -vvvv
fi
