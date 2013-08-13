#!/bin/bash
echo "#########################################################################"
echo "The Following libraries/packages are required for queralyzer/mysql installation."
echo "If not present, please install them manually via apt-get"
echo "curl, cmake, g++, gcc, bison, scons, libaio1, build-essential, libreadline6-dev, libncurses5-dev"
echo "#########################################################################"
echo "Installing queralyzer...."

echo "Choose the mode of installation: auto (default) / custom :"
echo "I prefer auto mode."
read i_mode

if [ "$i_mode" == "custom" ]; then
    echo "Enter the path for installing queralyzer project"
    read q_dir
    echo "If MySQL-5.6 source code is present, please enter the path, else type 'no' "
    echo "For example if mysql is installed in /usr/local/mysql, just enter '/' (root) as usr/local/mysql is the set prefix for any standard installtion."
    read sql_dir

    # create the directory if doesn't exists
    if [ -d "$q_dir" ]; then
        if [ -L "$q_dir" ]; then
            # if symbolic link remove it.
            rm ${q_dir}
            fi
    else
        mkdir ${q_dir}
    fi

else
    q_dir=~/queralyzer_project
    sql_dir=~/queralyzer_project/mysql-source
    cd;
    mkdir -p ${q_dir}
    echo "Queralyzer project is being set in path: '$q_dir'"
    mkdir -p ${sql_dir}
    echo "MySQL source is being downloaded into path: '$sql_dir'"
    i_mode=auto
fi



# clone the queralyzer project from git hub.
cd ${q_dir}
git clone -b queralyzer_version_0.1 https://github.com/sans-sense/queralyzer.git
cd queralyzer
git pull
# creating the logs directory for queralyzer. And the libs directory.
mkdir ${q_dir}/queralyzer/logs
mkdir ${q_dir}/queralyzer/lib

# currently the UI project is not merged, hence cloning it too
cd ${q_dir}
git clone https://github.com/Shiti/queralyzerUI.git
cd queralyzerUI
git pull
cd ..


# First deal with MySQL 
# Downloading MySQL source
if [ "$sql_dir" == "no" ] || [ ! -d "$sql_dir" ] || [ "$i_mode" == auto ]; then
    echo "Installing MySQL-5.6"
    sql_dir=${q_dir}/mysql-source
    echo "setting up the MySQL source at path '$sql_dir'"
    mkdir "${sql_dir}"
    cd ${sql_dir}
    echo "Downloading mysql-5.6"
    curl -L -o mysql-5.6.13.tar.gz http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.13.tar.gz/from/http://cdn.mysql.com/

    gunzip -f mysql-5.6.13.tar.gz
    tar -xf mysql-5.6.13.tar

    # update the variable sql_dir
    sql_dir=${sql_dir}/mysql-5.6.13
    echo "MySQL 5.6 is downloaded in the path '$sql_dir'"

    # Using bzr for downloading the MySQL source code 
#    echo "Downloading mysql-5.6 source using bzr"
#    echo "This may take some time, depending on your internet connection"
#    bzr init-repo --trees "$sql_dir"
#    cd "$sql_dir"
#    bzr branch --use-existing-dir lp:mysql-server/5.6 mysql-5.6
    # creating a local branch for your own changes.
#    bzr branch mysql-5.6 mysql-5.6-build
    # update the source code 
#    cd mysql-5.6
#    bzr pull
fi

# By now we should have the source code available for MySQL
# Now building it.
cd ${sql_dir}

# before starting mysql build we need to apply the patch present in queralyzer.
cp -f ${q_dir}/queralyzer/mysql-5.6.10_patches/sql/* ${sql_dir}/sql/.

echo "Building the mysql, it may fail if dependant library are not present."
cmake -DWITH_EMBEDDED_SERVER=true -DWITH_DEBUG=1 -DCMAKE_INSTALL_PREFIX=${q_dir}/mysql-installation .

make 
if [ $? -ne 0 ]; then
    echo "make failed during mysql build"
    exit 1;
fi
make install
#DESTDIR=${q_dir}/mysql-installation
if [ $? -ne 0 ]; then
    echo "mysql installation failed"
    exit 1;
fi

sql_ins_dir=${q_dir}/mysql-installation

# Once the installation is done, create the data directory to be used by queralyzer.
mkdir -p ${q_dir}/mysql-installation/data2/test

# Downloading and installing the dependant library for queralyzer
echo "Downloading the required dependant library for queralyzer"
echo "Downloading and installing libhttpd"
cd ${q_dir}
curl -L -o libhttpd-1.4.tar.gz http://www.hughes.com.au/products/libhttpd/libhttpd-1.4.tar.gz
gunzip -f libhttpd-1.4.tar.gz
tar -xf libhttpd-1.4.tar
cd libhttpd-1.4
./configure
make all
make install

echo "Downloading and installing json-cpp library"
echo "You must have scons install to build json-cpp."
echo "If not install it from http://sourceforge.net/projects/scons/files/latest/download?source=files"
cd ${q_dir}
curl -L -o jsoncpp-src-0.5.0.tar.gz http://sourceforge.net/projects/jsoncpp/files/latest/download
gunzip -f jsoncpp-src-0.5.0.tar.gz
tar -xf jsoncpp-src-0.5.0.tar
cd jsoncpp-src-0.5.0
scons platform=linux-gcc

rm -f "${q_dir}/jsoncpp-src-0.5.0/libs/linux-gcc-4.7/libjson_linux-gcc-4.7_libmt.so"
cd ${q_dir}/queralyzer/src

QA_MYSQL_HOME=${sql_dir}
QA_JSONCPP_HOME=${q_dir}/jsoncpp-src-0.5.0
QA_HOME=${q_dir}/queralyzer
export QA_MYSQL_HOME
export QA_JSONCPP_HOME
export QA_HOME

make clean;
make;
echo "##############################################################################################################"
echo "Queralyzer is installed"
echo "The required binary is ${q_dir}/queralyzer/src/queralyzer "
echo "Important: Before running the executable edit the file ${q_dir}/queralyzer/src/my.init"
echo "Set the variable 'basedir' with the mysql installation path (mostly it will be ${sql_ins_dir})"
echo "Set the variable 'datadir' with the mysql installation path (mostly it will be ${sql_ins_dir}/data2)"
echo "Now to run the application use 'gdb ./queralyzer'"
echo "To access the UI browse the path http://127.0.0.1:1234/index.html"
echo "mysql logs would be generated at path ${q_dir}/queralyzer/logs"
echo "##############################################################################################################"













