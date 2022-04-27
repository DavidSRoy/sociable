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

## Coding Guideline

Swfit Style Guide: https://google.github.io/swift/ 
<br> 
Javascript Style Guide: https://google.github.io/styleguide/jsguide.html 

## Process Description (revisions)

## i. Risk assessment

Low likelihood of occuriing 

- Risk 1: Database exceeds quota

- Risk 2: Function exceeds quota 

Medium Likelihood of occurring 

- Risk 3: Setbacks in building the backend infrastructure (i.e trouble with handling images or files, or issues with file compression)

- Risk 4: Potential issues with JSON data

- Risk 5:

## ii. Project schedule

Currently we have all the separte teams ready with their setup - XCode for frontend and ... for backend. 

We are working on the login and messaging UI ready by the frontend team and the API by the backend and the fullstack to integrate that in order to demonstrate the use case of messaging between 2 users by the end of this week! 

We plan to release our beta version on or before 05/10. Frontend team should be ready with the screens UI and the workflow between them and the backend should be ready with the API. Integrarting all of that with the help of the fullstack team, we should be ready for our beta release.   

| Milestone (use case) | Description 				| Date (Thursdays)  | Frontend  		     | Backend 		| Fullstack  |
| -----------          | ----------- 				| ---------	    |-----------		     |------------	|----------- |
| Messaging 	       | The user should be able to        	| 04/28 	    | login screen, messaging screen |	                | integration|
| Status       	       | 					| 05/05		    | status, my profile screens     |                  | integration|
| Beta release         | 					| 05/10             | -				     |                  | integration|
| Adding friends       | Title       				| 05/12             | profile, mutual friends screen |			| integration|

The frontend and backend will work separately and the fullstack are dependent on the completion of both teams before integration. All milestones are independent of each other and are supposed to be completed in order. 

## iii. Team structure

Frontend - 

	Frontend is mainly working on creating mockup screens on figma and coding their separte assigned screens. 

	Kevin is done with creating the login screen and plans to work on ... next. 

	Abas is working on the messaging screen.

	Riya is done with the XCode instalation and working on the setup and integration currently. Next milestone is to work on my profile/statuses screen. 

Backend - 

	David is working on ...

	Anna is working on ... 

Fullstack - 

	Sulaiman is working on xcode setup as well as helping Abas on messaging screen.

## iv. Test plan & bugs

## v. Documentation plan

## Other Revisions

+ Use cases provide a good sense of what the user experience will be like
	- We added use cases late last week to the living document. 
	
+ Considers a lot of project-specific risks
	- We considred potential issues with JSON data (since we are using JSON, it is crucial for JSON data to be organized appropriately or
else it might lead to excessive layering, causing issues when we’re trying to
retrieve data and write data). Details on this are in our living document.

+ Missing use policies for each communication channel
	- This has been fixed in the living document.  




