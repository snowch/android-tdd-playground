#!/bin/bash

set -x

ANDROID_TARGET=android-19  
ANDROID_ABI=armeabi-v7a

echo no | android create avd --force -n test -t $ANDROID_TARGET --abi $ANDROID_ABI
emulator -avd test -no-skin -no-audio -no-window &
adb wait-for-device
adb shell input keyevent 82 &

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

adb get-state

adb shell pm list packages 

adb install /home/travis/build/snowch/android-tdd-playground/build/apk/android-tdd-playground-debug-unaligned.apk

adb shell pm list packages 

adb shell am start -a android.intent.action.MAIN -n org.pestrada.android_tdd_playground/.MainActivity

adb shell netstat -nalt

curl -v http://$(adb shell netcfg | grep 'eth0' | awk '{ print $3 }' | cut -d'/' -f1):8182
