#!/bin/bash

function wait_emulator_to_be_ready() {
  adb devices | grep emulator | cut -f1 | while read line; do adb -s $line emu kill; done
  emulator -avd "GOOGLE_PIXEL_EMULATOR" -verbose -no-boot-anim -no-window -gpu off -timezone America/Bogota &
  
  boot_completed=false
  while [ "$boot_completed" == false ]; do
    status=$(adb wait-for-device shell getprop sys.boot_completed | tr -d '\r')
    echo "######### Waiting for the emulator status up......... Boot Status: $status"
    if [ "$status" == "1" ]; then
      boot_completed=true
      break
    fi
    sleep 1
  done
}

function disable_animation() {
  adb shell "settings put global window_animation_scale 0.0"
  adb shell "settings put global transition_animation_scale 0.0"
  adb shell "settings put global animator_duration_scale 0.0"
}

wait_emulator_to_be_ready
sleep 1
disable_animation
