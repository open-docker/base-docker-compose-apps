# ####################################
# Name: MySQL 集群环境
# FileVersion: 20191113
# ####################################


# ####################################
# Config AREA
# ####################################
SVC_HOST := $(shell hostname -a)
SERVER_GROUPS := g1 g2
SLAVE_NAMES := s2 s3

include ./.env
-include ../../yh-prod.env

SERVER_RSS := g1 g2
YAML_FILE_GROUPS := $(foreach x,$(SERVER_RSS),-f mysql-$(x).yml)

DK	:= docker
DC	:= docker-compose $(YAML_FILE_GROUPS)
DK_EXEC := docker exec -it

DATA_SUF = $(shell date +"%Y.%m.%d.%H.%M.%S")

PROJ_NAME := $(shell basename $(CURDIR))

CMD := bash
SG  := g1
SS  := s1


ifndef XDC_MYSQL_GTID_BACKUP
	XDC_MYSQL_GTID_BACKUP=${HOME}/backup/mysql-gtid
endif


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
	docker exec -it mysql-$(SG)-$(SS) $(CMD)
bash: sh

test: test-core


# ####################################
# Status/Info AREA
# ####################################
status-port:
	sudo netstat -lntop | grep docker | sort -n -k4
	docker ps -a | grep mysql


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
	# 给集群配置文件加上读权限，否则会因用户id不同，导致配置读取不生效
	find conf -name "*.cnf" -exec chmod +r {} \;
	# log目录可写
	[ ! -d ./log ] || chmod o+w ./log
	[ ! -d "${XDC_MYSQL_GTID_LOG}" ] || chmod o+w "${XDC_MYSQL_GTID_LOG}"


# ####################################
# Debug AREA
# ####################################
start-g1-fg:
	docker-compose -f mysql-g1.yml up
start-g1:
	docker-compose -f mysql-g1.yml up -d
stop-g1:
	docker-compose -f mysql-g1.yml down


# ####################################
# Test AREA
# ####################################
test-core:
	echo XDC_MYSQL_GTID_BACKUP=${XDC_MYSQL_GTID_BACKUP}


# ####################################
# Cluster AREA
# ####################################
post-init-cluster: cluster-add-repl-account
cluster-add-repl-account:
	# 为主节点添加备份用户
	for x in $(SERVER_GROUPS); do \
		$(DK) exec -it mysql-$${x}-s1 mysql -uroot -p${MYSQL_MASTER_PASSWD} \
			-e "CREATE USER '${MYSQL_REPL_NAME}'@'%' IDENTIFIED BY '${MYSQL_REPL_PASSWD}' REQUIRE SSL;" \
			-e "GRANT REPLICATION SLAVE ON *.* TO '${MYSQL_REPL_NAME}'@'%';" \
			-e "flush privileges;" ; \
	done;

cluster-start-slave:
	# 从库使用主库的备份账号连接主库，并开始备份mysql-$${x}-s1
	for x in $(SERVER_GROUPS); do \
		for y in $(SLAVE_NAMES); do \
			$(DK) exec -it mysql-$${x}-$${y} mysql -uroot -p${MYSQL_SLAVE_PASSWD} \
				-e "CHANGE MASTER TO MASTER_HOST='mysql-$${x}-s1', MASTER_PORT=3306, MASTER_USER='${MYSQL_REPL_NAME}', MASTER_PASSWORD='${MYSQL_REPL_PASSWD}', MASTER_AUTO_POSITION=1, MASTER_SSL=1;" \
				-e "START SLAVE;" ; \
		done; \
	done;

cluster-status-master:
	for x in $(SERVER_GROUPS); do \
		$(DK) exec -it mysql-$${x}-s1 mysql -uroot -p${MYSQL_MASTER_PASSWD} -e "show variables like '%gtid%';"; \
	done;

cluster-status-slave:
	for x in $(SERVER_GROUPS); do \
		for y in $(SLAVE_NAMES); do \
			$(DK) exec -it mysql-$${x}-$${y} mysql -uroot -p${MYSQL_SLAVE_PASSWD} -e "SHOW SLAVE STATUS\G"; \
		done; \
	done;

cluster-stop-slave:
	for x in $(SERVER_GROUPS); do \
		for y in $(SLAVE_NAMES); do \
			$(DK) exec -it mysql-$${x}-$${y} mysql -uroot -p${MYSQL_SLAVE_PASSWD} -e "STOP SLAVE"; \
		done; \
	done;

cluster-reset-slave:
	for x in $(SERVER_GROUPS); do \
		for y in $(SLAVE_NAMES); do \
			$(DK) exec -it mysql-$${x}-$${y} mysql -uroot -p${MYSQL_SLAVE_PASSWD} -e "RESET SLAVE"; \
		done; \
	done;


# ####################################
# Backup AREA
# ####################################
backup:
	[ -d "${XDC_MYSQL_GTID_BACKUP}" ] || mkdir -p "${XDC_MYSQL_GTID_BACKUP}"
	for x in $(SERVER_GROUPS); do \
		$(DK) exec -it mysql-$${x}-s1 mysqldump -uroot -p${MYSQL_MASTER_PASSWD} \
			--all-databases --triggers --routines --events 2>/dev/null > ${XDC_MYSQL_GTID_BACKUP}/mysql-$${x}-s1-${DATA_SUF}.sql; \
		$(DK) exec -i mysql-$${x}-s1 mysql -uroot -p${MYSQL_MASTER_PASSWD} \
			-se'show databases;' 2>/dev/null | grep "_" | grep -v "_schema" | \
			xargs $(DK) exec -i mysql-$${x}-s1 mysqldump -uroot -p${MYSQL_MASTER_PASSWD} \
			--databases --set-gtid-purged=OFF 2>/dev/null > ${XDC_MYSQL_GTID_BACKUP}/mysql-$${x}-s1-core-${DATA_SUF}.sql; \
	done;
	ls -lhrt "${XDC_MYSQL_GTID_BACKUP}"


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm
