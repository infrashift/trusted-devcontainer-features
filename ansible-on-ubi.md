## Prerequisites

install pip3
`dnf install -y python3-pip`

`adduser ansible`

`id ansible`

`dnf install sudo`

`cp /etc/sudoers /root/sudoers.bak`

edit `/etc/sudoers`
comment out `%wheel ALL=(ALL)       ALL` and uncomment `%wheel ALL=(ALL)       NOPASSWD: ALL`
```
## Allows people in group wheel to run all commands
#%wheel ALL=(ALL)       ALL

## Same thing without a password
 %wheel ALL=(ALL)       NOPASSWD: ALL

```
NOTE: an automated way to do ^^^ is 

```
sudo sed -i 's/^%wheel[[:space:]]\+ALL=(ALL)[[:space:]]\+ALL$/#\ %wheel ALL=(ALL) ALL/; s/^#\ %wheel[[:space:]]\+ALL=(ALL)[[:space:]]\+NOPASSWD:[[:space:]]\+ALL$/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
```

***********************************
***********************************
install pip3
`dnf install -y python3-pip`

`adduser ansible`

`id ansible`

`su - ansible`

`pip3 install -y ansible`


***********************************
***********************************


`adduser vscode`

`id vscode`

`su - ansible`

# https://pypi.org/project/ansible-core/
`pip install ansible-core --user`

```
mkdir -p ansible-role-git/tasks
mkdir ansible-role-git/defaults
mkdir ansible-role-git/meta
```

```
# ansible-role-git/tasks/main.yml
---
- name: Configure UBI-9-BaseOS repository
  ansible.builtin.yum_repository:
    name: ubi-9-baseos-rpms
    description: Red Hat Universal Base Image 9 (RPMs) - BaseOS
    baseurl: https://cdn-ubi.redhat.com/content/public/ubi/dist/ubi9/9/$basearch/baseos/os
    enabled: yes
    gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
    gpgcheck: yes
  when: ansible_distribution == 'RedHat' or ansible_distribution == 'CentOS'

- name: Install Git
  ansible.builtin.package:
    name: git
    state: present
```

```
# ansible-role-git/defaults/main.yml
---
# No default variables are needed for this role

```

```
# ansible-role-git/meta/main.yml
---
galaxy_info:
  author: Your Name
  description: Ansible Role to install Git on RHEL systems
  company: Your Company
  license: MIT
  min_ansible_version: 2.9
  platforms:
  - name: EL
    versions:
    - 7
    - 8
    - 9
  galaxy_tags:
    - git
    - rhel
    - linux
    - source-control

dependencies: []
```

```
# inventory.yml
---
all:
  children:
    rhel:
      hosts:
        localhost:
          ansible_connection: local
```

```
# git-install.yml
---
- name: Install Git on RHEL systems
  hosts: rhel
  become: yes
  roles:
    - ansible-role-git
```

Run playbook as root

```
ansible-playbook -i /home/ansible/inventory.yml /home/ansible/git-install.yml
```

--------------------------------
------------------------------
git-lfs feature
-------------------------------
---------------------------------
cd .devcontainer
mkdir git-lfs-feature
cd git-lfs-feature
mkdir -p ansible-role-git-lfs/tasks
mkdir ansible-role-git-lfs/defaults
mkdir ansible-role-git-lfs/meta