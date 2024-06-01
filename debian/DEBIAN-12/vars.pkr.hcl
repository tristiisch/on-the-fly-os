variable "vmCpuSock" {
  type = string
  default = "1"
  description = ""
}

variable "vmCpuCore" {
  type = string
  default = "2"
}

variable "vmMemSize" {
  type = string
  default = "3072"
}

variable "vmISO" {
  type = string
  description = "Path to .iso file"
}

variable "vmISOHash" {
  type = string
  description = "Hash of .iso file, in format ALGO:XXXXXXXXX, ex: SHA256:XXXXXXXXX"
}

variable "vmDiskSize" {
  type = string
  default = "32768"
}

variable "floppyInitPath" {
  type = string
  default = "./setup"
}

variable "adminUser" {
  type = string
  default = "Administrator"
}

variable "adminPassword" {
  type = string
}

variable "isUefi" {
  type = bool
  default = true
}
