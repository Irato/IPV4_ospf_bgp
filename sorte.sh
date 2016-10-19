#Identificacao de interfaces de rede
ls /sys/class/net > /tmp/if.txt     #Lista as interfaces e escreve no arquivo if.txt
numero=$(wc -l < /tmp/if.txt)       #Conta a quantidade de interfaces(linhas) do sistema 
interface=(inexistente inexistente inexistente inexistente)
#Se a quantidade de interfaces for menor ou igual a 4 escreve nas posicoes de 0 a 3 do vetor de interfaces
if [ $numero -le 4 ];then
contador=1
until [ $contador -eq $numero ];do
interface[$contador]=$(sed -n $contador'p' /tmp/if.txt) 
let contador+=1
done
fi


conf_automatica(){
	#Funcao de roteamento estatico IPV4

dialog --title "Configuracao automatica da topologia IPV4" \
       --menu "Escolha qual sera a sua maquina na topologia: " 0 0 0 \
        HostA "" \
        HostB "" \
        HostC "" \
        HostD "" \
	VOLTAR '' 2> /tmp/opcao
	opt=$(cat /tmp/opcao)
	case $opt in


        "HostA")
echo "
! -*- ospf -*-
!
! OSPFd sample configuration file
!
log stdout


hostname RoteadorD
password reverse
log file /var/log/quagga/zebra.log
log stdout
!
debug ospf event
debug ospf packet all
!
!
interface ${interface[1]}
!
interface lo
!
router ospf
!network 172.24.17.0/24 area 0.0.0.0
network 10.10.3.0/24 area 0.10.0.0
!
line vty
" > /etc/quagga/ospfd.conf

	;;

        "HostB")

echo "
! -*- ospf -*-
!
! OSPFd sample configuration file
!
log stdout


hostname RoteadorB
password reverse
log file /var/log/quagga/zebra.log
log stdout
!
debug ospf event
debug ospf packet all
!
!
interface ${interface[1]}
interface ${interface[2]}
!
interface lo
!
router ospf
!network 172.24.17.0/24 area 0.0.0.0
network 10.10.2.0/24 area 0.10.0.0
network 10.10.3.0/24 area 0.10.0.0
!
line vty
" > /etc/quagga/ospfd.conf

	;;

        "HostC")


echo "
! -*- ospf -*-
!
! OSPFd sample configuration file
!
log stdout


hostname RoteadorC
password reverse
log file /var/log/quagga/zebra.log
log stdout
!
debug ospf event
debug ospf packet all
!
!
interface ${interface[1]}
interface ${interface[2]}
!
interface lo
!
router ospf
!network 172.24.17.0/24 area 0.0.0.0
network 10.10.1.0/24 area 0.0.0.0
network 10.10.2.0/24 area 0.10.0.0
!
line vty
" > /etc/quagga/ospfd.conf
;;

        "HostD")

dialog	--title "Forwarder IPv4" \
					--inputbox "Favor digitar o Forwarder IPv4 (ex.: 8.8.8.8)" 0 0 2>/tmp/endipv4.conf
					ipborda=$(cat /tmp/endipv4.conf)

echo "
! -*- ospf -*-
!
! OSPFd sample configuration file
!
log stdout


hostname RoteadorC
password reverse
log file /var/log/quagga/zebra.log
log stdout
!
debug ospf event
debug ospf packet all
!
!
interface ${interface[1]}
interface ${interface[2]}
!
interface lo
!
router ospf
!network 172.24.17.0/24 area 0.0.0.0
network 10.10.1.0/24 area 0.0.0.0
network $ipborda area 0.0.0.0
!
line vty
" > /etc/quagga/ospfd.conf
        
	;;
	"VOLTAR")
	voltar
	;;

	*)
	echo "Opcao Errada"

	;;
	
        esac
}

#Menu Principal 
dialog	--title "Tela de Controle" \
	--menu "Escolha uma opcao:" 0 0 0 \
	"Experimento" "Configuracao automatica dos hosts do experimento NAT64/DNS64" \
	VOLTAR '' 2> /tmp/opcao
	opt=$(cat /tmp/opcao)
	case $opt in
		"Experimento")
			conf_automatica	
			;;
		"VOLTAR")
			voltar
			;;
		esac
