# ####################################
# Name: nexus
# FileVersion: 20191127
# ####################################


DK	:= docker
DC	:= docker-compose
DK_EXEC := docker exec -it

DATA_SUF = $(shell date +"%Y.%m.%d.%H.%M.%S")

PROJ_NAME := $(shell basename $(CURDIR))

EXEC := bash

include ./.env
-include ../../yh-prod.env


# ####################################
# Dashboard AREA
# ####################################
start: up
stop: down
up: init-dir
	$(DC) up -d
down:
	$(DC) down
config:
	$(DC) config
start-fg: init-dir
	$(DC) up

sh:
	$(DK_EXEC) $(PROJ_NAME) $(EXEC)
bash: sh

rebuild-then-start: stop init-dir
	$(DK) images | grep -q $(OS_IMG_TAG) && $(DK) rmi $(OS_IMG_TAG) || true
	$(DC) up --build -d


test:
	curl http://localhost:${NEXUS_PORT}/nexus/service/local/status

backup:
	[ -L /mnt/repo-hub -o -d /mnt/repo-hub ] && sudo rsync -avP data/ /mnt/repo-hub/$(PROJ_NAME)/ || true


# ####################################
# Init AREA
# 	init-dir: 
# ####################################
init-dir:
	# 创建数据目录(-dLf), 也可以直接-e来判存
	$(DC) config | grep ":rw$$" | grep -o " /[^:]*" | grep "/[^.]*$$" | grep -o "[^ ]*" | while read x; do \
		echo "verify dir/link $$x"; \
		[ -d "$$x" -o -L "$$x" -o -f "$$x" ] || mkdir -p "$$x"; \
		echo $$x; \
	done;
	# data目录移交权限
	[ ! -d data ] || sudo chown -R 200:200 data
	[ ! -d "${XDC_NEXUS_DATA}" ] || sudo chown -R 200:200 "${XDC_NEXUS_DATA}"


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf log/* *.bak
