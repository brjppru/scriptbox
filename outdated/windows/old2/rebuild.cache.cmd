@echo off
TASKKILL /IM explorer.exe /F
CD /d %LOCALAPPDATA%
DEL /A:H IconCache.db
explorer
pause
