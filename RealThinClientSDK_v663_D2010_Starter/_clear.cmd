rd __history /S /Q

del *.bdsgroup
del *.groupproj*
del *.groupproj
del *.xml

cd Lib
call _clear
cd ..

cd Demos
call _clear
cd ..

cd LibPlugins
call _clear
cd ..

cd QuickStart
call _clear
cd ..

cd Tools
call _clear
cd ..

del *.~*