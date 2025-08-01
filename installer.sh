#!/bin/bash
##setup command=wget -q "--no-check-certificate" https://raw.githubusercontent.com/ciefp/CiefpTvProgramA1HR/main/installer.sh -O - | /bin/sh

######### Only This 2 lines to edit with new version ######
version='1.1'
changelog='\nFix little bugs\nUpdated Picons List'
##############################################################

TMPPATH=/tmp/CiefpTvProgramA1HR

if [ ! -d /usr/lib64 ]; then
	PLUGINPATH=/usr/lib/enigma2/python/Plugins/Extensions/CiefpTvProgramA1HR
else
	PLUGINPATH=/usr/lib64/enigma2/python/Plugins/Extensions/CiefpTvProgramA1HR
fi

# check depends packges
if [ -f /var/lib/dpkg/status ]; then
   STATUS=/var/lib/dpkg/status
   OSTYPE=DreamOs
else
   STATUS=/var/lib/opkg/status
   OSTYPE=Dream
fi
echo ""
if python --version 2>&1 | grep -q '^Python 3\.'; then
	echo "You have Python3 image"
	PYTHON=PY3
	Packagesix=python3-six
	Packagerequests=python3-requests
else
	echo "You have Python2 image"
	PYTHON=PY2
	Packagerequests=python-requests
fi

if [ $PYTHON = "PY3" ]; then
	if grep -qs "Package: $Packagesix" cat $STATUS ; then
		echo ""
	else
		opkg update && opkg install python3-six
	fi
fi
echo ""
if grep -qs "Package: $Packagerequests" cat $STATUS ; then
	echo ""
else
	echo "Need to install $Packagerequests"
	echo ""
	if [ $OSTYPE = "DreamOs" ]; then
		apt-get update && apt-get install python-requests -y
	elif [ $PYTHON = "PY3" ]; then
		opkg update && opkg install python3-requests
	elif [ $PYTHON = "PY2" ]; then
		opkg update && opkg install python-requests
	fi
fi
echo ""

## Remove tmp directory
[ -r $TMPPATH ] && rm -f $TMPPATH > /dev/null 2>&1

## Remove old plugin directory
[ -r $PLUGINPATH ] && rm -rf $PLUGINPATH

# Download and install plugin
# check depends packges
mkdir -p $TMPPATH
cd $TMPPATH
set -e
if [ -f /var/lib/dpkg/status ]; then
   echo "# Your image is OE2.5/2.6 #"
   echo ""
   echo ""
else
   echo "# Your image is OE2.0 #"
   echo ""
   echo ""
fi
   wget https://github.com/ciefp/CiefpTvProgramA1HR/archive/refs/heads/main.tar.gz
   tar -xzf main.tar.gz
   cp -r 'CiefpTvProgramA1HR-main/usr' '/'
set +e
cd
sleep 2

### Check if plugin installed correctly
if [ ! -d $PLUGINPATH ]; then
	echo "Some thing wrong .. Plugin not installed"
	exit 1
fi

rm -rf $TMPPATH > /dev/null 2>&1
sync
echo ""
echo ""
echo "#########################################################"
echo "#         CiefpTvProgramA1HR INSTALLED SUCCESSFULLY     #"
echo "#                  developed by ciefp                   #"
echo "#                   Big thanks Qu4k3                    #"
echo "#                  .::ciefpsettings::.                  #"
echo "#                  https://Sat-Club.EU                  #"
echo "#########################################################"
echo "#           your Device will RESTART Now                #"
echo "#########################################################"
sleep 5
killall -9 enigma2
exit 0
