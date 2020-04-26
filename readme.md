# Deploy Android Jenkins Agent and Emulator 

Esta guia describe el paso a paso para aprovisionar las dependencias requeridas para ejecutar el pipeline de mobile android en una instancia que sirva como agente de jenkins. 

### Update OS Instance

```bash
sudo apt update
```
### Install dependencies

```bash
sudo apt install -y openjdk-8-jdk wget unzip libglu1 libpulse-dev libasound2 libc6  libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxi6  libxtst6 libnss3
```

### Download android sdk tools

```bash
sudo mkdir /opt/android
```
```bash
sudo wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -P /tmp && sudo unzip -d /opt/android /tmp sdk-tools-linux-4333796.zip
```

### Set environment variables

Edit bash file to up environment in all shell sessions

```bash
sudo nano ~/.bashrc
```
And copy the following variables to the end of the file

```bash
export ANDROID_HOME=/opt/android
```
```bash
export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
```

###  Config sdkmanager

```bash
mkdir ~/.android/
```

```bash
touch ~/.android/repositories.cfg
```

```bash
yes Y | sdkmanager --licenses
```

## Deploy genymotion android emulator

Sigua la documentación a continuación para realizar el despliegue y conexion del emulador.

Android Emulator en una instancia ec2:
https://www.genymotion.com/blog/automate-aws-ec2-instances/

Conectar agente android de jenkins con el emulador:
https://docs.genymotion.com/paas/5.0/


## Install fastlane

Make sure to install Ruby 2.x version

```bash
sudo apt-add-repository ppa:brightbox/ruby-ng

sudo apt-get update
```

Install ruby 2.4 and gem

```bash
sudo apt-get install ruby2.4

sudo apt-get install ruby2.4-dev
```

Add fastlane bin

```bash
sudo gem install fastlane
```

Finally, check Fastlane been installed successfully

```bash
fastlane --version
```

## Create android emulator inside of instance

Download platform tools

```bash
yes Y | sdkmanager --verbose --no_https "system-images;android-R;google_apis;x86" "platforms;android-R" "platform-tools" "emulator"
```

Create AVD

```bash
echo "no" | avdmanager --verbose create avd --force --name "GOOGLE_PIXEL_EMULATOR" --device "pixel" --package "system-images;android-R;google_apis;x86"
```

## Run emulator 

```bash
emulator -avd "GOOGLE_PIXEL_EMULATOR" -verbose -no-boot-anim -no-window -gpu off -timezone America/Bogota &
```

## Check emulator status Up

```bash
echo $(adb wait-for-device shell getprop sys.boot_completed | tr -d '\r')
```

If return 1, the emulator is ready...

## Disable emulator animations

```bash
adb shell "settings put global window_animation_scale 0.0" 
adb shell "settings put global transition_animation_scale 0.0"
adb shell "settings put global animator_duration_scale 0.0"
```
