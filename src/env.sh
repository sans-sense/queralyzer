#!/bin/bash

# setting up the variables required for installing queralyzer.
# mostly you can find them in it's makefile

QA_MYSQL_HOME=$1
QA_JSONCPP_HOME=$2
QA_HOME=$3

make

