# ####################################
# Name: MongoDB 集群环境
# FileVersion: 20191114
# ####################################


DK	:= docker
DC	:= docker-compose


# ####################################
# 环境变量 AREA
# ####################################


# ####################################
# Config AREA
# ####################################
SVC_HOST := $(shell hostname -a)

include ./.env
-include ../../yh-prod.env

SERVER_RSS := rs1 rs2 conf shard
YAML_FILE_GROUPS := $(foreach x,$(SERVER_RSS),-f mongo-$(x).yml)

DK	:= docker
DC	:= docker-compose $(YAML_FILE_GROUPS)

DATA_SUF = $(shell date +"%Y.%m.%d.%H.%M.%S")

PROJ_NAME := $(shell basename $(CURDIR))

APP := mongo-router
CMD := bash

DK_EXEC := $(DK) exec -it $(APP)


# ####################################
# Dashboard AREA
# ####################################
status: status-port
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

bash:
	docker exec -it mongo-r1-s1 $(CMD)


# ####################################
# Status/Info AREA
# ####################################
status-port:
	sudo netstat -lntop | grep docker | sort -n -k4
	docker ps -a | grep mongo


# ####################################
# Init AREA
# 	init-dir: 
# ####################################
init-dir:
	# 创建数据目录
	# 创建数据目录(-dLf), 也可以直接-e来判存
	$(DC) config | grep ":rw$$" | grep -o " /[^:]*" | grep "/[^.]*$$" | grep -o "[^ ]*" | while read x; do \
		echo "verify dir/link $$x"; \
		[ -d "$$x" -o -L "$$x" -o -f "$$x" ] || mkdir -p "$$x"; \
		echo $$x; \
	done;
	# 给集群脚本文件加上读、执行权限
	find scripts -name "*" -exec chmod +r {} \;
	find scripts -name "*.sh" -exec chmod +x {} \;
	# log目录可写
	# [ ! -d ./log ] || chmod o+w ./log
	# [ ! -d "${XDC_MONGO_MONGOS_LOG}" ] || chmod o+w "${XDC_MONGO_MONGOS_LOG}"


# ####################################
# Test AREA
# ####################################
test-core:
	$(DK) cp ./scripts $(APP):/tmp
	$(DK_EXEC) mongo --eval 'quit(db.runCommand({ ping: 1 }).ok ? 0 : 2)'; echo $$?
	$(DK_EXEC) mongo /tmp/scripts/shard-status.js
	sleep 1
	$(DK_EXEC) mongo /tmp/scripts/test.js
	sleep 1
	$(DK_EXEC) mongo /tmp/scripts/shard-status.js


# ####################################
# Cluster AREA
# ####################################


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm
