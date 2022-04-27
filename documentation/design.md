# Architecture and Design


## Software Architecture
* Frontend
	* iOS App
* Backend
	* Messaging API
	* Firebase
		* Cloud Firestore (Database)
		* Firebase Authentication
The Frontend will be our iOS App. The Backend will consist of the Firebase suite and the Messaging API, which will be used to connect the frontend to Firebase. The app will communicate with the API in order to send and receive messages on behalf of a user.
Data will be stored in the Cloud Firestore (a non-relational database). User authentication will be done via Firebase Authentication (and will not require communication with the backend. Instead, the frontend will be able to directly invoke Firebase Authentication, for the sake of simplicity). 
Data Stored:
Collections
- USERS
	- User ID
	- first name
	- last name
	- date of birth
	- gender
	- messages
		- message
		- sender (uid)
		- timestamp
	- friends (uids)
	- bio message (100 chars)
	- profile pic reference
- STATUS
	- author (uid)
	- content
User information will be collected upon creating an account. The messages field will be constantly updated as new messages are sent and received. The profile pic field will be a reference to the actual image in Firebase Cloud Storage.

### Assumptions
- Sending a message via the Messaging API will facilitate near real-time communication. The message would be sent to Firestore via the API. The recipient device would call the API every period (maybe 30 seconds) to check for new messages.
### Decisions and Alternatives
- Using an Intermediate API
	- We chose to have our frontend communicate with Firebase via our Messaging API. An alternative would have been to have the frontend communicate with Firebase directly. 
		- Pros:
			- Save development time by not having to implement an API
			- Increased response times as the frontend can directly contact Firebase and receive a direct response as opposed to going through an API and having it make a request on behalf of the frontend.
		- Cons:
			- Having the frontend communicate directly with Firebase (i.e Firestore [database] and Cloud Storage) means that the frontend could potentially make dangerous requests without any checks by another party. For example, a bug in the frontend code could lead to data being deleted directly from the production database. 
			- Cannot customize the response model. The frontend would be forced to parse the data in the format returned by Firebase. However, having an API allows the developers to customize the response model and only return the data that is necessary. 

- Storing Messages within the each User Document
	- We chose to have messages be stored in the recipient user's document as opposed to having a separate collection for messages.
	- Pros:
		- It is easy to see who a message belongs to (ie who the recipient is) since the message is already in that user's document (kind of like an inbox).
	- Cons:
		- It becomes harder to analyze messages from a large group of users (or implement a group chat functionality). For group chats, messages would now have to be duplicated and stored in each user's document. If all messages were stored in one Messages collection, it would be easier to filter for messages addressed to users in a particular group chat.
		
## Software Design

* Frontend
	*  The messaging bubbles will be represented as their own class. 
	*  The text within the bubbles and the color of the bubbles will depend on the sender of the message and the message itself 
	* Contacts will also be represented as objects, that will be displayed on contacts screen 
	* Since we will be using firebase and our node js endpoints to handle message transactions, we will not need to rely on any third party libraries and SwiftUI paired with the Swift Standard Library should suffice for all of our messaging frontend needs
	* We will also use Figma to create mockups for our app screens and a tool called Monday Hero to help convey the elements to design components  

* Backend
	* Messaging API
		* We use Node.js, to support our non-blocking, event-driven server that enables our backend API. The responsibility of Node.js is to support the use of endpoints to send and get data. It is crucial for implementing our real-time, push-based architecture. 
* In the repo, we have reserved a folder for all the API functionality. Within the folder, we have a subfolder for the functions. These functions are responsible for creating the endpoints that will enable the app to communicate with the backend to send and retrieve messages and user data. Within index.js, we have implemented the functions: send (sends a user’s message data to storage space), getMessages (retrieves the messages of uid current user), getUsers (which gets the authenticated users).
	* Firebase
		* To enable Firebase in our app, we have installed dependencies and libraries according to the Firebase docs.
		* Cloud Firestore (Database). The responsibility of the database is to store the user data and their corresponding messages. These will be stored in the form of “collections”.
		* Firebase Authentication. User authentication will be done via Firebase Authentication. Firebase will enable authentication using username and password, phone, and Google authentication. The responsibility of authentication is to verify the user’s passed in data against the fields in the database. Its purpose is to protect the app from data leaks and unverified access to user data.

