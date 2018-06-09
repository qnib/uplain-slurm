FROM qnib/uplain-init

RUN apt-get update \
 && apt-get install -y slurm-llnl
