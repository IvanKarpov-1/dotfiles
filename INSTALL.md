# Table of Contents

- [Table of Contents](#table-of-content)
- [Arch Linux on Asus ROG Zephyrus G14 (G401II)](#arch-linux-on-asus-rog-zephyrus-g14-g401ii)
- [Basic Install](#basic-install)
    - [Prepare and Booting IOS](#prepare-and-booting-iso)
    - [Format Dist](#format-disk)
        - [If on a single-boot system](#1-if-on-a-single-boot-system)
        - [If on a multi-boot system](#2-if-on-a-multi-boot-system)
    - [Create an encrypted filesystem](#create-an-encrypted-filesystem)
    - [Create and Mount Btrfs Subvolumes](#create-and-mount-btrfs-subvolumes)
    - [Create a Btrfs swapfile and remount Subvolums](#create-a-btrfs-swapfile-and-remount-subvolums)
    - [Network](#network)
    - [Install the system using pacstrap](#install-the-system-using-pacstrap)
    - [Configure the system](#configure-the-system)
    - [Install bootloader](#install-bootloader)
    - [Set nvidia-nouveau onto the blacklist](#set-nvidia-nouveau-onto-the-blacklist)
    - [Leave Chroot and Reboot](#leave-chroot-and-reboot)
- [Finetuning after first Reboot](#finetuning-after-first-rebbot)
    - [Enable NetworkManager](#enable-networkmanager)
    - [Enable NTP Timeservice](#enable-ntp-timeservice)
    - [Install some packages](#install-some-packages)
    - [Create a new user](#create-a-new-user)
    - [Update your system](#update-your-system)
    - [Set up Automatic Snapshots for pacman](#set-up-automatic-snapshots-for-pacman)
- [Asus specific](#asus-specific)
    - [Repo](#repo)
    - [Utils](#utils)
    - [Install ROG Kernel](#install-rog-kernel)
        - [On a single-boot system](#on-a-single-boot-system)
        - [On a multi-boot system](#on-a-multi-boot-system)
    - [NVIDIA](#nvidia)
- [Install Desktop Environment (Hyprland)](#install-desktop-environment-hyprland)
    - [Fixing Audio on Linux](#fixing-audio-on-linux)
    - [Install packages](#install-packages)
    - [My dotfiles](#my-dotfiles)
    - [Additional setup](#additional-setup)
        - [SDDM theme](#sddm-theme)
- [Miscellaneous](#miscellaneous)
    - [Arch wiki in your terminal (without the Internet)](#arch-wiki-in-your-terminal-without-the-internet)


# Arch Linux on Asus ROG Zephyrus G14 (G401II)
Guide to install Arch Linux with btrfs, disc encryption, auto-snapshots, no-noise fan curves on Asus ROG Zephyrus G14. Credits to [Unim8rix](https://github.com/Unim8trix/G14Arch), this guide is a fork of their guide with some variations. Also to [Szwendacz99](https://github.com/Szwendacz99/Arch-install-encrypted-btrfs) and [Abdiel Wilson](https://dev.to/abdielwilsn/dual-boot-arch-linux-uefi-with-windows-10-23k4).


# Basic Install

## Prepare and Booting ISO

Prepare your USB drive with [Ventoy](https://www.ventoy.net/en/index.html) (can be used both on Linux and Windows).

Download [Arch IOS](https://archlinux.org/download/) and simply copy it to the prepared USB drive.

Optionally, download [GParted live](https://gparted.org/livecd.php) (may be used in the next step).


## Format Disk

### 1) If on a single-boot system

* Boot into Arch Linux.
* My Disk is `nvme0n1`, check with `lsblk`.
* Format Disk using `cfdisk /dev/nvme0n1` with this simple layout (can also be done via GParted):

	**Mount Point**|**Partition**|**Partition type**|**Size**
	:-----:|:-----:|:-----:|:-----:
	/mnt/boot| /dev/boot\_partition| EFI system partition| At least 300MB \(Would suggest more if planning to run multiple kernels\)
	/mnt| /dev/root\_partition| Linux Filesystem| Remainder of device

After partitioning, run `lsblk` to identify your partitions.

_Sample `lsblk` output_:
```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme0n1     259:0    0 476.9G  0 disk
├─nvme0n1p1 259:1    0   300M  0 part 			 // This is our EFI partition
└─nvme0n1p2 259:2    0 476.6G  0 part 			 // This is our Home partition
```

Identify your EFI partition, in this case `/dev/nvme0n1p1`, and format it like this:
```
mkfs.vfat -F 32 -n EFI /dev/nvme0n1p1
```


### 2) If on a multi-boot system

* Boot into GParted.
* Make a clear partition for the Arch.
* Boot into Arch Linux.
* My Disk is `nvme0n1`, partition is `nvme0n1pN`. After partitioning, run `lsblk` to identify your partitions:

_Sample `lsblk` output_:
```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme0n1     259:0    0 476.9G  0 disk 
├─nvme0n1p1 259:1    0   300M  0 part 			 // This is our EFI partition
├─nvme0n1p2 259:2    0    16M  0 part 
├─nvme0n1p3 259:3    0 149.3G  0 part 
├─nvme0n1p4 259:4    0   764M  0 part 
├...
└─nvme0n1pN 259:N    0   350G  0 part 			 // This is our Home partition
```


## Create an encrypted filesystem

> [!NOTE]
> This step is optional. If you do not want to use encryption, you can skip this it.

```
cryptsetup luksFormat /dev/nvme0n1pN

cryptsetup open /dev/nvme0n1pN luks
```


## Create and Mount Btrfs Subvolumes

> [!IMPORTANT]
> If you encrypted your filesystem, replace all occurrences of `/dev/nvme0n1pN` with `/dev/mapper/luks`.

Btrfs filesystem for root partition:
```
mkfs.btrfs -f -L Arch /dev/nvme0n1pN
```


Mount Partitions and create a Subvolume for Btrfs. I don't want home, etc, in my snapshots, so create a subvolume for them.

```
mount -t btrfs LABEL=Arch /mnt` _Mount root filesystem to /mnt_

btrfs sub create /mnt/@

btrfs sub create /mnt/@home

btrfs sub create /mnt/@snapshots

btrfs sub create /mnt/@swap
```

## Create a Btrfs swapfile and remount Subvolums

```
truncate -s 0 /mnt/@swap/swapfile

chattr +C /mnt/@swap/swapfile

btrfs property set /mnt/@swap/swapfile compression none

fallocate -l {SWAP_SIZE} /mnt/@swap/swapfile

chmod 600 /mnt/@swap/swapfile

mkswap /mnt/@swap/swapfile

mkdir /mnt/@/swap
```

Replace `{SWAP_SIZE}` with the amount of swap space you want. Typically, you should have the same amount of swap as RAM. So if you have 16GB of RAM, you should have 16GB of swap space. For example, a 16GB swap would be created like this:
`fallocate -l 16G /mnt/@swap/swapfile`. Notice that the size in GB is denoted with a G as a suffix and **NOT** GB.

Just unmount with `umount /mnt/` and remount with subvolumes.

> [!NOTE]
> `discard` and `ssd` options are for SSD disks only.

```
mount -o noatime,discard,ssd,compress=zstd,space_cache,commit=120,subvol=@ /dev/nvme0n1pN /mnt
```

1) If on a single-boot system:

    ```
    mkdir -p /mnt/boot
    ```

2) If on a multi-boot system:

    ```
    mkdir -p /mnt/boot/efi
    ```

```
mkdir -p /mnt/boot
mkdir -p /mnt/home
mkdir -p /mnt/.snapshots
mkdir -p /mnt/btrfs

mount -o noatime,discard,ssd,compress=zstd,space_cache,commit=120,subvol=@home /dev/nvme0n1pN /mnt/home/

mount -o noatime,discard,ssd,compress=zstd,space_cache,commit=120,subvol=@snapshots /dev/nvme0n1pN /mnt/.snapshots/

mount -o noatime,discard,ssd,space_cache,commit=120,subvol=@swap /dev/nvme0n1pN /mnt/swap/
```

1) If on a single-boot system:

    ```
    mount /dev/nvme0n1p1 /mnt/boot/
    ```

2) If on a multi-boot system:

    ```
    mount /dev/nvme0n1p1 /mnt/boot/efi
    ```

```
mount -o noatime,compress=zstd,space_cache,commit=120,subvolid=5 /dev/nvme0n1pN /mnt/btrfs/
```

Check mountpoints with `df -Th`


## Network

For the Network, I use wireless; if you need wired, please check the [Arch Wiki](https://wiki.archlinux.org/index.php/Network_configuration). 

Launch `iwctl` and connect to your AP like this:
```
station wlan0 scan

station wlan0 get-networks

station wlan0 connect YOURSSID
```

Type `exit` to leave.

Update System clock with `timedatectl set-ntp true`


## Install the system using pacstrap

```
pacstrap /mnt base base-devel linux linux-firmware btrfs-progs nano networkmanager amd-ucode
```

> [!IMPORTANT]
> If you have an Intel CPU, you should replace `amd-ucode` with `intel-ucode`.

After this, generate the filesystem table:
```
genfstab -Lp /mnt >> /mnt/etc/fstab
````

Add swapfile: 
```
echo "/swap/swapfile none swap defaults 0 0" >> /mnt/etc/fstab
```


## Configure the system

Switch to the installed system root user:
```
arch-chroot /mnt /bin/bash
```

Set up the system clock:
```
ln -s /usr/share/zoneinfo/Europe/Kyiv /etc/localtime

hwclock --systohc --utc
```


Set the hostname. You can use a hostname of your choice. I have gone with `arch`:
```
echo arch > /etc/hostname
```

Uncomment `en_US.UTF-8 UTF-8` and `uk_UA.UTF-8 UTF-8` (or/any any other languages you prefer) in `/etc/locale.gen` and then run:
```
locale-gen
```

Update locale in `/etc/locale.conf`:
```
LANG=en_US.UTF-8
LC_COLLATE=uk_UA.UTF-8
LC_MEASUREMENT=uk_UA.UTF-8
LC_MONETARY=uk_UA.UTF-8
LC_NUMERIC=uk_UA.UTF-8
LC_TIME=uk_UA.UTF-8
```

Modify `/etc/hosts` with these entries. For static IPs, remove 127.0.1.1. Replace `arch` with your hostname.

```
127.0.0.1		localhost
::1				localhost
127.0.1.1		arch.localdomain	arch
```

Add a password for root using:
```
passwd
```

Configure mkinitcpio (`/etc/mkinitcpio.conf`) with modules needed for the initrd image. Add `keyboard`, `keymap`, and `btrfs` to `HOOKS` before filesystems:
```
HOOKS=(base udev autodetect modconf block keymap btrfs filesystems keyboard fsck)
```

> [!IMPORTANT]
> If you chose to encrypt your home partition, add `encrypt` before `btrfs`.

Add btrfsck to binaries:
```
BINARIES=(btrfsck)
```

Also include `amdgpu` in the `MODULES` section:
```
MODULES=(amdgpu)
```

Regenerate initrd images:
```
mkinitcpio -P
```

## Install bootloader

Set up GRUB (UEFI):
```
pacman -S grub efibootmgr os-prober dosfstools mtools
```

<details>

**<summary>If you use encryption</summary>**

Edit `/etc/default/grub`:

```
GRUB_ENABLE_CRYPTODISK=y
```

Find UUID (UUID for `/dev/nvme0n1pN`) of crypto partition so we can add it to grub config:
```
blkid
```

Now set this line, including a proper UUID in place of `<device-UUID>`:

(_temporarly you can use `/dev/sdX2` in place of `<device-UUID>`" and change it later easy in gui mode_)

edit `/etc/default/grub`
```
GRUB_CMDLINE_LINUX="cryptdevice=UUID=<device-UUID>:luks:allow-discards"
```

_**Note**:`allow-discards` is only for SSD to let trim work with encryption enabled._

Generate a key so GRUB doesn't ask twice for the password on boot:
```
dd bs=512 count=4 if=/dev/random of=/crypto_keyfile.bin iflag=fullblock  

chmod 600 /crypto_keyfile.bin  

chmod 600 /boot/initramfs-linux*  

cryptsetup luksAddKey /dev/sdX2 /crypto_keyfile.bin  
```

If you change the name of the key file, you need to add a kernel parameter like `cryptkey=rootfs:path`.

`Crypto_keyfile.bin` is the default name that the kernel will guess anyway.

Now add this file to `/etc/mkinitcpio.conf`:
```
FILES=(/crypto_keyfile.bin) 
```

Then run:

```
mkinitcpio -P  
```

</details>

Install GRUB:
```
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB  

grub-mkconfig -o /boot/grub/grub.cfg
```

> [!IMPORTANT]
> For multi-booted system replace `--efi-directory=/efi` with `--efi-directory=/boot/efi`.


## Set nvidia-nouveau onto the blacklist

Add to `/etc/modprobe.d/blacklist-nvidia-nouveau.conf` these lines:
```
blacklist nouveau
options nouveau modeset=0
```

## Leave Chroot and Reboot

Type `exit` to exit chroot.

Unmount all volumes:
```
umount -R /mnt/
```

Now it's time to `reboot` into the new system!


# Finetuning after first Rebbot

## Enable NetworkManager

Configure WiFi Connection.

```
systemctl enable NetworkManager

systemctl start NetworkManager

nmcli device wifi connect {YOURSSID} password {SSIDPASSWORD}
```


## Enable NTP Timeservice

```
systemctl enable --now systemd-timesyncd.service
```

> [!TIP]
> You may look at `/etc/systemd/timesyncd.conf` for default values and change if necessary.


## Install some packages

```
sudo pacman -S bat btop curl dust eza fastfetch fd fzf git less man nvim tldr unzip wget zsh
```

Install yay (AUR helper):
```
git clone https://aur.archlinux.org/yay.git

cd yay

makepkg -si
```

<details>

<summary>
Packages explanation
</summary>

| Package | Explanation |
| ------- | ----------- |
| `bat` | `cat` clone with syntax highlighting and Git integration |
| `btop` | Monitor of resources |
| `curl` | Command-line tool and library for transferring data with URLs |
| `dust` | More intuitive version of du, in Rust |
| `eza` | `ls` replacement with color support, tree view, git integration and other features |
| `fastfetch` | System information fetching program like neofetch |
| `fd` | Find entries in the filesystem |
| `fzf` | General-purpose command-line fuzzy finder |
| `git` | Version control system (VCS) designed and developed by Linus Torvalds, the creator of the Linux kernel |
| `less` | Terminal pager |
| `man` | Command used to display manual pages |
| `nvim` | Fork of Vim aiming to improve the codebase, allowing for easier implementation of APIs, improved user experience and plugin implementation |
| `tldr` | The tldr pages are a community effort to simplify the beloved man pages with practical examples |
| `unzip` | List, test and extract compressed files in a ZIP archive |
| `wget` | Free software package for retrieving files using HTTP, HTTPS, FTP and FTPS |
| `zsh` | Powerful shell that operates as both an interactive shell and as a scripting language interpreter |

</details>

## Create a new user

First, create my new local user and point it to zsh:
```
useradd -m -G wheel,power,audio -s /usr/bin/zsh {MYUSERNAME}

passwd {MYUSERNAME}
```

Edit `/etc/sudoers` and uncomment:
```
%wheel ALL=(ALL) ALL
```

Now `exit` and re-login with the new MYUSERNAME.


## Update your system

The first thing you should do after installing is to update your system. Open a command line and run:

```
sudo pacman -Syu
```

Install some Deamons before we reboot:
```
sudo pacman -S acpid dbus 
sudo systemctl enable acpid
```

## Set up Automatic Snapshots for pacman

To set up automatic snapshots every time system updates, follow the section from Unim8rix's [guide](https://github.com/Unim8trix/G14Arch?tab=readme-ov-file#setup-automatic-snapshots-for-pacman).


# Asus specific

> [!IMPORTANT]
> This section is mostly related to the Asus ROG Zephyrus G14 laptop with an NVIDIA card. For more, refer to [this](https://asus-linux.org/guides/arch-guide/).


## Repo

Add the repo sign key:

```
pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
```

Then add to the `/etc/pacman.conf` the following lines at the end to add the repo:
```
[g14]
Server = https://arch.asus-linux.org
```

After adding the repo, run a full system update:
```
pacman -Suy
```

## Utils

Install `asusctl`, `power-profiles-daemon` and `rog-control-center`, 

```
pacman -S asusctl power-profiles-daemon rog-control-center
```

Then:
```
systemctl enable --now power-profiles-daemon.service
```

Run the following commands to set the charge limit and enable Quiet, Performance, and Balanced Profiles:
```
asusctl -c 85 		# Sets charge limit to 85%. If you do not want this, do not execute this line.

asusctl fan-curve -m Quiet -f cpu -e true

asusctl fan-curve -m Quiet -f gpu -e true

asusctl fan-curve -m Performance -f cpu -e true

asusctl fan-curve -m Performance -f gpu -e true

asusctl fan-curve -m Balanced -f cpu -e true

asusctl fan-curve -m Balanced -f gpu -e true
```


## Install ROG Kernel

After adding the above repo, install the ROG kernel by running:
```
sudo pacman -S linux-g14 linux-g14-headers 
```

> [!IMPORTANT]
> Kernel headers are very important; otherwise, the NVIDIA module will not load, resulting in a black screen.

Then you need to regenerate the boot menu or add a new boot entry, depending on what boot configuration you use.


### On a single-boot system

If you are on a single-boot system, run:
```
grub-mkconfig -o /boot/grub/grub.cfg
```

After that, `reboot`.

### On a multi-boot system

Restart your laptop, boot into the distro that installed the GRUB (usually, the first distro in the system), and add this to the `/etc/grub.d/40_custom`:
```
menuentry 'Arch Linux, with Linux g14 kernel (on /dev/nvme0n1pN)' {
	insmod part_gpt
	insmod ext2
	set root='(hd0,gptX)'   # Replace with Arch root or /boot partition
	search --no-floppy --fs-uuid --set=root {UUID}
	linux /boot/vmlinuz-linux-g14 root=UUID={UUID} rw loglevel=3 quiet
	initrd /boot/amd-ucode.img /boot/initramfs-linux-g14.img
}
```

Find the correct `hd0,gptX` by running:
```
sudo grub-probe --target=drive --device /dev/<arch-root-partition>
```

Replace `{UUID}` with the UUID of your partition. Can be found in the `/boot/grub/grub.cfg`. 

> [!WARNING]
> Careful, DO NOT change that file as it might mess up your system!

Then, run:
```
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

After that, `reboot`.


# NVIDIA

Install necessary packages:
```
sudo pacman -S nvidia-open-dkms nvidia-utils lib32-nvidia-utils vulkan-icd-loader
```

Install `nvidia-laptop-power-cfg`:
```
git clone https://gitlab.com/asus-linux/nvidia-laptop-power-cfg.git

cd nvidia-laptop-power-cfg

makepkg -sfi
```

Enable NVIDIA services:
```
systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service

systemctl enable --now nvidia-powerd
```

Create file `/etc/modprobe.d/nvidia.conf` and paste next:
```
options nvidia_drm modeset=1
```

Edit `/etc/mkinitcpio.conf` to add NVIDIA modules:
```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Then, `reboot`.

After a reboot, you should see the GPU turning on when needed and off when it's not needed anymore.

Additionally, you should query the status of your GPU with
```
cat /proc/driver/nvidia/gpus/bus_address/power
```

The `bus_address` will be different on each model, just use the autocompletion feature of bash, spamming tab; the correct result is similar to this:
```
S0ix Power Management:
 Platform Support:          Supported
 Status:                    Enabled
```

# Install Desktop Environment (Hyprland)

## Fixing Audio on Linux

Audio was exceptionally low on linux. To fix, first remove everything `pulseaudio` related by running:
```
sudo pacman -Rdd pulseaudio pulseaudio-alsa pulseaudio-bluetooth \
pulseaudio-ctl pulseaudio-equalizer pulseaudio-jack pulseaudio-lirc \
pulseaudio-rtp pulseaudio-zeroconf pulseaudio-equalizer-ladspa
```

Then, install `pipewire` and its related packages:
```
sudo pacman -S pipewire pipewire-alsa pipewire-audio pipewire-pulse \
    gstreamer gst-plugins-base gst-plugins-good gst-plugin-pipewire \
    wireplumber
```

Install bluetooth related packages:
```
sudo pacman -S bluez bluez-utils blueman
```

Enable bluetooth and start service:
```
sudo systemctl enable bluetooth.service

sudo systemctl start bluetooth.service
```


## Install packages

Install `hyprland`:
```
sudo pacman -S hyprland
```

Install "Must have" packages:
```
sudo pacman -S hyprpolkitagent noto-fonts noto-fonts-cjk noto-fonts-emoji \
    qt5-wayland qt6-wayland swaync \
    xdg-desktop-portal-gtk xdg-desktop-portal-hyprland
```

Install other packages:
```
sudo pacman -S adw-gtk-theme brightnessctl cliphist ffmpeg figlet \
    flatpak grim hypridle hyprlock hyprpaper hyprpicker imagemagick \
    ttf-jetbrains-mono notify-tools kitty kvantum kvantum-qt5 libnotify \
    loupe meson nm-connection-editor network-manager-applet nwg-look \
    nwg-displays papirus-icon-theme playerctl python-pip qbittorrent \
    qt5ct qt6ct rofi sddm slurp thunar tumbler vivaldi vlc waybar \
    wl-clipboard xclip xdg-user-dirs
```
```
yay -S matugen-bin sddm-silent-theme spotify \
    telegram-desktop-bin visual-studio-code-bin waypaper wlogout
```

```
wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.local/share/icons" sh

wget -qO- https://git.io/papirus-folders-install | env PREFIX=$HOME/.local sh
```

`reboot` your system.

<details>

<summary>
Packages explanation
</summary>

<br/>
🔴 - required<br/>
🟡 - good to have<br/>
🟢 - optional

| Package | Explanation |  |
| ------- | ----------- | - |
| | **The Core** |
| `hyprland` | Hyprland is an independent tiling Wayland compositor written in C++ | 🔴 |
| | **Must have category** |
| `hyprpolkitagent` | a polkit authentication daemon. It is required for GUI applications to be able to request elevated privileges | 🔴  |
| `noto-fonts`<br/>`noto-fonts-cjk`<br/>`noto-fonts-emoji`  | Required to render text | 🔴 |
| `qt5-wayland`<br/>`qt6-wayland` | Qt Wayland support | 🔴 |
| `swaync` | A simple notification daemon. Many apps (e.g., Discord) may freeze without one running | 🔴 |
| `xdg-desktop-portal-gtk`<br/>`xdg-desktop-portal-hyprland` | An XDG Desktop Portal is a program that lets other applications communicate with the compositor through D-Bus. A portal implements certain functionalities, such as opening file pickers or screen sharing | 🔴 |
| | **Other packages category (pacman)** |
| `adw-gtk-theme` | The theme from libadwaita ported to GTK-3 | 🟡 |
| `brightnessctl` | A program to read and control device brightness | 🟡 |
| `cliphist` | Wayland clipboard manager with support for multimedia | 🟡 |
| `ffmpeg` | FFmpeg is a complete, cross-platform solution to record, convert, and stream audio and video. It includes libavcodec - the leading audio/video codec library | 🔴 |
| `figlet` | Display large characters made up of ordinary screen characters | 🟢 |
| `flatpak` | Flatpak is a system for building, distributing, and running sandboxed desktop applications on Linux | 🟡 |
| `grim` | Capturing the screen on a Wlroots-based compositor (e.g., Hyprland) (alternatives: `flameshot`) | 🟢 |
| `hypridle` | Hyprland’s idle management daemon | 🟡 |
| `hyprlock` | Simple, yet fast, multi-threaded, and GPU-accelerated screen lock for Hyprland | 🟡 |
| `hyprpaper` | Fast, IPC-controlled wallpaper utility for Hyprland | 🟡 |
| `hyprpicker` | Neat utility for picking a color from your screen on Hyprland | 🟡 |
| `ttf-jetbrains-mono` | JetBrains Mono – the free and open-source typeface for developers | 🟢 |
| `imagemagick` | Free and open-source software suite for displaying, converting, and editing raster image and vector image files | 🟡 |
| `inotify-tools` | A library and a set of command-line programs providing a simple interface to inotify | 🟡 |
| `kitty` | Scriptable OpenGL-based terminal emulator with TrueColor, ligatures support, protocol extensions for keyboard input, and image rendering. It also offers tiling capabilities. (altrnatives: `alacritty`, `gnome-console`, `ghostty`, `tabby`<sup>From website</sup>) | 🟢 |
| `kvantum`<br/>`kvantum-qt5` | SVG-based theme engines for Qt5 and Qt6 | 🟡 |
| `libnotify` | Desktop-independent implementation of the Desktop Notifications Specification, which provides `notify-send` utility and support for GTK and Qt applications | 🟡 |
| `loupe` | GNOME's default image viewer (alternatives: `qview`<sup>AUR</sup>, `gwenview`<sup>From Flatpak</sup>, `feh`) | 🟢 |
| `meson` | Open source build system | 🟢 |
| `nm-connection-editor` | Graphical user interface for `NetworkManager` | 🟡 |
| `network-manager-applet` | System tray applet for `NetworkManager` | 🟡 |
| `nwg-look` | GTK3 settings editor adapted to work in the wlroots environment | 🟡 |
| `nwg-displays` | Output management utility for sway and Hyprland | 🟡 |
| `playerctl` | Provides a command-line tool to send commands to MPRIS clients | 🟡 |
| `python-pip` | The PyPA recommended tool for installing Python packages | 🟡 |
| `qbittorrent` | Torrent client | 🟢 |
| `qt5ct`<br/>`qt6ct` | Qt5 and Qt5 configuration utilities | 🟡 |
| `rofi` | Window switcher, run dialog, ssh-launcher, and dmenu replacement | 🟡 |
| `sddm` | Display manager | 🟡 |
| `slurp` | Select a region in a Wayland compositor | 🟢 |
| `thunar` | File manager (alternatives: `dolphin`, `nautilus`, `superfile`) | 🟢 |
| `tumbler` | External program to generate thumbnails for `thunar`| 🟢 |
| `vivaldi` | Browser (alternatives: `firefox`, `librewolf`<sup>AUR</sup>, `zen-browser-bin`<sup>AUR</sup>, `brave-bin`<sup>AUR</sup>) | 🟢 |
| `vlc` | Free and open source cross-platform multimedia player and framework that plays most multimedia files as well as DVD, Audio CD, VCD, and various streaming protocols (alternatives: `mpv`, `celluloid`<sup>From Flatpak</sup>) | 🟢 |
| `waybar` | Highly customizable Wayland bar for Hyprland and Wlroots-based compositors | 🟡 |
| `wl-clipboard` | A simple copy/paste tool for Wayland compositors | 🟡 |
| `xclip` | A lightweight, command-line-based interface to the clipboard | 🟡 |
| `xdg-user-dirs` | A tool to help manage "well-known" user directories like the desktop folder and the music folder. It also handles localization (i.e., translation) of the filenames | 🟢 |
| | **Other packages category (yay)** |
| `matugen-bin` | A material you color generation tool | 🟡 |
| `sddm-silent-theme` | A very customizable SDDM theme | 🟢 |
| `spotify` | A digital music streaming service (alternatives: `spotube-bin` (AUR), `audius`<sup>From website</sup>, `muffon`<sup>From website</sup>) | 🟢 |
| `telegram-desktop-bin` | A cloud-based cross-platform instant messaging service with optional end-to-end encryption (alternatives: `element-desktop`, `viber`<sup>From website</sup>) | 🟢 |
| `visual-studio-code-bin` | A cross-platform text editor developed by Microsoft (alternatives: `emacs`, `gedit`, `helix`, `vin`, `nvim`) | 🟢 |
| `waypaper` | GUI wallpaper manager for Wayland and Xorg Linux systems | 🟡 |
| `wlogout` | Logout menu for Wayland | 🟡 |
|| **Other packages category (wget)** | |
| `papirus-folders-git` | A script that lets you change the colors of folders in Papirus icon theme | 🟡 |
| `papirus-icon-theme` | Papirus is a free and open source SVG icon theme for Linux | 🟡 |

</details>


## My dotfiles

From now on, you can customize your system as you see fit.

If you don't want to spend time on this, or simply don't know how to do it, or perhaps you like what [I've done](https://github.com/IvanKarpov-1/dotfiles/tree/arch-experimental), then you can apply my customizations.

To do so, clone my dotfiles repo:
```
git clone --recurse-submodules https://github.com/IvanKarpov-1/dotfiles.git "~/.mimics_dotfiles"
```

Go into the newly downloaded repo and execute `install-dotfiles.sh`:
> [!IMPORTANT]
> Make sure you installed packages from the previous step.
```
git checkout arch-experimental

cd ~/.mimics_dotfiles/scripts

./install-dotfiles.sh
```

Done! Now you have a fully configured (almost) Hyprland environment. Make sure to tweak it to your liking, as you are not me, and might like things differently.


## Additional setup

### SDDM theme

Previously, we installed the SilentSDDM theme for the SDDM.

To properly configure it, edit `/etc/sddm.conf`:
```
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent
```

Initially, SilentSDDM will not follow the system color scheme (scheme generated by `matugen` on wallpaper change) and will not have your wallpaper.

The script `m-theme-set-sddm` tries to copy the generated theme file and background from the user's home directory to the `/usr/share/sddm/themes/silent/` directory. For it, it requires `sudo` privileges. Which is fine if you run the script yourself and enter the password. But when it executes in the theme-changing pipeline, you don't have the ability to enter the password. So we need to allow executing script commands without the password.

To make it happen, you need to add the sudoers policy. Edit `/etc/sudoers.d/sddm-theme`:
```
sudo visudo -f /etc/sudoers.d/sddm-theme
```

> [!CAUTION]
> ALWAYS make changes to the sudoers files using `visudo`, as it ensures the correctness of those changes.

> [!NOTE]
> If you have this error
> ```
> visudo: no editor found (editor path = /usr/bin/vi)
> ```
> Run the command as follows:
> ```
> sudo EDITOR=/usr/bin/nvim visudo -f /etc/sudoers.d/sddm-theme
> ```
> You may replace `nvim` with your editor of choice.

And add next (replacing `{YOUR_USER_NAME}` with your user name):
```
{YOUR_USER_NAME} ALL = (root) NOPASSWD: /usr/bin/cp -f /home/{YOUR_USER_NAME}/.config/sddm/sddm-matugen.conf /usr/share/sddm/themes/silent/configs/sddm-matugen.conf

{YOUR_USER_NAME} ALL = (root) NOPASSWD: /usr/bin/cp -f /home/{YOUR_USER_NAME}/.cache/mimic/hyprland-dotfiles/blurred_wallpaper.png /usr/share/sddm/themes/silent/backgrounds/blurred_wallpaper.png
```

Then, in `/usr/share/sddm/themes/silent/metadata.desktop` comment (by placing `;` in front) default theme and add the generated one:
```
ConfigFile=configs/sddm-matugen.conf
; ConfigFile=configs/default.conf
```


# Miscellaneous

## Arch wiki in your terminal (without the Internet)
```
sudo pacman -S wikiman arch-wiki-docs
```