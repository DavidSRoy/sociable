#!/bin/bash

set -eo pipefail

cd iOS && xcodebuild -scheme Sociable \
                        -sdk iphoneos \
                        -configuration AppStoreDistribution \
                        -archivePath $PWD/build/Sociable.xcarchive \
                        clean archive | xcpretty
