#!/bin/bash

set -eo pipefail

xcodebuild -scheme Sociable \
	    -archivePath iOS/build/Sociable.xcarchive \
            -workspace iOS/Sociable.xcodeproj/project.xcworkspace \
	    -exportOptionsPlist iOS/exportOptions.plist \
            -exportPath iOS/build \
            -allowProvisioningUpdates \
            -exportArchive | xcpretty
