INVENTORY := inventory.yml
DEFAULT_GROUP := all

play-chrony:
	ansible-playbook -i $(INVENTORY) ./playbook/chrony.yml

ping:
	ansible -i $(INVENTORY) $(DEFAULT_GROUP) -m ping

uptime:
	# ansible -i $(INVENTORY) $(DEFAULT_GROUP) -m command -a uptime
	ansible -i $(INVENTORY) $(DEFAULT_GROUP) -m raw -a uptime

gather-facts:
	ansible -i $(INVENTORY) $(DEFAULT_GROUP) -m setup

dry-run:
	ansible -i $(INVENTORY) $(DEFAULT_GROUP) --check --diff -m ping

print-docker-version:
	ansible -i $(INVENTORY) docker -m debug -a 'msg={{ docker_version }}'

graph:
	@ansible-inventory -i $(INVENTORY) --graph --vars