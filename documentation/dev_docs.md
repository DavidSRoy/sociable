# Developer Documentation

## Source code

- Clone the repo with git clone https://github.com/DavidSRoy/sociable.git 
- Open your terminal/command prompt and paste the url and hit enter
- The source code is copied or downloaded on your preferred location

## Layout of Directory

Backend
The API directory holds all the code pertaining to the backend APIs as well as some documentation 
The API/functions directory holds the actual API files and corresponding tests.

Frontend


## How to Build

### How to build if working with the messaging API:

Install the Firebase CLI
To use the Cloud Functions emulator, first install the Firebase CLI:

npm install -g firebase-tools

Then, 

firebase serve
firebase serve --only functions
firebase emulators:start --only=functions
firebase emulators:start

If you get an error saying "no active projects", run the above commands with the flag --project sociable

You can now use or try out the endpoints using the url provided after you run emulators:start

### How to build if working with XCode: 

## How to Test

## How to Add New Tests

## How to Build Release
Describe any tasks that are not automated. For example, should a developer update a version number (in code and documentation) prior to invoking the build system? Are there any sanity checks a developer should perform after building a release?
