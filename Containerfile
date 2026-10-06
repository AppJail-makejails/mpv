ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/x11appjail-base:${FREEBSD_RELEASE}-x11

ARG NO_PKGCLEAN
ARG DRIVER

LABEL org.opencontainers.image.title="Mpv" \
    org.opencontainers.image.description="Free and open-source general-purpose video player" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/mpv" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/mpv" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    sysrc clear_tmp_X=NO; \
    \
    pkg update; \
    packages="mpv bash"; \
    if [ -n "${DRIVER}" ] && [ "${DRIVER}" = "intel" ]; then \
        packages="${packages} libva-intel-media-driver libva-intel-driver libva-intel-hybrid-driver"; \
    elif [ -n "${DRIVER}" ] && [ "${DRIVER}" = "nvidia" ]; then \
        packages="${packages} nvidia-driver"; \
    fi; \
    pkg install ${packages}; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*
