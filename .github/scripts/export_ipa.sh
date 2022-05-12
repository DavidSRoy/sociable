#!/bin/bash

set -eo pipefail

xcodebuild -archivePath iOS/build/Sociable.xcarchive \
            -exportOptionsPlist iOS/exportOptions.plist \
            -exportPath iOS/build \
            -allowProvisioningUpdates \
            -exportArchive | xcpretty
