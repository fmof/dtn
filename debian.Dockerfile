FROM debian:jessie

ENV uid 1000

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get update && \
    apt-get install -y \
        curl \
        iptables \
        iproute \
        sudo \
        man \
        python \
        traceroute \
        vim

RUN useradd -u $uid -m -U -s /bin/bash globus
RUN passwd -l globus
RUN echo 'globus	ALL=(ALL)	NOPASSWD: ALL' >> /etc/sudoers

ADD bwlimit.bash /home/globus/bwlimit.bash
RUN chmod 755 /home/globus/bwlimit.bash
RUN chown globus:globus /home/globus/bwlimit.bash

USER globus
WORKDIR /home/globus
RUN curl -o globusconnectpersonal-latest.tgz https://s3.amazonaws.com/connect.globusonline.org/linux/stable/globusconnectpersonal-latest.tgz # 2.3.3
RUN tar -xzf globusconnectpersonal-latest.tgz

CMD ["/bin/bash", "-l"]
