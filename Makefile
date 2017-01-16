NAME =			elastic
VERSION =		latest
VERSION_ALIASES =	
TITLE =			Elastic stack
DESCRIPTION =		Elastic stack
DOC_URL =		https://scaleway.com/docs/how-to-use-the-elk-stack-instant-apps/
SOURCE_URL =		https://github.com/scaleway-community/scaleway-elk
DEFAULT_IMAGE_ARCH =	x86_64


IMAGE_VOLUME_SIZE =	50G
IMAGE_BOOTSCRIPT =	stable
IMAGE_NAME =		Elastic stack


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk
