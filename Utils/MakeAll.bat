del make.~log

cd %SQLHAMMER_BIN%
@del /q /s *.exe
@del /q /s *.bpl
@del /q /s *.dll
cd %SQLHAMMER_CVS%
call Utils\EraseBINDir.bat
cd %SQLHAMMER_CVS%
call Utils\EraseCVSDir.bat 

cd Common\Packages
call make.exe 
cd ..\..

cd Pack\Packages
call make.exe 
cd ..\..

cd Environment
call make.exe 
cd ..

cd Demo\Packages
call make.exe 
cd ..\..

cd _InterBase\Packages
call make.exe  
cd ..\..

cd %SQLHAMMER_BIN%
@del /q /s *.map
@del /q /s *.rsm
cd %SQLHAMMER_CVS%
