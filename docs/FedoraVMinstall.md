# Fedora VM Install for SA Work

## VirtualBox config

* General -> Advanced -> Shared Clipboard (Bidirectional)
* System -> Motherboard -> Base Memory (4096 MB)*
* System -> Motherboard -> Boot Order (deselect Floppy)
* System -> Processor -> Processors (2)*
* System -> Processor -> Extended Features (select Enable PAE/NX)
* System -> Acceleration -> Paravirtualization Interface (KVM)
* System -> Acceleration -> Hardware Virtulization (select Enable VT-x/AMD-V & Enable Nested Paging)
* Display -> Screen -> Video Memory (64 MB)
* Display -> Screen -> Acceleration (select Enable 3D)
* Display -> Remote Display -> Enable Server (deselect)
* Display -> Video Capture -> Enable Video Capture (deselect)
* Storage -> Storage Tree -> (remove cd-rom & IDE, select Use Host I/O Cache)
* Storage -> Stroage Tree -> on SATA controller, create (use vmdk):
    * base OS disk (64 GB Dynamic, check solid-state)
    * cd-rom 
* Audio -> (deslect Enable Audio)
* Network -> Adapter 1 -> Attach to NAT Network
* Network -> Adapter 1 -> Advanced -> set Adapter Type to Paravirtualized Network
* Shared Folders -> Machive Folders -> add home directory as auto-mount, make permanent

(*) Adjust to resource availablability

## Install OS

### Base

Get boot ISO.

Manually configure disk layout (Use LVM thin provision):

    /boot (disk 1)    ext4  1.0 Gi
    /     (VG fedora) xfs  10.0 Gi
    /var  (VG fedora) xfs   3.0 Gi
    swap  (VG fedora) swap  2.0 Gi
    /home (VG fedora) xfs   5.0 Gi

NOTE: You should end w/~36GiB available from a total of 64GiB.

Set root password.

Create initial user with admin access (recommend use orgs username).

### Prepare

    echo NAMEME >/etc/hostname && hostname NAMEME
    dnf -y install etckeeper etckeeper-dnf
    git config --global user.email "root@NAMEME.localhost" && git config --global user.name "root"
    etckeeper init && etckeeper commit "initial commit"

If system looks good, poweroff and make a backup.

NOTE: If there is a problem with ssl verification, see below.

### Fix ssl issues in local vm's 

One way to deal with SSL verification problems is to turn it off:

    echo sslverify=false >> /etc/dnf/dnf.conf

The other is to get organizations certs, copy them to /etc/pki/ca-trust/source/anchors/, and execute:

    update-ca-trust extract

### Install VBoxAdditions

    dnf -y install kernel-devel-`uname -r` dkms
    mount /dev/sr0 /mnt && mkdir /root/vbox && cp -R /mnt/* /root/vbox/ && umount /mnt
    cd /root/vbox && ./VBoxLinuxAdditions.run
    reboot

### Start slimming the box

Note: This list comes from the standard Fedora 24 install ISO. 

    dnf -y remove firefox foomatic fpaste b43* thai-* sil-* navr-* lohit-* fedora-release-workstation fedora-user-agent-chrome fedora-productimg-workstation 
    dnf -y remove NetworkManager-[a-co-z]* PackageKit* alsa-[pu]* anaconda* bluez* cups* evolution* evince* fprintd ghostscript glusterfs gnome* hyperv* ipw* iw* libreoffice* pulseaudio* atmel-firmware libertas-usb8388-firmware zd1211-firmware gdm usb_modeswitch *vnc* wireless-tools usbmuxd usbredir spice* shotwell 
    dnf -y remove xorg-x11-drv-ati xorg-x11-drv-nouveau xorg-x11-drv-vmware xorg-x11-drv-wacom xorg-x11-drv-synaptics xorg-x11-drv-intel xorg-x11-drv-libinput xorg-x11-drv-qxl xorg-x11-drv-openchrome
    dnf -y remove google-* ModemManager adobe* aajohan-comfortaa-fonts abattis-cantarell-fonts gnu-free-* jomolhari-fonts julietaula-montserrat-fonts khmeros-* lklug-fonts naver-* oxygen-icon-theme paktype-naskh-basic-fonts paratype-pt-sans-fonts smc-* stix-fonts tabish-eeyek-fonts vlgothic-fonts
    dnf -y remove btrfs-progs efibootmgr fros iscsi* mactel-boot microcode_ctl mpage nautilus-sendto  rdist realmd sane-* qt teamd  scl-utils sgpio shim mailcap 
    dnf -y remove wvdial vconfig trousers rp-pppoe qt5-qtxmlpatterns qemu-guest-agent hfsplus-tools grub2-efi fcoe-utils bridge-utils bind-utils 

Reboot and ensure the system is still running (won't have gui at this point)
If system looks good, poweroff and make a second backup.

### Install Work Environment

DNF packages

    dnf -y install dnf-plugins-extras dnf-automatic dnf-plugin-system-upgrade python3-dnf-plugin-system-upgrade python3-dnf-plugins-extras-rpmconf python3-dnf-plugins-extras-leaves python3-dnf-plugins-extras-show-leaves python3-dnf-plugins-extras-tracer python3-dnf-plugins-extras-versionlock.noarch

Desktop packages

    dnf -y install i3 i3lock i3status i3-doc i3-ipc dunst feh scrot dmenu terminator lightdm lightdm-gtk-greeter-settings

Tools of the trade

    dnf -y install ansible ansible-lint ansible-review dstat gpm iotop iptraf-ng ps_mem psmisc sg3_utils strace tmux atop autojump autojump-zsh bmon moreutils htop ifstat iftop ibmonitor jnettop mosh multitail ncdu nethogs ntop tcptrack inxi glances ShellCheck p7zip p7zip-plugins diffuse fuse-sshfs dstat gpm iotop iptraf-ng ps_mem psmisc sg3_utils strace tmux zsh pylint

vim & git packages

    dnf -y install git-all git-tools vim-X11 vim-common vim-commentary vim-enhanced vim-filesystem vim-fugitive vim-go vim-jedi vim-gtk-syntax vim-nerdtree vim-perl-support vim-pysmell vim-taglist

docker packages

    dnf -y install docker docker-compose docker-logrotate docker-novolume-plugin docker-vim docker-zsh-completion


Reboot and ensure the system is still running.
If system looks good, poweroff and make a third backup.


