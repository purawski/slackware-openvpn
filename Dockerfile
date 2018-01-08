FROM vbatts/slackware:14.2
ENV TERM xterm
RUN mv /etc/slackpkg/mirrors /etc/slackpkg/mirrors.org &&\
    echo "http://sunsite.icm.edu.pl/packages/linux-slackware/slackware64-14.2/" > /etc/slackpkg/mirrors &&\
    slackpkg -batch=on -default_answer=y update &&\
    slackpkg -batch=on -default_answer=y upgrade-all
#RUN slackpkg -batch=on -default_answer=y upgrade patches    
RUN slackpkg -batch=on -default_answer=y install \
            bash-completion \
            ca-certificates \
            lzo openvpn \
            libpcap libnl3 dbus iptables guile libffi libgcrypt libgpg-error \

RUN slackpkg -batch=on -default_answer=y install \
    binutils gcc-5 gcc-g++-5 perl\
    glibc-2 libmpc kernel-headers make autoconf automake m4 zlib bc \
    cmake libarchive nettle libxml2 gc flex bison rsync gnupg cyrus-sasl
RUN /usr/sbin/update-ca-certificates --fresh 
#&&\
#    cd /tmp &&\
#    wget https://github.com/sbopkg/sbopkg/releases/download/0.38.1/sbopkg-0.38.1-noarch-1_wsr.tgz &&\
#    installpkg /tmp/sbopkg-0.38.1-noarch-1_wsr.tgz &&\
#    rm /tmp/sbopkg-0.38.1-noarch-1_wsr.tgz
#RUN mkdir -p /var/lib/sbopkg/SBo/`cat /etc/slackware-version | awk -F' ' '{print $2}'` \
#    /var/lib/sbopkg/queues /var/log/sbopkg /var/cache/sbopkg /tmp/SBo && \
#    sbopkg -r
#    sqg -a
#RUN    sbopkg -B -i radiusplugin
RUN wget https://www.slackbuilds.org/slackbuilds/14.2/network/radiusplugin.tar.gz &&\
    tar axvf radiusplugin.tar.gz &&\
    cd radiusplugin &&\
    wget http://www.nongnu.org/radiusplugin/radiusplugin_v2.1a_beta1.tar.gz &&\
    ./radiusplugin.SlackBuild && \
    installpkg /tmp/radiusplugin-2.1a_beta1-x86_64-1_SBo.tgz 
RUN removepkg binutils gcc-5 gcc-g++-5 perl\
    glibc-2 libmpc kernel-headers make autoconf automake m4 zlib bc \
    cmake libarchive nettle libxml2 gc flex bison rsync gnupg cyrus-sasl

VOLUME ["/etc/openvpn"]

EXPOSE 1194/udp 1194/tcp

COPY init.sh /
#CMD ["/bin/sh"]
CMD ["/init.sh"]

