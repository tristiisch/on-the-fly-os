all: verif init build deploy

verif:
	@packer validate .

init:
	@packer init -upgrade .

build:
	@packer build -timestamp-ui -warn-on-undeclared-var .

delete:
	@vagrant box remove packer_DEBIAN-12_vmware.box -f || if errorlevel 1 exit 0

deploy-install:
	@vagrant plugin install --timestamp vagrant-vmware-desktop

deploy-update:
	@vagrant plugin update --timestamp vagrant-vmware-desktop

deploy:
	@vagrant up --timestamp --provider vmware_desktop

deploy-delete:
	@vagrant destroy --timestamp --force

connect:
	@vagrant ssh

re: delete deploy-delete all
