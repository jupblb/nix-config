#!/usr/bin/env sh
# https://www.reddit.com/r/bravia/comments/8v2s6i/guide_how_to_use_android_debugging_to_disable_apps/

adb shell pm uninstall -k --user 0 com.amazon.amazonvideo.livingroom
adb shell pm uninstall -k --user 0 com.google.android.play.games
adb shell pm uninstall -k --user 0 com.google.android.videos
adb shell pm uninstall -k --user 0 com.sony.dtv.interactivetvutil
adb shell pm uninstall -k --user 0 com.sony.dtv.interactivetvutil.output
adb shell pm uninstall -k --user 0 com.sony.dtv.sonyselect
adb shell pm uninstall -k --user 0 com.sony.dtv.networkapp.wifidirect
adb shell pm uninstall -k --user 0 com.sony.dtv.promos
adb shell pm uninstall -k --user 0 com.sony.dtv.youview
adb shell pm uninstall -k --user 0 com.vewd.core.integration.dia
adb shell pm uninstall -k --user 0 tv.samba.ssm
