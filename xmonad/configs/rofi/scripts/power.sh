OPTIONS="\tShutdown\n\tReboot\n鈴\tHibernate\n"

option=`echo -e $OPTIONS | awk '{print $1}' | tr -d '\r\n\t'`
if [ "$@" ]
then
	case $@ in
		*Shutdown)
			shutdown now
			;;
		*Reboot)
			reboot
			;;
    *Hibernate)
     systemctl hibernate
     ;;
	esac
else
	echo -e $OPTIONS
fi

