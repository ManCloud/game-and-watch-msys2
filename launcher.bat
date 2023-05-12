::::::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights V2
::::::::::::::::::::::::::::::::::::::::::::
@echo off
CLS
ECHO.
ECHO =============================
ECHO Running Admin shell
ECHO =============================

:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

rem ------------ START OF ACTUAL SCRIPT ------------------------------------------------
setlocal EnableDelayedExpansion
set system=zelda
set storage_meg=64
set adapter=pico
set triple_boot=1
set clean_build=1

goto main

:head
	CLS
	echo === Game-and-Watch-MSYS2 Installer ==
	echo ========== v0.1 by ManCloud =========
	echo -------------------------------------
	echo.
	echo System: %system% - Adapter: %adapter%
	echo Selected Storage: %storage_meg% MBytes 
	if %triple_boot%==1 (echo Triple Boot: Enabled) else (echo Triple Boot: Disabled)
	if %clean_build%==1 (echo Clean Build: Enabled) else (echo Clean Build: Disabled)
	echo.
goto eof

:main
	call :head
	echo - [Main Menu] -----------------------
	echo.
	echo 1. Install Build-Environment 
	echo 2. Init/Update Repos
	echo 3. GnW-Backup Menu
	echo 4. Flash GnW-Patch (needs Backup!)
	echo 5. Flash GnW-Retro-Go
	echo 6. Flash GnW-Zelda3
	echo.
	echo -------------------------------------
	echo.
	echo S. Settings Menu
	echo Q. Quit
	echo.
	echo -------------------------------------
	echo.
	SET IN_M=
	SET /P IN_M=Please select a number:

	set val_m=0

	IF /I '%IN_M%'=='1' set val_m=1 & call :install_env
	IF /I '%IN_M%'=='2' set val_m=1 & call :run_mingw64 _installer/ , pull_repos.sh
	IF /I '%IN_M%'=='3' set val_m=1 & call :backup_menu
	IF /I '%IN_M%'=='4' set val_m=1 & call :run_patch
	IF /I '%IN_M%'=='5' set val_m=1 & call :retro_go
	IF /I '%IN_M%'=='6' set val_m=1 & call :run_zelda3
	IF /I '%IN_M%'=='S' set val_m=1 & call :settings
	IF /I '%IN_M%'=='Q' set val_m=1 & GOTO eof
	IF /I '%IN_M%'=='' set val_m=1
	
	if %val_m%==0 call :invald_input 1, 6
goto main

:invald_input
	CLS

	ECHO ============INVALID INPUT============
	ECHO -------------------------------------
	ECHO      Please select a number from 
	echo                [%~1-%~2] 
	echo        or select 'Q' to quit.
	ECHO -------------------------------------
	ECHO ======PRESS ANY KEY TO CONTINUE======

	PAUSE > NUL
goto eof

:backup_menu
	call :head
	echo - [GnW-Backup Menu] -----------------
	echo.
	echo 1. Sanity Check
	echo 2. Backup Ext-Flash
	echo 3. Backup Int-Flash
	echo 4. Unlock Device
	echo 5. Restore Device
	echo -------------------------------------
	echo.
	echo S. Settings Menu
	echo Q. Back
	echo.
	echo -------------------------------------
	echo.
	SET IN_B=
	SET /P IN_B=Please select a number:
	
	set val_b=0
	
	IF /I '%IN_B%'=='1' set val_b=1 & call :run_mingw64 ./game-and-watch-backup/, "1_sanity_check.sh %adapter% %system%"
	IF /I '%IN_B%'=='2' set val_b=1 & call :run_mingw64 ./game-and-watch-backup/, "2_backup_flash %adapter% %system%"
	IF /I '%IN_B%'=='3' set val_b=1 & call :run_mingw64 ./game-and-watch-backup/, "3_backup_internal_flash %adapter% %system%"
	IF /I '%IN_B%'=='4' set val_b=1 & call :run_mingw64 ./game-and-watch-backup/, "4_unlock_device %adapter% %system%"
	IF /I '%IN_B%'=='5' set val_b=1 & call :run_mingw64 ./game-and-watch-backup/, "5_restore %adapter% %system%"
	IF /I '%IN_B%'=='S' set val_b=1 & call :settings
	IF /I '%IN_B%'=='Q' goto eof
	IF /I '%IN_B%'=='' set val_b=1
	
	if %val_b%==0	call :invald_input 1, 5
	
goto backup_menu

