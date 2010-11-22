@echo off

echo Please be sure to remove XML-Parser and install XML-Parser-Lite ^& PAR-Packer

echo Building dp-util.exe...
pp -C -f Bleach -i DP.ico -o windows\dp-util.exe ..\dp-util
echo Done!

