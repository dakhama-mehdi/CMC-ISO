<#	
	.NOTES
	===========================================================================
	 Updated:   	Janvier 12, 2021
	 Created by:   	Dakhama Mehdi, www.dakhama-mehdi.com, rti-pc@outlook.fr
	 Organization: 	Alphorm.com
	 Filename:      Win10-Medi-Tool.ps1
	 Special Thanks for help to : Zekri Abdelhafid, Geroges News, Olivier Rabache
     Tool Name :    CMC-iso 
	===========================================================================
	.DESCRIPTION
        Creates media Windows 10 Boot/repair/upgrade, automatically support legacy and Uefi boot, with Secure Boot, and without window warning
		Creates Windows 10 setup media that automatically installs via autounattend.xml.Supports both UEFI with Secure Boot on and legacy boot modes.
			
#>

Write-Host "================================================================================="
Write-Host "======================= Windows 10 USB Media Creator  ========================"
Write-Host "========================== By DAKHAMA MEHDI ====================="
Write-Host "================================================================================="`n

Write-Host "This script help you to create a bootable Windows 10 media usb on UEFI + Secure Boot or legacy modes.
you can also create a Legacy only mode for old Bios, taht not support this method."`n

pause 

Write-Host "pls enter path of your Windows 10 ISO"
Write-Host "exemple : "c:\users\mehdi\desktop\myfolder\wind10.iso" ensure that your path is beetwen ''" -BackgroundColor Yellow
$ImagePath = Read-Host