:settings
	call :head
	echo - [Settings Menu ] ------------------
	echo.
	echo 1. Change System [mario^|zelda]
	echo 2. Change Adapter [pico^|stlink]
	echo 3. Set Storage Size
	echo 4. Toggle Triple Boot
	echo 5. Toggle Clean Build
	echo.
	echo -------------------------------------
	echo.
	echo Q. Back
	echo.
	echo -------------------------------------
	echo.
	SET IN_S=
	SET /P IN_S=Please select a number:	
	IF /I '%IN_S%'=='1' set val_s=1 & call :switch_system
	IF /I '%IN_S%'=='2' set val_s=1 & call :switch_adapter
	IF /I '%IN_S%'=='3' set val_s=1 & call :set_storage
	IF /I '%IN_S%'=='4' set val_s=1 & call :toggle_TB
	IF /I '%IN_S%'=='5' set val_s=1 & call :toggle_CB
	IF /I '%IN_S%'=='Q' goto eof
	
	if %val_s%==0	call :invald_input 1, 5
	
	goto :settings

:run_mingw64
	mkdir _tmp
	echo cd %~1 > _tmp\launch.sh
	echo ./%~2 >> _tmp\launch.sh
	echo read -p ^"Press enter to continue^" >> _tmp\launch.sh
	C:\msys64\mingw64.exe ./_tmp/launch.sh
	call :wait "mintty.exe"
	rd /s /q _tmp
goto eof
	

:toggle_TB
	if %triple_boot%==1 (
		set triple_boot=0
	) else (
		set triple_boot=1
	)
goto eof

:toggle_CB
	if %clean_build%==1 (
		set clean_build=0
	) else (
		set clean_build=1
	)
goto eof

:switch_system
	if %system%==zelda (
		set system=mario
	) else (
		set system=zelda
	)
goto eof
	
:switch_adapter
	if %adapter%==pico (
		set adapter=stlink
	) else (
		set adapter=pico
	)
goto eof

:set_storage
	call :head
	echo - [Setting Storage Size] ------------
	echo.
	SET VALUE=
	echo Please input a Strogare Size between 4 and 512MBytes (must be a multiple of 2^!)
	SET /P VALUE=Value: 
	
	set true=0
	IF /I '%VALUE%'=='4' set true=1
	IF /I '%VALUE%'=='8' set true=1
	IF /I '%VALUE%'=='16' set true=1
	IF /I '%VALUE%'=='32' set true=1
	IF /I '%VALUE%'=='64' set true=1
	IF /I '%VALUE%'=='128' set true=1
	IF /I '%VALUE%'=='256' set true=1
	IF /I '%VALUE%'=='512' set true=1
	IF /I '%VALUE%'=='' goto eof
	IF /I '%INPUT%'=='Q' goto eof
	IF /I %true%==1 set "storage_meg=%VALUE%" & goto eof
	
	call :invald_input 4, 512
goto set_storage

:install_env
	call :run_mingw64 _installer/ , msys2_install.sh
	if exist _installer\run_again.txt (
		goto install_env
	)
goto eof

:retro_go
	cd game-and-watch-retro-go
	call _make_links.cmd
	cd ..
	call :run_mingw64 ./game-and-watch-retro-go/, "build.sh %adapter% %system% %storage_meg% %triple_boot% %clean_build%"
	cd game-and-watch-retro-go
	call _remove_links.cmd
	cd ..
	goto eof

:run_zelda3
	if  exist .\game-and-watch-zelda3\zelda3\tables\zelda3.sfc (
		call :run_mingw64 ./game-and-watch-zelda3/, "build.sh %adapter% %system% %storage_meg% %triple_boot% %clean_build%"
	) else (
		echo "Please put a copy of \"zelda3.sfc\" (USA) into .\game-and-watch-zelda3\zelda3\tables\"
		pause
	)
	goto eof

:run_patch
	set run_p=1
	if NOT exist .\game-and-watch-patch\flash_backup_%system%.bin (
		if exist .\game-and-watch-backup\backups\flash_backup_%system%.bin ( copy .\game-and-watch-backup\backups\flash_backup_%system%.bin .\game-and-watch-patch\ 1>NUL ) else (set run_p=0)
	)
	if NOT exist .\game-and-watch-patch\internal_flash_backup_%system%.bin (
		if exist .\game-and-watch-backup\backups\internal_flash_backup_%system%.bin ( copy .\game-and-watch-backup\backups\internal_flash_backup_%system%.bin .\game-and-watch-patch\ 1>NUL ) else (set run_p=0)
	)
	if %run_p%==1 (
		call :run_mingw64 ./game-and-watch-patch/, "build.sh %adapter% %system% %storage_meg% %triple_boot% %clean_build%"
	) else (
		echo "Missing Backup-Files in game-and-watch-backup!"
		pause
	)
goto eof



:wait
	timeout /t 1 /nobreak >nul 2>&1
	tasklist /fi "ImageName eq %~1" /fo csv 2>NUL | find /I "%~1" >NUL
	if errorlevel 1 goto wait_end
	goto wait
:wait_end
goto eof


:eof