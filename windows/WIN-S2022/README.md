# VMWare template - Windows Server 2022

## Packer

### Install Plugins

```sh
packer init .
```

### Build Box

```sh
packer build .
```

## Vagrant

```sh
vagrant up --provider vmware_workstation
```
