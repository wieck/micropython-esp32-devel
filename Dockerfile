# ----
# Dockerfile for an ESP32 development container suitable for
# compiling Micropython.
# ----
FROM python:3

# ----
# All these ARGs will be provided by build.sh based on the user running it.
# ----
ARG USER
ARG UID
ARG GID_DIALOUT
ARG HOME
ARG ESPIDF
ARG XTENSA_ESP32_ELF

# ----
# Define environment variables needed by the Micropython build system.
# ----
ENV HOME="$HOME"
ENV PATH="${XTENSA_ESP32_ELF}/bin:${PATH}"
ENV ESPIDF="${ESPIDF}"

# ----
# Update and install requirements
# ----
RUN apt-get update
RUN pip3 install pyserial "pyparsing<2.4"

# ----
# We run under the user, who created the container. This means that the
# user must be a member of the "dialout" group of the host. Naming is not
# critical since UIDs and GIDs are only shared on a numeric base. We
# attempt to create a group with the same GID that "dialout" has on the
# host. Never mind if that fails due to the GID being taken. In the useradd
# command below we make ourselves a member of the numeric GID of whatever
# "dialout" is on the host.
# ----
RUN groupadd -g $GID_DIALOUT dialout_host || exit 0

# ----
# Finally we create our user and set it to be the executor of commands.
# This causes all files, created by the build environment, to be owned
# by our host user.
# ----
RUN useradd -u $UID -U -G $GID_DIALOUT $USER
USER $USER
