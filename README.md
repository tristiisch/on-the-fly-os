# On-The-Fly-OS

**On-The-Fly-OS** automates the creation of virtual machine images using **Packer**, streamlines VM management with **Vagrant**, and leverages **VMWare** for virtualization. It also integrates tools like **Ansible** and **Docker** for provisioning and containerized environments.

## Key Features

- **Automated Image Creation**: Easily generate VM images for Debian and Windows environments using **Packer** templates.
- **Efficient VM Management**: Use **Vagrant** to simplify virtual machine setup, configuration, and lifecycle management.
- **Seamless Virtualization**: Run and test VMs with **VMWare** for robust virtualization support.
- **Extended Functionality**: Utilize **Ansible** for automated provisioning and **Docker** for containerized environments on Debian.

## Prerequisites

To run this project, ensure you have the following installed:

- **Packer**: For building VM images.
- **Vagrant**: For managing virtual environments.
- **VMWare**: For virtual machine management and testing.
- **Make**: To simplify building and managing the project.
- **Ansible** (optional): For automating the provisioning of virtual machines.
- **Docker** (optional): For deploying containerized services on Debian.

## Getting Started

### 1. Navigate to the Desired Environment:
   - For Debian (Debian 12):  
     ```bash
     cd debian/DEBIAN-12
     ```
   - For Ansible configuration on Debian:  
     ```bash
     cd debian/Ansible
     ```
   - For Docker on Debian:  
     ```bash
     cd debian/Docker
     ```
   - For Windows Server 2022:  
     ```bash
     cd windows/WIN-S2022
     ```

### 2. Build & Deploy
   In the respective directory, run:
   ```bash
   make
   ```

### 3. Connect to Linux VMs via SSH
   For Debian-based environments, use:
   ```bash
   make connect
   ```

## Contributing

We welcome contributions! Feel free to open issues or submit pull requests to enhance this project. For major changes, please open an issue to discuss your ideas first.
