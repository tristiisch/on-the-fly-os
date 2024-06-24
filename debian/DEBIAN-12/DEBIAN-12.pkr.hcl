// Packer configuration for building a VMware virtual machine template.
packer {
  required_version = ">= 1.10.0"

  required_plugins {
    vmware = {
      version = ">= 1.0.11"
      source = "github.com/hashicorp/vmware"
    }
    vagrant = {
      version = ">= 1.1.2"
      source = "github.com/hashicorp/vagrant"
    }
  }
}

locals {
  // Default VM settings
  vmx_data = {
    // Sync time between Host & Guest
    "tools.synctime" = false
    // Usage of keyboard enhancements
    "mks.keyboardFilter" = "allow"
    "sata1.present": true
  # Interface name will be ens33
    // "ethernet0.pciSlotNumber": "33"
  }
  // If UEFI is enabled, override default settings
  uefi_settings = {
    // UEFI Boot
    "firmware" = "efi"
    // Enable secure UEFI Boot
    "uefi.secureBoot.enabled" = false
  }
  final_vmx_data = var.isUefi ? merge(local.vmx_data, local.uefi_settings) : local.vmx_data

  script_files = ["${var.floppyInitPath}/preseed.cfg"]
  final_files = local.script_files

  boot_keys = [
      "e<down><down><down><wait>",
      "<end>priority=critical ", "auto=true ", "preseed/cdrom=/setup/preseed.cfg", "<leftCtrlOn>x<leftCtrlOff><wait>",
      "<wait12>",
      "<leftCtrlOn><leftAltOn><f2><leftAltOff><leftCtrlOff>", "<enter>mkdir /media/cidata<enter>", "mount /dev/sr1 /media/cidata<enter><wait>",
      "<leftCtrlOn><leftAltOn><f5><leftAltOff><leftCtrlOff>", "<wait30>file:///media/cidata/setup/preseed.cfg<enter><wait>",
      "<wait10>", "<leftCtrlOn><leftAltOn><f2><leftAltOff><leftCtrlOff>", "umount /media/cidata<enter>", "eject /dev/sr1<enter><wait>",
      "<leftCtrlOn><leftAltOn><f5><leftAltOff><leftCtrlOff>"
    ]

  boot_keys_waiting = "3s"
}

source "vmware-iso" "DEBIAN-12" {
  vm_name = "DEBIAN-12"
  guest_os_type = "debian12-64"
  version = "21"
  snapshot_name = "Empty"

  // VM configuration: CPU, RAM, disk, network
  cpus = "${var.vmCpuSock}"
  cores = "${var.vmCpuCore}"
  memory = "${var.vmMemSize}"

  disk_size = "${var.vmDiskSize}"
  disk_adapter_type = "nvme"
  disk_type_id = 0

  // network = "VMnet8"
  network = "nat"
  network_adapter_type = "e1000e"

  // ISO source for installation and checksum
  iso_url = "${var.vmISO}"
  iso_checksum = "${var.vmISOHash}"

  // CDRom drive containing preseed file
  cd_files = ["setup"]
  cd_label = "cidata"

  // SSH connection
  communicator = "ssh"
  ssh_port = 22
  insecure_connection = "true"
  ssh_username = "${var.adminUser}"
  ssh_password = "${var.adminPassword}"
  ssh_file_transfer_method = "sftp"
  ssh_timeout = "30m"

  // Install VMWare Tools
  tools_upload_flavor="linux"

  // Remove all existing network interfaces
  vmx_remove_ethernet_interfaces = true
  vmx_data = local.final_vmx_data
  vmx_data_post = {
    "sata0.present" = false
    "sata1.present" = false
  }

  boot_command = local.boot_keys
  boot_wait = local.boot_keys_waiting

  // Command to shut down the system
  // shutdown_timeout = "1h"
  shutdown_command = "sudo shutdown -h now"
  skip_compaction = false
}

build {
  sources = ["source.vmware-iso.DEBIAN-12"]

  post-processor "vagrant" {
    keep_input_artifact = false
    output = "packer_{{.BuildName}}_{{.Provider}}.box"
    provider_override = "vmware"
    compression_level = 9
  }
}
