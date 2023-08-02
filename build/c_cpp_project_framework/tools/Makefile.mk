filename:=$(shell pwd)
filedir=$(shell basename $(filename))

CROSS_DIR ?= `pwd`/../../toolchain/toolchain-arm_cortex-a15+neon-vfpv4_gcc-10.2.0_glibc_eabi/bin
CROSS ?= arm-openwrt-linux-
DEFAULTS_UNITV3=`pwd`/../../tools/config_defaults_unitv3.mk
PUSH_FILE?=dist
PUSH_DIR?=/root
PUSH_URL?=192.168.12.1
MSSHF?=-o StrictHostKeychecking=no
# SSH_PASSWORLD?=nihao
# CC = $(CROSS)gcc
# CXX = $(CROSS)g++

define foo2
    @echo "my name is $(0)"
    @echo "param => $(1)"
endef




target:
	python3 project.py build
	@if [ -f "./build_after.sh" ] ; then ./build_after.sh;fi;

release:
	python3 project.py build --release
	@if [ -f "./build_after.sh" ] ; then ./build_after.sh;fi;

verbose:
	python3 project.py build --verbose
	@if [ -f "./build_after.sh" ] ; then ./build_after.sh;fi;

menuconfig:
	python3 project.py menuconfig

run:
	./dist/${filedir}

push_run:
	make push
	scp $(MSSHF) root@$(PUSH_URL) "./dist/${filedir}"

clean:
	python3 project.py clean
distclean:
	make clean
	$(RM) -r build/ dist
	$(RM) -r .config.mk

arm:
	make set_arm
	make target

set_arm:
	python3 project.py --toolchain $(CROSS_DIR) --toolchain-prefix $(CROSS) config
	TMPFILE=`mktemp`;cat .config.mk $(DEFAULTS_UNITV3) > $${TMPFILE} ; awk '!a[$$0]++' $${TMPFILE} > .config.mk ; rm $${TMPFILE}
	

push:
	if [ "$(SSH_PASSWORLD)" != "" ] ; then sshpass -p "$(SSH_PASSWORLD)" scp $(MSSHF) -r $(PUSH_FILE) root@$(PUSH_URL):$(PUSH_DIR) ; else  scp $(MSSHF) -r $(PUSH_FILE) root@$(PUSH_URL):$(PUSH_DIR) ; fi;

shell:
	if [ "$(SSH_PASSWORLD)" != "" ] ; then sshpass -p "$(SSH_PASSWORLD)" ssh $(MSSHF) root@$(PUSH_URL) ; else ssh $(MSSHF) root@$(PUSH_URL) ; fi;
	