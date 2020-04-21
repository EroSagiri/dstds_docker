FROM cm2network/steamcmd
copy --chown=1000:1000 start_server.sh /home/steam/start_server.sh
USER root
RUN mkdir -p /home/steam/.klei/DoNotStarveTogether/world \
    && chown -R steam:steam /home/steam/.klei/ \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y  --no-install-recommends --no-install-suggests \
        libcurl4-gnutls-dev:i386 \
    && apt-get clean autoclean \
    && rm -rf /var/lib/apt/lists/*
USER steam
CMD ["/home/steam/start_server.sh"]
VOLUME /home/steam/.klei/DoNotStarveTogether/world
EXPOSE 11000 11001
