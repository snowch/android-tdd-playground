#!/bin/bash

set -x

find /home/travis/build/ -name "*.apk"

adb devices -l

adb shell pm list packages 

adb install /home/travis/build/snowch/android-tdd-playground/build/apk/android-tdd-playground-debug-unaligned.apk

adb shell pm list packages 

adb shell am start -a android.intent.action.MAIN -n org.pestrada.android_tdd_playground/.MainActivity

adb shell netstat -nalt

curl -v http://$(adb shell netcfg | grep 'eth0' | awk '{ print $3 }' | cut -d'/' -f1):8182
