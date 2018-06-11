FROM qnib/uplain-init

RUN apt-get update \
 && apt-get install -y gcc wget make bzip2 g++ curl

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
RUN apt-get install -y libgtk2.0-dev libmunge-dev munge vim iputils-ping \
 && echo
# && useradd -s /bin/false slurm \
# && mkdir -p /usr/local/src/slurm \
# && wget -qO - https://download.schedmd.com/slurm/slurm-${SLURM_VER}.tar.bz2 |tar xfj - --strip-components=1 -C /usr/local/src/slurm \
# && cd /usr/local/src/slurm \
# && ./autogen.sh \
# && ./configure --prefix=/usr/ --prefix=/usr/ \
# && make -j4 \
# && make install
RUN apt-get install -y slurm-llnl
RUN find /usr/lib/x86_64-linux-gnu/slurm/ -exec ln -s {} /usr/local/lib/ \;
RUN mkdir -p /etc/munge/ \
 /var/lib/munge/ \
 /var/log/munge/ \
 /var/run/munge/ \
 /var/log/slurm/ \
 && chown -R root /etc/munge/ \
  /var/lib/munge/ \
  /var/log/munge/ \
  /var/run/munge/ \
 && chmod 700 /etc/munge/ \
 /var/log/munge \
 && chmod 711 /var/lib/munge/ \
 && echo -n "foo" | sha1sum | cut -d' ' -f1 >/etc/munge/munge.key
COPY entry/90-entrypoint.sh \
 entry/91-slurmd.sh \
 /opt/entry/
COPY etc/confd/templates/slurm.conf.tmpl /etc/confd/templates/slurm.conf.tmpl
COPY etc/confd/conf.d/slurm.toml /etc/confd/conf.d/slurm.toml
COPY opt/qnib/slurm/bin/start.sh /opt/qnib/slurm/bin/
CMD ["/opt/qnib/slurm/bin/start.sh"]
ENV SLURM_IS_CTLD=false

RUN mkdir -p /usr/local/slurm/lib
