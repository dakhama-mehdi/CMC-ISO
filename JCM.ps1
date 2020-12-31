<#	
	.NOTES
	===========================================================================
	 Updated:   	Decembre 29, 2020
	 Created by:   	Dakhama Mehdi, www.dakhama-mehdi.com, rti-pc@outlook.fr
	 Organization: 	Alphorm.com
	 Filename:      Win10-Medi-Tool.ps1
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
Write-Host "exemple : "c:\users\mehdi\desktop\my folder\wind10.iso" ensure that your path is beetwen ''" -BackgroundColor Yellow
$ImagePath = Read-Host

#mount ISO 

If (-not (Get-DiskImage -ImagePath $ImagePath | Get-Volume))
				{
					$DiskMounted = $true
					Write-Verbose "DiskMounted equals $DiskMounted"
					
					Try
					{
						Write-Verbose "Mounting ISO"
						Mount-DiskImage -ImagePath $ImagePath -ErrorAction Stop
					}
					Catch
					{
						Write-Warning $_
						Break
						
					} #end catch 
					
				} #end if 
				Else
				{
					Write-Verbose "ISO already mounted"
				}
				
				$ISODrive = ((Get-DiskImage -ImagePath $ImagePath | Get-Volume).DriveLetter) + ":\"


Write-Host "listing the USB drives.... `r`n" 
$result= Get-Disk | where({ $_.BusType -eq 'USB' }) | select number, friendlyname, @{ Name = "Size"; Expression = { "{0:N2}" -f ($_.Size/1GB) } } 
$result | Out-Host
Write-Host "Pls select number of your USB drive `r`n"
$disk= Read-Host

#check if the disk selected is correctly USB drive and not a Hard drive
if ($result.number -notcontains $disk) {
do  {
$dik = $null
$result | Out-Host
Write-Host "Pls select only the number of your USB drive `r`n"
$disk= Read-Host


} until ($result.number -contains $disk)
}

#select mode create tool 
Write-Host "1-create a universal key support UEFI and Legacy"
Write-Host "2-Create a key support only Legacy mode for old Bios"
$mode = Read-Host

#confirm selected drive
$drive= get-disk $disk | select FriendlyName
$result = [System.Windows.Forms.MessageBox]::Show('Warning the Drive nammed : ' + $drive.FriendlyName + '  Will be formated', 'JCM - ISO', 'YesNo')
if ($result -eq 'YES')
{
	write-host "Drive will be formated....."
}
else
{
	exit
}

