# ####################################
# Git 操作 AREA
# ####################################


# 子库信息
HOST	 := $(shell hostname -s)
BRANCH := master
DC_CLUSTER  := docker-compose-cluster

SUB_DS_LIST := \
	ds-consul-$(DC_CLUSTER)=consul \
	ds-nacos-$(DC_CLUSTER)=nacos \
	ds-zk-$(DC_CLUSTER)=zk \
	ds-etcd-$(DC_CLUSTER)=etcd
SUB_DS_GIT_PREFIX := git@github.com:open-cookbook
SUB_DS_LOCAL_PREFIX := ds

SUB_GW_LIST := \
	gw-kong-$(DC_CLUSTER)=kong
SUB_GW_GIT_PREFIX := git@github.com:open-cookbook
SUB_GW_LOCAL_PREFIX := gw

SUB_MQ_LIST := \
	mq-nsq-$(DC_CLUSTER)=nsq \
	mq-nats-$(DC_CLUSTER)=nats \
	mq-kafka-$(DC_CLUSTER)=kafka \
	mq-rocketmq-$(DC_CLUSTER)=rocketmq \
	mq-rabbitmq-$(DC_CLUSTER)=rabbitmq
SUB_MQ_GIT_PREFIX := git@github.com:open-cookbook
SUB_MQ_LOCAL_PREFIX := mq

SUB_STORE_LIST := \
	mysql-gtid-$(DC_CLUSTER)=mysql-gtid \
	mongo-mongos-$(DC_CLUSTER)=mongo-mongos \
	codis-$(DC_CLUSTER)=codis \
	influxdb-$(DC_CLUSTER)=influxdb \
	elastic-$(DC_CLUSTER)=elastic
SUB_STORE_GIT_PREFIX := git@github.com:open-cookbook
SUB_STORE_LOCAL_PREFIX := store

SUB_HADOOP_LIST := \
	hadoop-hive-$(DC_CLUSTER)=hive \
	hadoop-hbase-$(DC_CLUSTER)=hbase \
	hadoop-core-$(DC_CLUSTER)=basic
SUB_HADOOP_GIT_PREFIX := git@github.com:open-cookbook
SUB_HADOOP_LOCAL_PREFIX := hadoop

SUB_MONITOR_LIST := \
	xiaomi-open-falcon-$(DC_CLUSTER)=open-falcon \
	prometheus-$(DC_CLUSTER)=prometheus
SUB_MONITOR_GIT_PREFIX := git@github.com:open-cookbook
SUB_MONITOR_LOCAL_PREFIX := monitor

SUB_MISC_LIST := \
	ctrip-apollo-$(DC_CLUSTER)=ctrip-apollo
SUB_MISC_GIT_PREFIX := git@github.com:open-cookbook
SUB_MISC_LOCAL_PREFIX := misc

SUB_REPO_LIST := repo-nexus-docker-compose=nexus
SUB_REPO_GIT_PREFIX := git@github.com:open-cookbook
SUB_REPO_LOCAL_PREFIX := repos

FCUT := cut -d '='


# ####################################
# git
# ####################################
gpom:
	git add .
	-git commit -am $(GUP_MSG)
	git push origin master
	git status
gfom:
	git pull origin master
gs: gstatus
ga:
	git add .


# ####################################
# Sub Git Tree AREA
# ####################################
gstatus:
	git status
	@echo SUB_DS=$(SUB_DS_LIST),$(SUB_DS_LOCAL_PREFIX),$(SUB_DS_GIT_PREFIX)
	@echo SUB_GW=$(SUB_GW_LIST),$(SUB_GW_LOCAL_PREFIX),$(SUB_GW_GIT_PREFIX)
	@echo SUB_MQ=$(SUB_MQ_LIST),$(SUB_MQ_LOCAL_PREFIX),$(SUB_MQ_GIT_PREFIX)
	@echo SUB_STORE=$(SUB_STORE_LIST),$(SUB_STORE_LOCAL_PREFIX),$(SUB_STORE_GIT_PREFIX)
	@echo SUB_REPO=$(SUB_REPO_LIST),$(SUB_REPO_LOCAL_PREFIX),$(SUB_REPO_GIT_PREFIX)
	@echo SUB_MISC=$(SUB_MISC_LIST),$(SUB_MISC_LOCAL_PREFIX),$(SUB_MISC_GIT_PREFIX)
	@echo SUB_MONITOR=$(SUB_MONITOR_LIST),$(SUB_MONITOR_LOCAL_PREFIX),$(SUB_MONITOR_GIT_PREFIX)
	@echo SUB_HADOOP=$(SUB_HADOOP_LIST),$(SUB_HADOOP_LOCAL_PREFIX),$(SUB_HADOOP_GIT_PREFIX)

