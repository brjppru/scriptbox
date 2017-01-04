::=========================================================
:: Script Name : Export_evernote.bat
:: Description : Exports all notes to a backup, keeping the last <n> backups.
:: http://www.dba-resources.com/scripting-programming/starting-a-batch-dos-file-minimized/
:: http://www.dba-resources.com/general-computing/how-to-backup-your-evernote-notes-regularly/
::=========================================================

:: ---
:: Setup variables and parameters
:: ---

:: location of Evernote
set ENdir=C:\Program Files (x86)\Evernote\Evernote

:: location to write the backups to
set expdir=C:\temp\ololo

:: The name of the directory to be created to contain the notebook exports (will be prefixed by the date/time)
set groupdir=evernote_backup

:: number of logfiles to keep
set /a keep=4

:: ---
:: Export Notes
:: ---

:: generate date and time varibles
for /f "tokens=1,2,3 delims=/ " %%i in ('date /T') do set thisdate=%%k%%j%%i
for /f "tokens=1,2 delims=: " %%i in ('time /T') do set thistime=%%i%%j
set prefix=%thisdate%_%thistime%


:: do the export
mkdir "%expdir%\%prefix%_%groupdir%"
for /F "tokens=1 delims=" %%i in ('"%ENdir%\enscript.exe" listNotebooks') do "%ENdir%\ENScript.exe" exportNotes /q "notebook:\"%%i\"" /f "%expdir%\%prefix%_%groupdir%\%%i.enex"

:: ---
:: Delete old logs
:: ---

:: make list of files
type NUL > explist.dat
for /F "tokens=1,2 delims=[] " %%i in ('dir /B *%groupdir% ^| find /N "%groupdir%"') do echo  %%i = %%j>>explist.dat

:: count total number of files
for /F "tokens=1 delims=" %%i in ('type explist.dat ^| find /C "%groupdir%"') do set filecnt=%%i

:: Create a list of files to delete
set /a todelete=%filecnt% - ( %keep% )

type NUL>dellist.dat
for /L %%i in (1,1,%todelete%) do find " %%i = " explist.dat >> dellist.dat

:: Delete the old files
for /F "tokens=3 delims= " %%i in ('find "%groupdir%" dellist.dat') do rmdir /S /Q %%i

:: Remove temporary working files
del /Q explist.dat
del /Q dellist.dat

:end