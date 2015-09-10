DOCKER_NAMESPACE =	armbuild/
NAME =			scw-app-elk
VERSION =		latest
VERSION_ALIASES =	
TITLE =			ELK stack
DESCRIPTION =		ELK stack
DOC_URL =		https://scaleway.com/docs/how-to-use-the-elk-stack-instant-apps/
SOURCE_URL =		https://github.com/scaleway/image-app-elk
VENDOR_URL =		https://www.elastic.co/products

IMAGE_VOLUME_SIZE =	50G
IMAGE_BOOTSCRIPT =	stable
IMAGE_NAME =		ELK stack


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk
