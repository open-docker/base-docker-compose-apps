# ####################################
# Name: os-c7
# FileVersion: 20191127
# ####################################


DK	:= docker
DC	:= docker-compose
DK_EXEC := docker exec -it -u foobar
SELF_DO := make --no-print-directory -C .

DATA_SUF = $(shell date +"%Y.%m.%d.%H.%M.%S")

include ./.env
-include ../../yh-prod.env

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

bash: sh
sh: sh1
sh1:
	$(DK_EXEC) consul-01 $(CMD)
sh2:
	$(DK_EXEC) consul-02 $(CMD)
sh3:
	$(DK_EXEC) consul-03 $(CMD)

rebuild-then-start: stop init-dir
	$(DK) images | grep -q $(OS_IMG_TAG) && $(DK) rmi $(OS_IMG_TAG) || true
	$(DC) up --build -d


# ####################################
# Cluster AREA
# ####################################
cluster: init-cluster status-cluster query-cluster
init-cluster:
	$(SELF_DO) sh2 CMD="make -C /demo/cluster join-cluster"
	$(SELF_DO) sh3 CMD="make -C /demo/cluster join-cluster"
status-cluster:
	$(SELF_DO) sh3 CMD="make -C /demo/cluster status"
query-cluster:
	$(SELF_DO) sh2 CMD="make -C /demo/cluster query"


# ####################################
# KV AREA
# ####################################
kv: kv-put-get--update kv-get kv-delete
kv-put-get--update:
	$(SELF_DO) sh1 CMD="consul kv put name boxu"
	$(SELF_DO) sh2 CMD="consul kv put email boxu@yvhai.com"
	$(SELF_DO) sh1 CMD="consul kv get email"
	$(SELF_DO) sh3 CMD="consul kv put email bbxyard@gmail.com"
	$(SELF_DO) sh2 CMD="consul kv get email"
	$(SELF_DO) sh2 CMD='consul kv put ref/url/1 "https://www.jianshu.com/p/7d20dc58c9fc"'
	$(SELF_DO) sh3 CMD="consul kv get ref/url/1"
kv-get:
	$(SELF_DO) sh3 CMD="consul kv get name"
	$(SELF_DO) sh3 CMD="consul kv get email"
	$(SELF_DO) sh3 CMD="consul kv get ref/url/1"
kv-delete:
	$(SELF_DO) sh3 CMD="consul kv delete name"
	$(SELF_DO) sh3 CMD="consul kv delete email"
	$(SELF_DO) sh3 CMD="consul kv delete -recurse ref/url/1"


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

download:
	for x in `cat stub/downloads/url.lst | grep -v "^#"`; do \
		wget -P stub/downloads $$x; \
	done;


# ####################################
# Utils AREA
# ####################################
rm-img:
	make --no-print-directory -C . stop
	docker rmi $(CONSUL_IMG_TAG)
clean:
	rm -rvf log/* *.bak
