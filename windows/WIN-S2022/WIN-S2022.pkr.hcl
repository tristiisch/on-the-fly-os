// Packer configuration for building a VMware virtual machine template.
packer {
  required_version = ">= 1.7.0"

  required_plugins {
    vmware = {
      version = ">= 1.0.0"
      source = "github.com/hashicorp/vmware"
    }
    vagrant = {
      version = "~> 1"
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
  }
  // If UEFI is enabled, override default settings
  uefi_settings = {
    // UEFI Boot
    "firmware" = "efi"
    // Enable secure UEFI Boot
    "uefi.secureBoot.enabled" = true
  }
  final_vmx_data = var.isUefi ? merge(local.vmx_data, local.uefi_settings) : local.vmx_data

  script_files = ["${var.floppyInitPath}/*"]
  eufi_files = ["${var.floppyInitPath}/EUFI/*"]
  legacy_files = ["${var.floppyInitPath}/LEGACY/*"]
  final_files = var.isUefi ? concat(local.script_files, local.eufi_files) : concat(local.script_files, local.legacy_files)

  boot_keys = []
  // UEFI boot configuration
  boot_keys_uefi = ["<enter>", "<wait1>", "<enter>", "<wait1>", "<enter>", "<wait1>", "<enter>", "<wait1>", "<enter>"]
  final_boot_keys = var.isUefi ? local.boot_keys_uefi : local.boot_keys

  boot_keys_waiting = "10s"
  // UEFI boot configuration
  boot_keys_waiting_uefi = "1s"
  final_boot_keys_waiting = var.isUefi ? local.boot_keys_waiting_uefi : local.boot_keys_waiting
}

// VMware ISO source configuration for Windows Server 2022.
source "vmware-iso" "WIN-S2022" {
  // Name of the VM and guest operating system (Windows Server 2022)
  vm_name = "WIN-S2022"
  guest_os_type = "windows2019srvnext-64"
  version = 21
  snapshot_name = "Empty"

  // VM configuration: CPU, RAM, disk, network
  cpus = "${var.vmCpuSock}"
  cores = "${var.vmCpuCore}"
  memory = "${var.vmMemSize}"

  disk_size = "${var.vmDiskSize}"
  disk_adapter_type = "nvme"
  disk_type_id = 0

  network = "nat"
  network_adapter_type = "e1000e"

  // ISO source for installation and checksum (Get-FileHash)
  iso_url = "${var.vmISO}"
  iso_checksum = "${var.vmISOHash}"

  // Floppy drive containing scripts (will be mounted as A:\)
  floppy_files = local.final_files
  floppy_label = "floppy"

  // WINRM connection
  communicator = "winrm"
  winrm_port = 5985
  insecure_connection = "true"
  winrm_username = "${var.adminUser}"
  winrm_password = "${var.adminPassword}"

  // Install VMWare Tools
  // tools_upload_flavor="windows"

  // Remove all existing network interfaces
  vmx_remove_ethernet_interfaces = true

  vmx_data = local.final_vmx_data

  boot_command = local.final_boot_keys
  boot_wait = local.final_boot_keys_waiting

  // Command to shut down the system (here, we perform a SYSPREP before shutdown)
  // Shutdown only: shutdown_command = "shutdown /s /t 30 /f"
  shutdown_command = "C:\\Windows\\system32\\Sysprep\\sysprep.exe /generalize /oobe /shutdown /unattend:a:\\sysprep-autounattend.xml"
  shutdown_timeout = "1h"
}

// Build configuration
build {
  // Specify the source to build
  sources = ["source.vmware-iso.WIN-S2022"]

  // Setup settings at VM startup
  provisioner "powershell" {
    script = "${var.floppyInitPath}/setup-at-startup.ps1"
  }

  // Initiate a machine restart
  provisioner "windows-restart" {
    restart_timeout = "10m"
  }

  // Export as a Vagrant box
  post-processor "vagrant" {
    keep_input_artifact = false
    output = "packer_{{.BuildName}}_{{.Provider}}.box"
    provider_override = "vmware"
  }
}
