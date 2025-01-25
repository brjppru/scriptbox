# udev #

https://github.com/roberfoster/android-udev-rules

# Clone this repository
git clone https://github.com/M0Rf30/android-udev-rules.git
# Copy rules file
sudo cp -v ./android-udev-rules/51-android.rules /etc/udev/rules.d/51-android.rules
# OR oreate a sym-link to the rules file - choose this option if you'd like to update your udev rules using git.
sudo ln -sf $PWD/android-udev-rules/51-android.rules /etc/udev/rules.d/51-android.rules
# Change file permissions
sudo chmod a+r /etc/udev/rules.d/51-android.rules
# add the adbusers group if it's doesn't already exist
sudo groupadd adbusers
# Add your user to the adbusers group
sudo usermod -a -G adbusers $(whoami)
# Restart UDEV
sudo udevadm control --reload-rules
sudo service udev restart
# Restart the ADB server
adb kill-server
# Replug your Android device and verify that USB debugging is enabled in developer options
adb devices
# You should now see your device