## Coding Guideline

Swift Style Guide: https://google.github.io/swift/ 
<br> 
Javascript Style Guide: https://google.github.io/styleguide/jsguide.html 

## Process Description (revisions)

## i. Risk assessment

Low likelihood of occurring 

- Risk 1: Database exceeds quota
	- Impact: Medium
	- Firebase states that we have a free tier quota of 11GB, which will be pretty hard to fill given that our strategy is to delete messages after they are read. However, it is possible for the 11GB to be filled if we have a very large amount of users using the app at the same time.
	- Steps to avoid this: All messages will be deleted from the database after being read by the recipient and unread messages that are older than 4 weeks will be deleted (and the user will therefore not receive them).
	- Plan: A storage alert will be set up in Firebase so that we will be notified if we are at 90% capacity. At that point, we will start deleting unread messages at a smaller interval (i.e 2 weeks).

- Risk 2: Function exceeds quota 
	- Impact: High
	- Firebase states that we have a free tier limit on how many times we can invoke our function per month (2 million invocations). While the likelihood of this occurring is low, it could occur if we have a large user base. It could also occur if we keep calling a particular function (such as one that reads the database every second) on a short interval. 
	- Steps to avoid this: We will avoid having intervals that would result in a high invocation count. In other words, if we choose to use the Messaging API to get updates from the database, we will avoid calling the API more than once per 30 seconds (or another interval if needed).
	- Plan: We can monitor the function invocation count via the Firebase dashboard.

- Risk 3: Setbacks in building the backend infrastructure (i.e trouble with handling images or files, or issues with file compression)
	- Likelihood: Medium 
	- Impact: High
	- Uploading data other than text might pose a challenge. We need to try uploading and handling the situation where the user sends or tries to retrieve images or videos. From past experience, as long as the traffic is not too high, uploading images is not a problem.
	- To reduce the impact, we will design test cases where the user uploads multiple images and retrieves multiple images at the same time.
	- Our mitigation plan is to disable uploading and sharing of images and videos until the problem has been resolved. Some users might lose data, but we will reduce the amount of data lost by blocking the function for the time being.

- Risk 4: Potential issues with JSON data
	- Likelihood: Medium
	- Impact: High
	- Evidence upon which you base your estimates, such as what information you have already gathered or what experiments you have done: We’ve experienced important data loss with respect to user data while working on or endpoints
	- Steps you are taking to reduce the likelihood or impact, and steps to permit better estimates: Drawing out the json tree and making sure it’s being parsed correctly during the development process (ie through debugging).
	- Plan for detecting the problem (trivial example: running automated tests to determine that a file format has changed): We will create a robust set of unit tests to ensure all information was received for all operations that rely on API calls
	- Mitigation plan should it occur: We will revisit the parsing of the JSON data and ensure it is parsed correctly. We will double check against the data as well.

- Risk 5: Failure to address security concerns in relation to messaging
	- Likelihood: Medium
	- Impact: High
	- Evidence upon which you base your estimates, such as what information you have already gathered or what experiments you have done: We’ve gathered that Firebase has security vulnerabilities that could expose sensitive user and messaging data if not prevented 
	- Steps you are taking to reduce the likelihood or impact, and steps to permit better estimates: Encrypting/Hashing sensitive information 
	- Plan for detecting the problem (trivial example: running automated tests to determine that a file format has changed): Robust automated System tests that attempt to extract sensitive info 
	- Mitigation plan should it occur: Send push notification to users informing them of the breach and use the testing mechanisms in place to identify the breach

Risk 1-4 are similar to what we expected while writing the Requirements document. Going forward, we didn't foresee any change from what we expected at the start. 

## ii. Project schedule

