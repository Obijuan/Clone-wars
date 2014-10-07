!/bin/bash
#- Script para ejecutar de una sola vez el craft de varios ficheros stl
#- Es necesario cambiar la variable DIR y poner el directorio
#- donde está instalado skeinforge
#- Santiago Lopez Pina - Julio 2012

DIR="/Applications/"
mkdir gcodes
for i in `ls *.stl`;do
	 python ${DIR}/skeinforge/skeinforge_application/skeinforge_utilities/skeinforge_craft.py $i;done
mv *.gcode ./gcodes
