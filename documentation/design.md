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
	- friends (uid's)
	- bio message (100 chars)
	- profile pic reference
- STATUS
	- author (uid)
	- content
User information will be collected upon creating an account. The messages field will be constantly updated as new messages are sent and received. The profile pic field will be a reference to the actual image in Firebase Cloud Storage.
	
## Software Design

## Coding Guideline

## Process Description (revisions)

## Other Revisions