Currently we have all the separate teams ready with their setup - Xcode for frontend and ... for backend. 

We are working on the login and messaging UI ready by the frontend team and the API by the backend and the fullstack to integrate that in order to demonstrate the use case of messaging between 2 users by the end of this week! 

We plan to release our beta version on or before 05/10. Frontend team should be ready with the screens UI and the workflow between them and the backend should be ready with the API. Integrating all of that with the help of the fullstack team, we should be ready for our beta release.   

The frontend and backend will work separately and the fullstack are dependent on the completion of both teams before integration. All milestones are independent of each other and are supposed to be completed in order. 

## iii. Team structure

### Frontend -

Frontend is mainly working on creating mockup screens on Figma and coding their separate assigned screens.

Kevin is done with creating the login and signup flow and plans to work on another set of essential screens next (e.g. main chat interface). 

Abas is working on the messaging screen.

Riya is done with the Xcode installation and working on the setup and integration currently. Next milestone is to work on my profile/statuses screen. 

### Backend - 

David is working on building and maintaining the Messaging API, so that it is capable of delivering messages between users. He will also work on setting up the CI/CD pipelines for the Messaging API, such that test pipelines will run upon creating a pull request and anything pushed to master will be automatically deployed to production.

Anna is working on maintaining the group project kanban board, adding tasks and updating tasks as the team progresses. Will work on the messaging API, Firebase user authentication and data storage.

### Fullstack - 

Sulaiman is working on Xcode setup as well as helping Abas on messaging screen.

## iv. Test plan & bugs

### Frontend -

Will mainly utilize hallway testing as usability testing for UI concerns and adjustments so that real world feedback is provided. Each member will do so such that there is a variety of feedback from different backgrounds. Written use cases will also be compared against the user interaction flow to ensure consistency with what has been proposed.

### Backend -

Will mainly be concerned about unit testing by creating atomic and combined use cases to ensure correct and expected behavior when communicating with Firebase such as handling user authentication and creation, and reading and writing to the database. May also be responsible for conducting unit tests with the messaging API, possibly with the support of the fullstack team.

### Fullstack -

Will mainly be concerned about testing integration from the perspective of the system and as the user. One example is ensuring the application correctly handles the backend responses (successes or various errors) that does not hinder the user experience.

### Specific details and plan -

We will create test suites to test basic messaging, mutual connection behavior and various other components that rely on front end components. We will utilize Xcode’s unit testing support and code coverage monitoring tools to optimize the efficacy of our tests. We will also frequently perform usability tests as we build and ship features to avoid bugs. We will run tests within the Xcode playground and play out various scenarios such as phone 1 logged into account a sending a message to phone 2 logged into account b. We will also have many different error checks in place within the node js endpoints and those in conjunction with fire base errors, and Xcode’s built in debugger should provide us with a powerful toolset for fixing and preventing bugs.

**GitHub Issues will be used to track bugs that occur during use and testing.**

## v. Documentation plan

As the backend team creates endpoints, we will create markdown documents with the purpose of describing each function. We will provide documentation on the input parameters, return value and return value format, and error handling that is useful when calling the function. We plan to provide an example call to the endpoint to guide the caller in using the function. We plan to organize all the supporting documentation into a central folder that will be pushed to Github so the team can access. As for the front end team, we also plan on creating a user guide, which will detail some of the inner workings of our application on a high level, device requirements and a quick start guide. Furthermore, for the frontend, we will rely on our well commented Swift protocols/interfaces to serve as documentation for all our major classes. We will also write comments to explain complex operations. 

## Other Revisions

+ Use cases provide a good sense of what the user experience will be like
	- We added use cases late last week to the living document. 
	
+ Considers a lot of project-specific risks
	- We considered potential issues with JSON data (since we are using JSON, it is crucial for JSON data to be organized appropriately or
else it might lead to excessive layering, causing issues when we’re trying to
retrieve data and write data). Details on this are in our living document.

+ Missing use policies for each communication channel
	- This has been fixed in the living document.  
