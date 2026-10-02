# @package exadra37-docker-images/dockerize-graphical-user-interface-app
# @link    https://gitlab.com/u/exadra37-docker-images/dockerize-graphical-user-interface-app
# @since   11 March 2017
# @license GPL-3.0
# @author  Exadra37(Paulo Silva) <exadra37ingmailpointcom>
#
# Social Links:
# @link    Auhthor:  https://exadra37.com
# @link    Gitlab:   https://gitlab.com/Exadra37
# @link    Github:   https://github.com/Exadra37
# @link    Linkedin: https://uk.linkedin.com/in/exadra37
# @link    Twitter:  https://twitter.com/Exadra37

###################################################################################
#                                                                                 #
# ATTENTION:                                                                      #
#                                                                                 #
# TO DOCKERIZE A GUI APP, PLEASE CREATE ANOTHER DOCKERFILE TO EXTEND THIS ONE...  #
#                                                                                 #
###################################################################################

# Base image is configurable so it can be pinned to a specific Ubuntu release (LTS recommended).
ARG BASE_IMAGE=ubuntu-base:26.04

FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.vendor="Exadra37" \
      org.opencontainers.image.title="exadra37-docker-images/dockerize-graphical-user-interface-app" \
      org.opencontainers.image.version="0.1.0" \
      org.opencontainers.image.licenses="GPL-3.0" \
      org.opencontainers.image.source="https://gitlab.com/exadra37-docker-images/dockerize-graphical-user-interface-app" \
      org.opencontainers.image.description="Dockerize any App with a graphical user interface. \
This allow us to run the Dockerized APP from inside a Docker Container. \
Advantages: \
    * No need to install the APP in our Operating System to try it. \
    * Try the APP with many different setups without be afraid to break our OS. \
    * More secure to run, once we can destroy the container when finished, therefore if is compromised it will not \
       infect the OS in our computer. \
    * Keep our OS clean and free of bloated APPs, making easy to upgrade it at any time."

# Will not prompt for questions
ARG DEBIAN_FRONTEND=noninteractive

# Why we want to be able to override?
#   - Because this Dockerfile main purpose is to be used by Bash scripts to dynamical build local images to Dockerize
#    some GUI apps like Visual Studio Code, Sublime Text 3 and many others ones...
#   - But this Dockefile will be also used to build the Docker Image, with this defaults, to be hosted in Docker Hub.
#
# CONTAINER_UID should match the host user UID (`id -u`), otherwise the container user will not have access to the
#  X11 socket and to the mounted volumes.
#
# Override with docker build --build-arg key=value
ARG CONTAINER_USER=dockerize
ARG CONTAINER_UID=1000
ARG CONTAINER_ENTRYPOINT=./entrypoint.sh
ARG CONTAINER_SHELL=/usr/bin/zsh

# Removes DBUS warning that should be only seen by Developer
# https://bugs.launchpad.net/ubuntu/+source/at-spi2-core/+bug/1193236
ENV NO_AT_BRIDGE=1 \
    SHELL="${CONTAINER_SHELL}"

# Use this script to setup your preferred Shell...
#
# Why customize a Shell in a Docker Image to Dockerize a GUI?
#   - For example when dockerizing Visual Studio Code we can access the Shell from inside the editor.
COPY ./setup-user-shell.sh /.container/setup-user-shell.sh

# Installs the minimal dependencies to be able to run a GUI app from inside a Docker Container.
#
# Keep in mind that you still need to install more dependencies depending in what GUI app you are trying to Dockerize.
#
# For Example to Dockerize Gedit editor we need at least more 2 dependencies:
#  * libcanberra-gtk3-module
#  * gedit
#
# Never EDIT this Dockerfile... instead create a new one and extend from this one.
#
# See project https://gitlab.com/exadra37-dockerize-vscode for an example
#
# Everything is done in a single layer, so that the apt lists removed at the end don't stay in a previous layer.
#
# If the GUI App being Dockerized needs a Sudo User, please set it in the image that will extend from this one
#  to Dockerize it.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        dbus-x11 && \
    # Ubuntu images ship an `ubuntu` user with UID 1000, that would collide with $CONTAINER_UID.
    if id ubuntu >/dev/null 2>&1; then userdel -r ubuntu 2>/dev/null || userdel ubuntu; fi && \
    useradd -m -u "${CONTAINER_UID}" -s "${CONTAINER_SHELL}" "${CONTAINER_USER}" && \
    # Setup Shell for $CONTAINER_USER. For ZSH a default installation with Oh My Zsh is provided.
    bash /.container/setup-user-shell.sh "${CONTAINER_USER}" "${CONTAINER_SHELL}" && \
    # We must create .config, .cache and .local folders owned by the container user or they end up belonging to root.
    install -d -o "${CONTAINER_USER}" -g "${CONTAINER_USER}" \
        "/home/${CONTAINER_USER}/.config" \
        "/home/${CONTAINER_USER}/.cache" \
        "/home/${CONTAINER_USER}/.local" \
        "/home/${CONTAINER_USER}/.local/share" \
        "/home/${CONTAINER_USER}/.container" && \
    # Stable path for the ENTRYPOINT, because the exec form doesn't expand build args.
    ln -s "/home/${CONTAINER_USER}/.container/entrypoint.sh" /usr/local/bin/dockerize-entrypoint && \
    # Cleaning
    rm -rf /var/lib/apt/lists/*

# Use this script to set what you want to happen when starting the container.
COPY --chown=${CONTAINER_USER}:${CONTAINER_USER} --chmod=755 \
    "${CONTAINER_ENTRYPOINT}" "/home/${CONTAINER_USER}/.container/entrypoint.sh"

USER ${CONTAINER_USER}
WORKDIR /home/${CONTAINER_USER}

ENTRYPOINT ["/usr/local/bin/dockerize-entrypoint"]
