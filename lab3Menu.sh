#!/bin/bash
# Demo-menu shell script



									#	Tecnológico de Costa Rica - Sistemas operativos		#
									#								#
									#       Profesor: Esteban Arias Mendez				#
									#								#
									#	Estudiantes: Rodrigo Acevedo - Yonattan Serrano		#
									#       Carnets:     2013102363      - 2014005692		#
									#								#
									#	Laboratorio 3: Comandos de grupos y usuarios por bash	#




## ----------------------------------
# Define variables
# ----------------------------------
EDITOR=nano
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'
 
# ----------------------------------
# Funciones definidas
# ----------------------------------

pause(){
  read -p "Presione la tecla ENTER para continuar..." fackEnterKey
}
 
crearUsuario(){

	if [ $(id -u) -eq 0 ]; then
		read -p "Ingrese el nombre de usuario : " username
		read -s -p "Inngrese la contraseña : " password
		egrep "^$username" /etc/passwd >/dev/null
		if [ $? -eq 0 ]; then
			echo "$username Existe!"
			exit 1
		else
			pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
			useradd -m -p $pass $username
			[ $? -eq 0 ] && echo "El usuario ha sido agregado!" || echo "Fallo al agregar el usuario!"
		fi
	else
		echo "Solo el usuario root puede realizar esta accion"
		exit 2
	fi

        pause
}
 
modificarUsuario(){

	if [ $(id -u) -eq 0 ]; then
		read -p "Ingrese su LogIn : " logIn
		read -p "Ingrese el nuevo UID de usuario : " uid
		usermod -u $uid $logIn
		[ $? -eq 0 ] && echo "Se ha modificado el usuario!" || echo "Fallo al modificar el usuario!"
		
	else
		echo "Solo el usuario root puede realizar esta accion"
		exit 1
	fi

        pause
}


borrarUsuario(){

	if [ $(id -u) -eq 0 ]; then
	read -p "Ingrese el username a borrar: " username

	[ -n $username ] && userdel $username
	[ $? -eq 0 ] && echo "User ha sido eliminado del sistema" || echo "Fallo al eliminar usuario!"
	else
	echo "Solo el usuario root puede realizar esta accion"
	exit 1
	fi




	pause
}

establecerCont(){

	if [ $(id -u) -eq 0 ]; then
		read -p "Ingrese su LogIn : " logIn
		sudo passwd $logIn
		[ $? -eq 0 ] && echo "Se ha modificado la contraseña del usuario!" || echo "Fallo al modificar la contraseña del usuario!"
		
	else
		echo "Solo el usuario root puede realizar esta accion"
		exit 1
	fi

        pause
}

crearGrupo(){

        if [ $(id -u) -eq 0 ]; then
		read -p "Ingrese el nombre del grupo a agregar : " group
		sudo groupadd $group
		[ $? -eq 0 ] && echo "Se ha agregado el grupo!" || echo "Fallo al cerar el grupo!"
		
	else
		echo "Solo el usuario root puede realizar esta accion"
		exit 1
	fi

        pause
}
borrarGrupo(){

        if [ $(id -u) -eq 0 ]; then
		read -p "Ingrese el nombre del grupo a borrar : " group
		sudo groupdel $group
		[ $? -eq 0 ] && echo "Se ha eliminado el grupo!" || echo "Fallo al eliminar el grupo!"
		
	else
		echo "Solo el usuario root puede realizar esta accion"
		exit 1
	fi

        pause
}

 
# function to display menus
show_menus() {
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo "  MENU-SOLOLINUX.ES  "
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Crear usuario"
	echo "2. Modificar usuario"
	echo "3. Borrar usuario"
	echo "4. Establecer contraseña"
	echo "5. Crear grupo"
	echo "6. Borrar grupo"
	echo "7. SAlir"
}
# Lee la accion sobre el teclado y la ejecuta.
# Invoca el () cuando el usuario selecciona 1 en el menú.
# Invoca a los dos () cuando el usuario selecciona 2 en el menú.
# Salir del menu cuando el usuario selecciona 3 en el menú.
read_options(){
	local choice
	read -p "Ingrese la opcion deseada [ 1 - 7] " choice
	case $choice in
		1) crearUsuario ;;
		2) modificarUsuario ;;
		3) borrarUsuario ;;
		4) establecerCont ;;
		5) crearGrupo ;;
		6) borrarGrupo ;;
		7) exit 0;;
		*) echo -e "${RED}Error: No se encontro la opcion${STD}" && sleep 2
	esac
}
 
# ----------------------------------------------
# Trap CTRL+C, CTRL+Z Sale
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP
 
# -----------------------------------
# Main loop
# ------------------------------------
while true
do
 
	show_menus
	read_options
done
