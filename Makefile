DOCKER_NAMESPACE =	armbuild/
NAME =			scw-app-elk
VERSION =		latest
VERSION_ALIASES =	14.10 14 latest utopic
TITLE =			ELK stack
DESCRIPTION =		ELK stack
DOC_URL =		https://scaleway.com/docs/how-to-use-the-elk-stack-instant-apps/
SOURCE_URL =		https://github.com/scaleway/image-app-elk
IMAGE_VOLUME_SIZE =	50G

## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk


## Here you can add custom commands and overrides
