# Developer Documentation

## Source code

- Clone the repo with `git clone https://github.com/DavidSRoy/sociable.git`
- Open your terminal/command prompt and paste the url and hit enter
- The source code is copied or downloaded on your preferred location

## Layout of Directory
    root
       |--- .github: contains CI/CD workflows
       |
       |--- documentation: contains user and developer documentation
       |
       |--- meeting notes: contains important notes for reference from certain meetings.
       |
       |--- reports: contains our weekly status updates
       |
       |--- API:         holds all the code pertaining to the backend APIs as well as some documentation
           |                   
           |
           |--- functions:           holds the actual API files
                      |
                      |--- test:           holds the tests for the API files
       |
       |--- iOS:    holds all the code pertaining to frontend
           |
           |--- Sociable:       app screens, components, business logic (views, viewmodels); app icons
           |
           |--- SociableTests & SociableUITests:        frontend tests
           |--- ExportOptions(-AdHoc).plist:          * used when exporting app
                                                        needed for automatic TestFlight deployment
           |--- Sociable.xcodeproj:                     metadata and build settings of Xcode project, 
                                                        detected as a file instead of directory on system

#### Backend
The `API` directory holds all the code pertaining to the backend APIs as well as some documentation 
The `API/functions` directory holds the actual API files and corresponding tests, which can be found in `API/functions/test`

#### Frontend
\*AdHoc export/installation requires device UDID to be added to developer profile,
refer to this [guide](https://support.magplus.com/hc/en-us/articles/204270188-iOS-Creating-an-Ad-Hoc-Distribution-Provisioning-Profile)

## How to Build

### How to build if working with the messaging API:

Install the Firebase CLI
To use the Cloud Functions emulator, first install the Firebase CLI:

`npm install -g firebase-tools`

Then, 

```
firebase emulators:start --only=functions
firebase emulators:start
```

If you get an error saying "no active projects", run the above commands with the flag `--project sociable`

You can now use or try out the endpoints using the url provided after you run `firebase emulators:start`

### How to build if working with Xcode: 

Press on the play button on the top left of Xcode to build the project.

Building the frontend can also be done via command-line using `xcodebuild` while in the iOS directory.

## How to Test

### Backend
Run `pytest ???auth=???<API_KEY>???` from the API or functions directory. Replace `<API_KEY>` with the API key, which can be obtained by running `firebase functions:config:get` and using the value associated with `messaging`.

### Frontend
Long hold on the play (build) button for a test option in Xcode.

For command line, `xcodebuild test` or `xcodebuild test-without-building` to execute the test files under `SociableTests` and `SociableUITests` directories.
Append option `-scheme Sociable` and if needed, `-destination 'platform=iOS Simulator,name=DEVICE'` where `DEVICE` should be substituted with an iOS device string such as `iPhone 13 Pro Max`. 

For a list of `DEVICE` destinations, run `xcrun xctrace list devices`. iOS versions can be specified by adding key-value pair `OS=x.x` after `name=DEVICE`, but most likely the preinstalled destinations have the latest firmware (e.g. `OS=15.4`).

Running a single unit test can be done by appending with flag `-only-testing <test-identifier>` where `<test-identifier>` is provided in the form: _TestTarget[/TestClass[/TestMethod]]_ (e.g. `SociableTests/SociableUITestsLaunchTests/testLaunch`)

## How to Add New Tests

### Backend
Tests are stored in the `API/functions/test directory`. To add a new test, create a new function within the appropriate test file. Test functions should be named according to the following convention:

`test_[API]_[function being tested]_[expected result and test condition]`

Example: 
`test_messaging_getUsers_returns401WithoutAuth()`

### Frontend

The [XCTest framework](https://developer.apple.com/documentation/xctest) will be used natively on Xcode. 

Create funcs (prefixed with `test`) within the appropriate testing class file, where the func name should make clear of the tested behavior (e.g. `testLoginFlow`, `testValidateMessagingScreenUIInteractions`). More general naming should indiciate greater exhaustive testing, so `testLoginFlow` should indicate it tests for both success and failure. 

For larger or more specific test suites, a new XCTest class can be created under the appropriate test target directory if necessary. 

If applicable, group atomic funcs together under a broader test suite. For example:
```
func testValidateMessagingScreenUIInteractions() {
  testSelectImageUpdatesImageVar()
  testOfflineMessageSendShowsNotDelivered()
  ...
}
```

## How to Build Release
Make sure you have npm installed. Also make sure you have the latest version 8.10.0.
A sanity check you should perform after building a release is try calling the messaging endnpoints using an application such as Postman.

For each app update to TestFlight, TAG the commit with prefix `v` (e.g. `v1.0.0`) and increment the build number by 1 under the Xcode project BEFORE pushing to GitHub so the CD workflow will trigger and successfully finish. Use the same version number as the prior release build unless discussed prior with team members. Ideally validate expected behavior on a physical device before pushing a release build to GitHub/TestFlight, and also afterwards as a sanity check. Be sure to note any bugs or discrepancies. 
