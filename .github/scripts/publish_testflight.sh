#!/bin/bash

set -eo pipefail

xcrun altool --upload-app -t ios -f iOS/build/Sociable.ipa -u "$APPLEID_USERNAME" -p "$APPLEID_PASSWORD" --verbose
