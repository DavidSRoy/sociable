# Sociable: The Social Messenger

## About
Introducing Sociable, a chat app that’s similar to Messenger or Whatsapp but one that’s more geared for social interaction. The application would support many of the same features as your typical chatting app such as adding contacts/friends, sending messages to other users, group chat capabilities etc. However, Sociable would also share a robust set of features that would enhance the social component of the application. Some of these features include allowing users to see and connect with mutual friends, creating profiles complete with bios and pictures, post statuses, seeing other users on a map and also interacting with them via location-based chat. 

## Operational Use Cases
- create account using name, password and birthday
- login using username and password  
- reset password by clicking on "forgot password"
- message a friend by typing in the message box and hitting send
- chat can be done between 2 mutual friends  

## Project Documentation
**[Living Document](https://docs.google.com/document/d/18q35KYiigKOfsqSOqhWPQcTrDo5ftMfcEexdkJ5XZM0/edit?usp=sharing)**

**[User Manual](https://github.com/DavidSRoy/sociable/blob/master/documentation/user_docs.md)**

**[Developer Docs](https://github.com/DavidSRoy/sociable/blob/master/documentation/developer_docs.md)**

## Build and Testing System
The backend can be tested by running `pytest --auth '<TOKEN>'` while in the directory API/functions. Replace `<TOKEN>` with the API key.
  
Install [Xcode](https://developer.apple.com/xcode/), then be sure to choose and open the `iOS/` directory within the repository folder.
Press (or long hold) on the play button on the top left to build and run tests.
Build and testing the frontend can also be done via command-line using `xcodebuild` and appending `test` while in the iOS directory.
Refer to [dev docs](https://github.com/DavidSRoy/sociable/blob/docs/documentation/dev_docs.md) for additional information.

## Accessing Beta Version
Beta testers have received an invite via TestFlight, where the beta version can be downloaded. If you have not received an invite and would like one, please contact a team member. You will need to receive and accept two invites - one for App Store Connect and another for TestFlight (the first is required since the app has not gone through App Store Review process).

## Running System
Xcode has emulators that can run the project code and compile the app.
The app can also be downloaded via TestFlight to a physical device, but a TestFlight invitation is required.

## Test Directories
**[Backend](https://github.com/DavidSRoy/sociable/tree/master/API/functions/test)** - `API/functions/test`

**[Frontend](https://github.com/DavidSRoy/sociable/tree/master/iOS)** - `iOS/SociableTests` & `iOS/SociableUITests`

## Bug Tracking

**How to Report a Bug**
If a crash occurs while using the app downloaded from TestFlight, an alert may show asking to submit information to the developers.

In the app details on TestFlight, you can report under Send Beta Feedback.

Since GitHub Issues is being used to track and report bugs under development, you can open a new issue there as well.

For any of these options, please include details and steps to reproduce the bug and any screenshots if necessary.

**Known Bugs**
* Messaging Screen displays messages in the incorrect order
* Messages Screen displays duplicate messages
* Messaging Screen View is not updated right away after the send button is pressed
* Login/User creation workflow has not yet been integrated with the endpoints

## How to Contribute
Check out our [developer documentation](https://github.com/DavidSRoy/sociable/blob/docs/documentation/dev_docs.md) in the `documentation` directory

## Team Members
**[David Roy](https://github.com/DavidSRoy)**, Backend

**[Anna Thomas](https://github.com/athomas9195)**, Backend, Kanban Board Manager

**[Abas Hersi](https://github.com/abis206)**, Fullstack

**[Kevin Choi](https://github.com/0xMango)**, Frontend

**[Riya Dheer](https://github.com/riyaDheer)**, Frontend

**[Sulaiman Mahmood](https://github.com/sulaiman-cse-uw)**, Fullstack 
