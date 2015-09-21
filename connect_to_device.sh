#!/bin/bash

set -x

find /home/travis/build/ -name "*.apk"

adb devices -l

if [ "$(adb shell dumpsys power | grep mScreenOn= | grep -oE '(true|false)')" == false ] ; then
    echo "Screen is off. Turning on."
    adb shell input keyevent 26 # wakeup
    adb shell input touchscreen swipe 930 380 1080 380 # unlock
    echo "OK, should be on now."
else 
    echo "Screen is already on."
    echo "Turning off."
    adb shell input keyevent 26 # sleep
    adb shell input keyevent 26 # wakeup
    adb shell input touchscreen swipe 930 380 1080 380 # unlock
fi


adb shell pm list packages 

adb install /home/travis/build/snowch/android-tdd-playground/build/apk/android-tdd-playground-debug-unaligned.apk

adb shell pm list packages 

adb shell am start -a android.intent.action.MAIN -n org.pestrada.android_tdd_playground/.MainActivity

adb shell netstat -nalt

curl -v http://$(adb shell netcfg | grep 'eth0' | awk '{ print $3 }' | cut -d'/' -f1):8182
