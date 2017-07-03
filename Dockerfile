FROM ubuntu:trusty

RUN apt-get update && \
    apt-get install -y make libperl-dev build-essential wget && \
    sh -c 'echo "yes" | cpan' && \
    cpan -i App::cpanminus

ADD Bot-BasicBot-0.91.tar.gz \
    Moose-2.2005.tar.gz \
    POE-1.367.tar.gz \
    POE-Component-IRC-6.88.tar.gz \
    POE-Component-Syndicator-0.06.tar.gz \
    POE-Filter-IRCD-2.44.tar.gz \
    /tmp/

ADD . /srv/buttbot/

RUN rm /srv/buttbot/conf.yml && \
    cpanm -i Class::Load Package::DeprecationManager MRO::Compat Devel::OverloadInfo Eval::Closure Devel::GlobalDestruction Sub::Exporter Math::Random TeX::Hyphen Dir::Self YAML::Any IRC::Utils IO::Pipely Object::Pluggable::Constants && \
    cd /tmp/Bot-BasicBot-0.91 && \
    perl Makefile.PL && \
    make install && \
    cd /tmp/POE-1.367 && \
    sh -c 'echo "y" | perl Makefile.PL' && \
    make install && \
    cd /tmp/POE-Component-IRC-6.88 && \
    perl Makefile.PL && \
    make install && \
    cd /tmp/POE-Filter-IRCD-2.44 && \
    perl Makefile.PL && \
    make install && \
    cd /tmp/POE-Component-Syndicator-0.06 && \
    perl Makefile.PL && \
    make install && \
    cd /tmp/Moose-2.2005 && \
    perl Makefile.PL && \
    make && \
    make install && \
    rm -rf /srv/buttbot/*.tar.gz && \
    cp /srv/buttbot/start /start && \
    useradd --home /srv/buttbot buttbot && \
    chown buttbot:buttbot /srv/buttbot && \
    chmod +x /start


ENTRYPOINT ["/start"]
WORKDIR /srv/buttbot
USER buttbot
