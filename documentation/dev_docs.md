# Developer Documentation

## Source code

- Clone the repo with git clone https://github.com/DavidSRoy/sociable.git 
- Open your terminal/command prompt and paste the url and hit enter
- The source code is copied or downloaded on your preferred location

## Layout of Directory

- Frontend


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
Make sure you have npm installed. Also make sure you have the latest version 8.10.0.
A sanity check you should perform after building a release is try calling the messaging endnpoints using an application such as Postman.
