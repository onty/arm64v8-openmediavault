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
#   sudo docker run -it -p 8080:8080 onty/arm64v8-openmediavault

# Pull the base image.
FROM arm64v8/debian

RUN echo "deb http://packages.openmediavault.org/public erasmus main" >> /etc/apt/sources.list.d/openmediavault.list \ 
	&& wget -O - http://packages.openmediavault.org/public/archive.key | sudo apt-key add - \
	&& apt-get update \
	&& apt-get install openmediavault-keyring postfix -y --force-yes \
	&& apt-get install php-apc openmediavault -y --force-yes

RUN echo "deb http://packages.omv-extras.org/debian/ erasmus main" >> /etc/apt/sources.list.d/omv-addon.list \
	&& apt-get update
	&& apt-get install openmediavault-omvextrasorg -y --force-yes

# Copy supervisor config and nginx config

#

EXPOSE 8080 8443

# Run the application.
CMD ["/usr/bin/supervisord"]
