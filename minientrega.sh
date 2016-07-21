#! /bin/bash

if [ $# -ne 1 ]
then
	echo "minientrega.sh: Error(EX_USAGE), uso incorrecto del mandato"
	echo "minientrega.sh+ Numero de argumentos incorrecto"
	1>&2
	exit 64
fi

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
	echo "minientrega.sh: Uso: minientrega.sh argumento_a_analizar"
	echo "minientrega.sh: El siguiente script comprueba:
		(1) Si el identificador de la practica es valido
		(2) Si la entrega no esta fuera de plazo
		(3) Si existen los ficheros exigidos para la practica
		(4) Copia los ficheros a un directorio adecuado" 
	exit 0
fi

#Comprobar que exite, que no es vacio, que es legible y que existe el directorio

if [ ! -e ${MINIENTREGA_CONF} ] || [ -z ${MINIENTREGA_CONF} ] || [ ! -r ${MINIENTREGA_CONF} ] || [ ! -d ${MINIENTREGA_CONF} ]
then
	exit 64
fi

#Comprueba si es legible

if [ ! -r ${MINIENTREGA_CONF}/$1 ]
then
	exit 66
fi

source ${MINIENTREGA_CONF}/$1

#Comprueba si la entrega se realiza dentro del plazo

actualDay=$(date +%d)
actualMonth=$(date +%m)
actualYear=$(date +%Y)

dayLimit=$(date -d $MINIENTREGA_FECHALIMITE +%d)
monthLimit=$(date -d $MINIENTREGA_FECHALIMITE +%m)
yearLimit=$(date -d $MINIENTREGA_FECHALIMITE +%Y)

if [ $yearLimit -lt $actualYear ] && [ $monthLimit -lt $actualMonth ] && [ $dayLimit -lt $actualDay ]
then
	exit 65
fi

#Comprueba que estan todos los ficheros en $MINIENTREGA_FICHEROS

for FICHERO in $MINIENTREGA_FICHEROS
do
if [ ! -r $FICHERO ]
then
	exit 66
fi
done

#Comprueba si el directorio existe y si existe copiamos los archivos al directorio $MINIENTREGA_DESTINO/$USER

if [ ! -d $MINIENTREGA_DESTINO ] || [ ! -w $MINIENTREGA_DESTINO ]
then
        exit 73
fi

mkdir -p $MINIENTREGA_DESTINO/$USER

        #Copia los ficheros a entregar en el directorio destino

for FICHERO in $MINIENTREGA_FICHEROS
do
    cp $FICHERO $MINIENTREGA_DESTINO/$USER/
done

exit 0
