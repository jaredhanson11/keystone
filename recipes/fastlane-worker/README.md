# Fastlane Worker

## Description

Fastlane is a pipeline that enables for easy CI/CD pipelines for our Apps built by XCode.
This folder contains scripts/documentation on how to setup a worker node with fastlane.

## Prereq's

- MacOS
- XCode Tools
- XCode
- default shell is `/bin/bash`

## Dependencies

1. Install fastlane

```
$ sudo gem install fastlane -NV
```

2. Install CocoaPods

```
$ sudo gem install cocoapods
```

3. Install node from https://nodejs.org/en/download/

## Environment

1. Checkout source code

```
$ cd <path/to/folder>
$ git clone https://github.com/jaredhanson11/summn-misc
```

2. Adjust the directories and in the script `./fastlane-beta.sh` and place at `</path/to/folder>/fastlane-beta.sh` on machine

3. Set environment variables

```
$ echo "export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD=<app-specific-password>" >> ~/.bash_profile
$ echo "export SUMMN_MISC_PATH=<path/to/folder>/summn-misc" >> ~/.bash_profile
```

4. Run beta lane once to set apple id and password credentials

```
$ cd <path/to/folder>/summn-misc/SummnAppPrototype/ios/
$ bundle exec fastlane beta
```

## Scheduling

1. Open "Automator" app
2. Create new application
3. Select run shell script
4. Add the following to the shell script

```
#!/usr/bin/env bash
<path/to/folder>/fastlane-beta.sh > <path/to/folder>/"$(date).log"
```

5. Save the Automator app.
6. Goto System Preferences > Energy Saver > Schedule and schedule your mac to wakeup at 11:55pm
7. Add a calendar invite and in the alert section, select open file at time of event and set the Automator app file to open.
