FROM qnib/uplain-init

RUN apt-get update \
 && apt-get install -y gcc wget make bzip2 g++

## pmix
ARG PMI_VER=v2.1.1

RUN apt-get install -y git autoconf libtool
RUN git clone https://github.com/pmix/pmix.git /usr/local/src/pmix/pmix \
 && cd /usr/local/src/pmix/pmix \
 && git checkout ${PMI_VER}
RUN apt-get install -y libevent-dev flex \
 && cd /usr/local/src/pmix/pmix \
 && ./autogen.sh \
 && ./configure --prefix=/usr/ \
 && make -j4 \
 && make install

## SLURM
ARG SLURM_VER=17.11.7
RUN apt-get install -y libgtk2.0-dev libmunge-dev \
 && useradd -s /bin/false slurm \
 && mkdir -p /usr/local/src/slurm \
 && wget -qO - https://download.schedmd.com/slurm/slurm-${SLURM_VER}.tar.bz2 |tar xfj - --strip-components=1 -C /usr/local/src/slurm \
 && cd /usr/local/src/slurm \
 && ./autogen.sh \
 && ./configure --prefix=/usr/ \
 && make -j4 \
 && make install
