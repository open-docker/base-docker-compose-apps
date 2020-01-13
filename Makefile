
# ####################################
# Config AREA
# ####################################

include ./.env
-include ../../yh-prod.env

SVC_HOST := 127.0.0.1
ES_URL_BASE := http://$(SVC_HOST):${ELASTIC_ES_PORT}

FEATURES := mini beats other
YAML_FILE_GROUPS := $(foreach x,$(FEATURES),-f elastic-$(x).yml)

DK	:= docker
DC	:= docker-compose $(YAML_FILE_GROUPS)
DK_EXEC := docker exec -it

DATA_SUF = $(shell date +"%Y.%m.%d.%H.%M.%S")

PROJ_NAME := $(shell basename $(CURDIR))

CMD := bash


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
	$(DK_EXEC) $(PROJ_NAME) $(CMD)
bash: sh

test: test-core


# ####################################
# Init AREA
# 	init-dir: ES使用普通用户启动，uid=1000
# ####################################
init-dir:
	# 创建数据目录(-dLf), 也可以直接-e来判存
	$(DC) config | grep ":rw$$" | grep -o " /[^:]*" | grep "/[^.]*$$" | grep -o "[^ ]*" | while read x; do \
		echo "verify dir/link $$x"; \
		[ -d "$$x" -o -L "$$x" -o -f "$$x" ] || mkdir -p "$$x"; \
		echo $$x; \
	done;
	# data目录移交权限
	[ ! -d data ] || sudo chown -R 1000:1000 data
	[ ! -d "${XDC_ELASTIC_DATA}" ] || sudo chown -R 1000:1000 "${XDC_ELASTIC_DATA}"


# ####################################
# Sub Debug Only AREA
# ####################################
start-mini:
	docker-compose -f elastic-mini.yml up -d
stop-mini:
	docker-compose -f elastic-mini.yml down

start-beats:
	docker-compose -f elastic-beats.yml up -d
stop-beats:
	-docker-compose -f elastic-beats.yml down

start-other:
	docker-compose -f elastic-other.yml up -d
stop-other:
	-docker-compose -f elastic-other.yml down


# ####################################
# Test AREA
# ####################################
test-core:
	curl $(ES_URL_BASE)
	curl $(ES_URL_BASE)/_cat/health
	curl $(ES_URL_BASE)/_nodes?pretty=true


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
