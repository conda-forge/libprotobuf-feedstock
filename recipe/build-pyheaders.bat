@echo on

robocopy python/ %LIBRARY_PREFIX%\include *.zip /E
if %ERRORLEVEL% neq 0 exit 1

