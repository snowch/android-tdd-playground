#!/bin/bash

set -x

adb shell netstat -nalt

curl -v http://$(adb shell netcfg | grep 'eth0' | awk '{ print $3 }' | cut -d'/' -f1):8182
