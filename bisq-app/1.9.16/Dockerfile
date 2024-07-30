FROM fflo/bisq-on-docker:base

WORKDIR /opt

ARG BISQ_VERSION=1.9.16
ENV BISQ_DEBFILE Bisq-64bit-$BISQ_VERSION.deb
ENV BISQ_DOL_URL https://bisq.network/downloads/v$BISQ_VERSION/$BISQ_DEBFILE
ENV BISQ_ASC_URL https://bisq.network/downloads/v$BISQ_VERSION/$BISQ_DEBFILE.asc
# signing key (Christoph Atteneder)
#ENV BISQ_PGP_KEY CB36D7D2EBB2E35D9B75500BCD5DC1C529CDFD3B
# signing key (Alejandro García)
ENV BISQ_PGP_KEY B493319106CC3D1F252E19CBF806F422E222AA02

ARG UNSPLASH_WALLPAPER_ID=eBWzFKahEaU
ENV UNSPLASH_WALLPAPER_URL https://unsplash.com/photos/$UNSPLASH_WALLPAPER_ID/download?force=true

# workaround bugfix: xdg-desktop-menu: no writable system menu directory found
RUN mkdir -p /usr/share/desktop-directories/

# update default wallpaper
RUN mkdir -p /usr/share/backgrounds/unsplash \
    && wget -qO /usr/share/backgrounds/unsplash/background.jpg "$UNSPLASH_WALLPAPER_URL" \
    && if [ -f /usr/share/glib-2.0/schemas/20_mate-ubuntu.gschema.override ]; then \
           sed -i.bak s#"/usr/share/backgrounds/ubuntu-mate-common/Green-Wall-Logo.png"#"/usr/share/backgrounds/unsplash/background.jpg"#g /usr/share/glib-2.0/schemas/20_mate-ubuntu.gschema.override /usr/share/glib-2.0/schemas/30_ubuntu-mate.gschema.override \
               && rm /usr/share/glib-2.0/schemas/20_mate-ubuntu.gschema.override.bak /usr/share/glib-2.0/schemas/30_ubuntu-mate.gschema.override.bak \
               && glib-compile-schemas /usr/share/glib-2.0/schemas/ ; \ 
       fi

# install bisq
RUN mkdir bisq-install && cd bisq-install \
    && wget -qO $BISQ_DEBFILE "$BISQ_DOL_URL" \
    && gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$BISQ_PGP_KEY" \
    && wget -qO Bisq.asc "$BISQ_ASC_URL" \
    && gpg --digest-algo SHA256 --verify Bisq.asc $BISQ_DEBFILE \
    && dpkg -i $BISQ_DEBFILE \
    && rm *.deb *.asc \
    && cd .. || echo "WARNING: Bisq Installation Failed."

# enable Bisq autostart
COPY bisq.desktop /etc/xdg/autostart/bisq.desktop

