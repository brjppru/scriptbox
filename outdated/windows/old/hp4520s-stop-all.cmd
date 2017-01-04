@echo off
nircmdc killprocess chrome.exe
nircmdc killprocess pidgin.exe
nircmdc killprocess tv_w32.exe
nircmdc killprocess tv_x64.exe
nircmdc killprocess tv_x64.exe
nircmdc killprocess BoostSpeed.exe
nircmdc killprocess dmaster.exe
nircmdc killprocess GoogleCrashHandler.exe
nircmdc killprocess Skype.exe
nircmdc killprocess TeamViewer.exe
nircmdc killprocess TeamViewer_service.exe
nircmdc killprocess uTorrent.exe
nircmdc killprocess dropbox.exe
net stop "teamviewer7"
taskkill /f /im teamviewer
nircmdc closeprocess TeamViewer.exe
nircmdc closeprocess TeamViewer_Service.exe
nircmdc closeprocess tv_w32.exe
nircmdc closeprocess tv_x64.exe