ginit:
	$(call doSubListInit,$(SUB_DS_LIST),$(SUB_DS_LOCAL_PREFIX),$(SUB_DS_GIT_PREFIX))
	$(call doSubListInit,$(SUB_GW_LIST),$(SUB_GW_LOCAL_PREFIX),$(SUB_GW_GIT_PREFIX))
	$(call doSubListInit,$(SUB_MQ_LIST),$(SUB_MQ_LOCAL_PREFIX),$(SUB_MQ_GIT_PREFIX))
	$(call doSubListInit,$(SUB_STORE_LIST),$(SUB_STORE_LOCAL_PREFIX),$(SUB_STORE_GIT_PREFIX))
	$(call doSubListInit,$(SUB_REPO_LIST),$(SUB_REPO_LOCAL_PREFIX),$(SUB_REPO_GIT_PREFIX))
	$(call doSubListInit,$(SUB_MISC_LIST),$(SUB_MISC_LOCAL_PREFIX),$(SUB_MISC_GIT_PREFIX))
	$(call doSubListInit,$(SUB_MONITOR_LIST),$(SUB_MONITOR_LOCAL_PREFIX),$(SUB_MONITOR_GIT_PREFIX))
	$(call doSubListInit,$(SUB_HADOOP_LIST),$(SUB_HADOOP_LOCAL_PREFIX),$(SUB_HADOOP_GIT_PREFIX))

gpull: gfom ginit
	$(call doSubListPull,$(SUB_DS_LIST),$(SUB_DS_LOCAL_PREFIX),$(SUB_DS_GIT_PREFIX))
	$(call doSubListPull,$(SUB_GW_LIST),$(SUB_GW_LOCAL_PREFIX),$(SUB_GW_GIT_PREFIX))
	$(call doSubListPull,$(SUB_MQ_LIST),$(SUB_MQ_LOCAL_PREFIX),$(SUB_MQ_GIT_PREFIX))
	$(call doSubListPull,$(SUB_STORE_LIST),$(SUB_STORE_LOCAL_PREFIX),$(SUB_STORE_GIT_PREFIX))
	$(call doSubListPull,$(SUB_REPO_LIST),$(SUB_REPO_LOCAL_PREFIX),$(SUB_REPO_GIT_PREFIX))
	$(call doSubListPull,$(SUB_MISC_LIST),$(SUB_MISC_LOCAL_PREFIX),$(SUB_MISC_GIT_PREFIX))
	$(call doSubListPull,$(SUB_MONITOR_LIST),$(SUB_MONITOR_LOCAL_PREFIX),$(SUB_MONITOR_GIT_PREFIX))
	$(call doSubListPull,$(SUB_HADOOP_LIST),$(SUB_HADOOP_LOCAL_PREFIX),$(SUB_HADOOP_GIT_PREFIX))

gpush: gpom ginit
	$(call doSubListPush,$(SUB_DS_LIST),$(SUB_DS_LOCAL_PREFIX),$(SUB_DS_GIT_PREFIX))
	$(call doSubListPush,$(SUB_GW_LIST),$(SUB_GW_LOCAL_PREFIX),$(SUB_GW_GIT_PREFIX))
	$(call doSubListPush,$(SUB_MQ_LIST),$(SUB_MQ_LOCAL_PREFIX),$(SUB_MQ_GIT_PREFIX))
	$(call doSubListPush,$(SUB_STORE_LIST),$(SUB_STORE_LOCAL_PREFIX),$(SUB_STORE_GIT_PREFIX))
	$(call doSubListPush,$(SUB_REPO_LIST),$(SUB_REPO_LOCAL_PREFIX),$(SUB_REPO_GIT_PREFIX))
	$(call doSubListPush,$(SUB_MISC_LIST),$(SUB_MISC_LOCAL_PREFIX),$(SUB_MISC_GIT_PREFIX))
	$(call doSubListPush,$(SUB_MONITOR_LIST),$(SUB_MONITOR_LOCAL_PREFIX),$(SUB_MONITOR_GIT_PREFIX))
	$(call doSubListPush,$(SUB_HADOOP_LIST),$(SUB_HADOOP_LOCAL_PREFIX),$(SUB_HADOOP_GIT_PREFIX))


# ####################################
# Git Sub Tree AREA
# ####################################
define doSubListInit
	for xy in $(1); do \
		x=`echo "$${xy}" | $(FCUT) -f1`; \
		y=`echo "$${xy}" | $(FCUT) -f2`; \
		grep "$$x.git" .git/config >/dev/null || git remote add -f $$x $(3)/$$x.git;    \
		[ ! -d "$(2)/$$y" ] && git subtree add --prefix=$(2)/$$y $$x $(BRANCH) --squash || >/dev/null; \
	done;
endef

define doSubListPull
	for xy in $(1); do \
		x=`echo "$${xy}" | $(FCUT) -f1`; \
		y=`echo "$${xy}" | $(FCUT) -f2`; \
		git subtree pull --prefix=$(2)/$$y $$x $(BRANCH) --squash -m $(GUP_MSG); \
	done;
endef

define doSubListPush
	for xy in $(1); do \
		x=`echo "$${xy}" | $(FCUT) -f1`; \
		y=`echo "$${xy}" | $(FCUT) -f2`; \
		git subtree push --prefix=$(2)/$$y $$x $(BRANCH) || >/dev/null; \
	done;
endef
