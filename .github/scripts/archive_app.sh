#!/bin/bash

set -eo pipefail

cd iOS && xcodebuild -scheme Sociable \
                        -workspace Sociable.xcodeproj/project.xcworkspace
                        -sdk iphoneos \
                        -configuration Release \
                        -archivePath $PWD/build/Sociable.xcarchive \
                        clean archive | xcpretty