if ($mode -ne '2') {

# to close automaticaly the window when assign letter to drive
$shell = New-Object -ComObject Shell.Application

#check disk partition befor format and creat partition, wi will have a MBR partition type to format FAT32 without error
$mbrtype = (Get-Disk $disk)

#format without assign letter or create partition
if ((Get-Disk $disk).partitionstyle -eq 'MBR')
				{
					Clear-Disk -Number $disk -RemoveData -RemoveOEM -Confirm:$false -PassThru 

				}
else
				{
					do
					{
						Clear-Disk -Number $disk -RemoveData -RemoveOEM -Confirm:$false -PassThru | Set-Disk -PartitionStyle 'MBR'
						if ((Get-Disk -Number $disk).partitionstyle -eq 'RAW')
						{
							$result2 = Get-Disk -Number $disk | Initialize-Disk -PartitionStyle MBR
						}
						
					} until ((Get-Disk $disk).partitionstyle -eq 'MBR')
				}
				


#Create Boot partition
New-Partition -DiskNumber $disk -Size 1024MB -IsActive  | Format-Volume -FileSystem FAT32 -NewFileSystemLabel 'CMCiso-Boot'
New-Partition -DiskNumber $disk -UseMaximumSize  | Format-Volume -FileSystem NTFS -NewFileSystemLabel 'CMCiso-Source'

sleep -Seconds 2

#close new window
foreach ($window in ($shell.Windows() | Where-Object { $_.LocationURL -like "$(([uri]"*CMCiso*").AbsoluteUri)*" }))
				{
					
					$window.Quit()
					
				}

#Assign letter without new window or warning
(Get-Partition -DiskNumber $disk | select PartitionNumber, DriveLetter, type) | foreach {
					if ($_.type -like 'Fat32*')
					{
						Add-PartitionAccessPath -DiskNumber $disk -PartitionNumber $_.PartitionNumber -AssignDriveLetter -Confirm:$false
						foreach ($window in ($shell.Windows() | Where-Object { $_.LocationURL -like "$(([uri]"*CMCiso*").AbsoluteUri)*" }))
						{
							
							$window.Quit()
							
						}
					}
					else
					{
						Add-PartitionAccessPath -DiskNumber $disk -PartitionNumber $_.PartitionNumber -AssignDriveLetter -Confirm:$false
						foreach ($window in ($shell.Windows() | Where-Object { $_.LocationURL -like "$(([uri]"*CMCiso*").AbsoluteUri)*" }))
						{
							
							$window.Quit()
							
						}
					}
					
				}

#insist to close warning window if persist
				sleep -Seconds 2
				foreach ($window in ($shell.Windows() | Where-Object { $_.LocationURL -like "$(([uri]"*CMCiso*").AbsoluteUri)*" }))
				{
					
					$window.Quit()
					
				}

#Copy file to partition

(Get-Partition -DiskNumber $disk | select PartitionNumber, DriveLetter, type) | foreach {
					
					if ($_.type -like 'Fat32*')
					{
						$drive = $_.driveletter + ":\"
						robocopy $ISODrive $drive /mir /xd sources
						$drive1 = $drive + "sources\"
						robocopy $isodrive\sources $drive1 boot.wim
						
						Remove-PartitionAccessPath -DiskNumber $disk -PartitionNumber $_.PartitionNumber -AccessPath $drive
					}

else
					{
	
						$drive = $null
						$drive = $_.driveletter + ":\"
   						robocopy $ISODrive $drive
                        $drive1 = $null
                        $drive1 = $drive + "sources\"
                    # if want to create universsel ISO 
                    		
							$command = @"
[Channel]
Retail
"@
							$eicfg = $drive1 + "ei.cfg"
							echo $command > $eicfg

}

}


} 

#create key for old Bios Legacy only

if ($mode -eq '2') {


    # to close automaticaly the window when assign letter to drive
$shell = New-Object -ComObject Shell.Application

#check disk partition befor format and creat partition, wi will have a MBR partition type to format FAT32 without error
$mbrtype = (Get-Disk $disk)

#format disk and create partition
if ((Get-Disk $disk).partitionstyle -eq 'MBR')
				{
					Clear-Disk -Number $disk -RemoveData -RemoveOEM -Confirm:$false -PassThru 
                    sleep -Seconds 2
                    
                    New-Partition -DiskNumber $disk -UseMaximumSize -IsActive | Format-Volume -FileSystem NTFS -NewFileSystemLabel 'CMCiso'
					
					Add-PartitionAccessPath -DiskNumber $disk -PartitionNumber '1' -AssignDriveLetter -Confirm:$false
							sleep -Seconds 2
							foreach ($window in ($shell.Windows() | Where-Object { $_.LocationURL -like "$(([uri]"*CMCiso*").AbsoluteUri)*" }))
							{
								
								$window.Quit()
							
						}
                    
                    $drive = (Get-Partition -DiskNumber $disk).driveletter + ':'
				}
else
				{
					Clear-Disk -Number $disk -RemoveData -RemoveOEM -Confirm:$false -PassThru
                    sleep -Seconds 2

                    if ((Get-Disk -Number $disk).partitionstyle -eq 'RAW')
					{
						Get-Disk -Number $disk | Initialize-Disk -PartitionStyle MBR
					}
					else
					{
						
						Get-Disk -Number $disk | set-Disk -PartitionStyle MBR
					}

                    $result = Get-Disk -Number $disk | New-Partition -UseMaximumSize -IsActive -AssignDriveLetter | Format-Volume -FileSystem NTFS
                    $drive = $result.driveletter + ':'

} 

#Active Boot Sect 
$pathbootsec = $ISODrive + '\boot\' 
cd $var1 
.\bootsect.exe /NT60 $drive

#Copy Files
robocopy $ISODrive $drive /mir

}

#Dismount ISO
Dismount-DiskImage -ImagePath $ImagePath


Write-Host "Your Key is succeful created, Thank you"
pause
