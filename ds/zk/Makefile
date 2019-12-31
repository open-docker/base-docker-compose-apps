# ZooKeeper 集群环境

# ####################################
#　机房 AREA
# ####################################
# 深圳	:= docker-compose -f sz-zk.yml 


# ####################################
# Config AREA
# ####################################
SVC_HOST := $(shell hostname -a)

DK	:= docker
DC	:= docker-compose -f sz-zk.yml 
DK_EXEC := docker exec -it

DATA_SUF = $(shell date +"%Y.%m.%d.%H.%M.%S")

PROJ_NAME := $(shell basename $(CURDIR))-server

EXEC := bash

-include ./.env
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


# ####################################
# Test AREA
# ####################################
test-core:



# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm
