all: verif init build deploy

verif:
	@packer validate .

init:
	@packer init -upgrade .

build:
	@packer build -timestamp-ui -warn-on-undeclared-var .

deploy-install:
	@vagrant plugin install --timestamp vagrant-vmware-desktop

deploy-update:
	@vagrant plugin update --timestamp vagrant-vmware-desktop

deploy:
	@vagrant up --timestamp --provider vmware_desktop

deploy-ask:
	@set "ASK=true" && vagrant up --timestamp --provider vmware_desktop
