#/usr/bin/env sh
if [ "$(id -u)" != "0" ]; then
	echo 'run this script as root';
else
	dirname=$(dirname "$0");
	modulepath=$(puppet master --configprint modulepath);
	puppet apply --modulepath="$modulepath:$dirname/modules:$dirname/roles:$dirname/operating_systems" "$@";
fi
