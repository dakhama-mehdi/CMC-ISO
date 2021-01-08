# CMC-ISO Version : 5.0.36
* Tool to Create Media Windows 10 Boot 
* Créer Ma Clé - ISO (free tool to create Windows 10 universal Media for Boot/repair/upgrade - you can also download all Win10 original ISO)
* This version is support ISO generat from MDT 

![CMC](https://user-images.githubusercontent.com/49924401/103418596-aaa0bf00-4b8f-11eb-9ba6-2c27978f5dc9.gif)

This free tool offres two fonctionality. 

* Burn your ISO on you USB Drive or External Hard Drive - and boot on UEFI OR Legacy mode support SecureBoot
* Download Windows 10 ISO all Version


# Why to use : 

* CMC-ISO, is one of few tool that keep you to burn your iso on USB and also external hard drive
* Support Secure Boot
* Create Universal Media compatible with UEFI and Legacy Bios Mode
* compatible all version Windwos 10 ISO (WIM or ESD) (RTM and Retail)
* dont need install, very fast, and tool is signed and verified 

#prerequiste
* tool work only on Windows 8.1 or Win 10
* you must have Powershell version 4.0 min
* have media USB or External hard drive have more 8 GO

 How to use :
* for create a usb media boot, select Image ISO, select your Drive, Select mode Boot (Universsel support UEFI + LEgacy) or (MBR for old Bios)

# One note on Microsoft’s tool. This tool has some limitations:

* Each time you run it, it fully downloads the media from the internet. This makes it a much longer process if you are needing to re-do the process or setup multiple drives
* It is only the latest version of Windows. Right now, 2004 is the latest version, but if you needed 2002 or earlier it does not give you an option to select an earlier version.
* It is only Windows 10 Pro
* On the upside, the install.wim is compressed to under 4GB so it can fit on FAT32 partitions and thus allow you to have only 1 partition on the key 

Enjoy
