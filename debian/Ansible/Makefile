BASE_BOX_MAKEFILE	:=	../DEBIAN-12
VAGRANT_ARGS		:=	--timestamp --color
VAGRANT_PLUGIN		:=	vagrant-vmware-desktop
VAGRANT_PROVIDER	:=	vmware_desktop

RULE_WITH_ARGS := start provision stop delete connect
ifeq ($(RULE_WITH_ARGS),$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif

all: start

re: delete all

re-all: delete build-delete build-init build all

build-init:
	@$(MAKE) -C $(BASE_BOX_MAKEFILE) init

build:
	@$(MAKE) -C $(BASE_BOX_MAKEFILE) build

build-delete:
	@$(MAKE) -C $(BASE_BOX_MAKEFILE) delete

plugin-install:
	@vagrant plugin install $(VAGRANT_ARGS) $(VAGRANT_PLUGIN)

plugin-update:
	@vagrant plugin update $(VAGRANT_ARGS) $(VAGRANT_PLUGIN)

start:
	@vagrant up $(VAGRANT_ARGS) $(RUN_ARGS)

provision:
	@vagrant up $(VAGRANT_ARGS) --provider $(VAGRANT_PROVIDER) $(RUN_ARGS)

stop:
	@vagrant halt $(VAGRANT_ARGS) $(RUN_ARGS)

delete:
	@vagrant destroy $(VAGRANT_ARGS) --force $(RUN_ARGS)

connect:
	@vagrant ssh $(RUN_ARGS)
