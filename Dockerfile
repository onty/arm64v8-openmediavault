#
# OpenMediaVault Dockerfile 
#
# https://www.openmediavault.org
#
# Written by: Lintang <onty@SDF.org>
# Architecture : arm64v8
#
# Usage:
#
# sudo docker run -itd -p 8080:80 -v /Data/:/data -h omv.local openmediavault

# Pull the base image.
FROM arm64v8/debian

COPY console-setup /etc/default/
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
	apt-get install wget gnupg apt-utils apt-transport-https postfix supervisor nginx console-setup -y

RUN echo "deb https://packages.openmediavault.org/public arrakis main" >> /etc/apt/sources.list.d/openmediavault.list && \
	gpg --recv-keys 24863F0C716B980B && gpg --export 24863F0C716B980B | apt-key add - && \
	apt-get update && \
	apt-get install openmediavault-keyring -y && \
	apt-get install openmediavault -y && \
	apt-get clean

#RUN echo "deb http://packages.omv-extras.org/debian/ arrakis main" >> /etc/apt/sources.list.d/omv-addon.list && \
#	apt-get update && \
#	apt-get install openmediavault-omvextrasorg -y

# Copy supervisor config and nginx config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#RUN which omv-initsystem
#RUN cat /usr/share/openmediavault/initsystem/60rootfs 
#

EXPOSE 80

# Run the application.
CMD ["/usr/bin/supervisord"]
