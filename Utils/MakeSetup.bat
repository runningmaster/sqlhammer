rem IF "%1"=="INSTALL" GOTO INNO

call "%INNO%\compil32" /cc %SQLHAMMER_CVS%\Setup\SQLHammer.iss
