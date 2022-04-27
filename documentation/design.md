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
- sending a message via the Messaging API will facilitate near real-time communication. The message would be sent to Firestore via the API. The recipient device would call the API every period (maybe 30 seconds) to check for new messages.
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
		- It becomes harder to analyze messages from a large group of users (or implement a group chat functionality). For group chats, messages would now have to be deuplicated and stored in each user's document. If all messages were stored in one Messages collection, it would be easier to filter for messages addressed to users in a particular group chat.
		
## Software Design

For iOS App, we are using 'Xcode' as the paltform to work on for UI. We use 'figma' to design different screems of the app and code them into Xcode.


## Coding Guideline

Swfit Style Guide: https://google.github.io/swift/ 
<br> 
Javascript Style Guide: https://google.github.io/styleguide/jsguide.html 

## Process Description (revisions)

## i. Risk assessment

Low likelihood of occuriing 

- Risk 1: Database exceeds quota
	- Impact: Medium
	- Firebase states that we have a free tier quota of 11GB, which will be pretty hard to fill given that our strategy is to delete messages after they are read. However, it is possible for the 11GB to be filled if we have a very large amount of users using the app at the same time.
	- Steps to avoid this: All messages will be deleted from the database after being read by the recipient and unread messages that are older than 4 weeks will be deleted (and the user will therefore not receive them).
	- Plan: A storage alert will be set up in Firebase so that we will be notified if we are at 90% capacity. At that point, we will start deleting unread messages at a smaller interval (i.e 2 weeks).

- Risk 2: Function exceeds quota 
	- Impact: High
	- Firebase states that we have a free tier limit on how many times we can invoke our function per month (2 million invocations). While the likelihood of this occuring is low, it could occur if we have a large user base. It could also occur if we keep calling a particular function (such as one that reads the database every second) on a short interval. 
	- Steps to avoid this: We will avoid having intervals that would result in a high invocation count. In other words, if we choose to use the Messaging API to get updates from the database, we will avoid calling the API more than once per 30 seconds (or another interval if needed).
	- Plan: We can monitor the function invocation count via the Firebase dashboard.

Medium Likelihood of occurring 

- Risk 3: Setbacks in building the backend infrastructure (i.e trouble with handling images or files, or issues with file compression)

- Risk 4: Potential issues with JSON data

- Risk 5:

Risk 1-4 are similar to what we expected while writing the Requirements document. Going forward, we didn't forsee any change from what we exepected at the start. 

## ii. Project schedule

Currently we have all the separte teams ready with their setup - XCode for frontend and ... for backend. 

We are working on the login and messaging UI ready by the frontend team and the API by the backend and the fullstack to integrate that in order to demonstrate the use case of messaging between 2 users by the end of this week! 

We plan to release our beta version on or before 05/10. Frontend team should be ready with the screens UI and the workflow between them and the backend should be ready with the API. Integrarting all of that with the help of the fullstack team, we should be ready for our beta release.   

| Milestone (use case) | Description 				| Date (Thursdays)  | Frontend  		     | Backend 		| Fullstack  |
| -----------          | ----------- 				| ---------	    |-----------		     |------------	|----------- |
| Messaging 	       | The user should be able to send messages to their friends       	| 04/28 	    | login screen, messaging screen | `sendMessage` and `getMessage` endpoints| integration|
| Status       	       | The user will be able to update text or picture status which will last for 24 hours					| 05/05		    | status, my profile screens     |`sendStatus` and `getStatus` endpoints| integration|
| Beta release         | In accordance to the assignment, we want to have a beta release ready by 05/10  for which documentation is ready					| 05/10             | -				     |  -                | integration|
| Adding friends       | Being able to add friends by searching their account names       				| 05/12             | profile, mutual friends screen |`addFriend` and `getFriends` endpoints| integration|

The frontend and backend will work separately and the fullstack are dependent on the completion of both teams before integration. All milestones are independent of each other and are supposed to be completed in order. 

## iii. Team structure

Frontend - 

	Frontend is mainly working on creating mockup screens on figma and coding their separte assigned screens. 

	Kevin is done with creating the login screen and plans to work on ... next. 

	Abas is working on the messaging screen.

	Riya is done with the XCode instalation and working on the setup and integration currently. Next milestone is to work on my profile/statuses screen. 

Backend - 

	David is working on building and maintaining the Messaging API, so that it is capapble of delivering messages between users. He will also work on setting up the CI/CD pipelines for the Messaging API, such that test pipelines will run upon creating a pull request and anything pushed to master will be automatically deployed to production.

	Anna is working on ... 

Fullstack - 

	Sulaiman is working on xcode setup as well as helping Abas on messaging screen.

## iv. Test plan & bugs

## v. Documentation plan

We plan to have 'user guides' ready simultaneously as we implement UI and beackend features. Mainly they will be edited by the frontend team but necessary backend featires can be added by the backend team. However, the workflow will be that each person of the frontend team will contribute to it equally as they implement different screens, they will write the 'user guide' for that. Finally, the frontend will meet to integrate the workflow of different screens and document that in the 'user guide'. 

## Other Revisions

+ Use cases provide a good sense of what the user experience will be like
	- We added use cases late last week to the living document. 
	
+ Considers a lot of project-specific risks
	- We considred potential issues with JSON data (since we are using JSON, it is crucial for JSON data to be organized appropriately or
else it might lead to excessive layering, causing issues when we’re trying to
retrieve data and write data). Details on this are in our living document.

+ Missing use policies for each communication channel
	- This has been fixed in the living document.  




