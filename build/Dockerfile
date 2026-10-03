# syntax=docker/dockerfile:1.7
# Shared base for GUI app images: ubuntu-base (es_ES locale, Europe/Madrid TZ)
# plus the PulseAudio client. It sets no USER, ENTRYPOINT or shell: those
# belong to each app image.
#
# Always built on ubuntu-base; only its tag can be chosen.
ARG UBUNTU_BASE_TAG=26.04
FROM ubuntu-base:${UBUNTU_BASE_TAG}
ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="gui-app" \
      org.opencontainers.image.description="Base image for GUI apps with PulseAudio client"

# PulseAudio client only: apps talk to the host server (PulseAudio or
# pipewire-pulse) through its socket, mounted at /tmp/pulse/native
RUN apt-get update && \
    apt-get install -y --no-install-recommends libpulse0 pulseaudio-utils && \
    rm -rf /var/lib/apt/lists/*

COPY pulse-client.conf /etc/pulse/client.conf

# GTK apps: don't look for the accessibility bus
ENV NO_AT_BRIDGE=1
