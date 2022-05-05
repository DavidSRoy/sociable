# Status Report 3: `05/05/2022`

## Team Status

All the essential endpoints from the backend team have been created for messaging including sending and receiving messages. CI has been set up for both the backend and frontend via Github Actions and automatically runs for every commit at least on `master`. For next week's beta release, the demo will be a proof-of-concept at the minimum. It will have an ordinary messaging UI where a message can be typed in a textbox and message bubbles are displayed on screen upon send/receive. Ideally for the beta, we want to produce a basic but usable application that have the frontend screens integrated and components connected with the messaging API and this production will be the team's overarching goal and focus for the week. Afterwards, CD with TestFlight integration will need to be set up if it is not by then.

## Sub-team Status

### Backend Team

David & Anna

The initial testing framework for the backend has been setup such that a test pipeline will be initiated upon creating a pull request to merge with `master`.
We implemented the delete message endpoint which allows caller to delete message data of a given uid. The purpose of this function is to erase data after the messages have already been retrieved. 
We also implemented the post a status endpoint which lets the user upload an image along with her status post. The image is then uploaded to cloud storage and a unique access token is generated. That token is then added to the database as metadata associated with the status post.

Goals for the week:
- Continue working on functionality to send and receive statuses (and non-text messsages in general)
- Collaborate with other teams to complete status proof-of-concept.

Next Week:
- Put together a proof-of-concept for posting a status
- Coordinate with front end to set up system for subscribing to statuses.

### Frontend Team

Riya & Kevin

Xcode CI has been set up - separately builds and tests from the Xcode project and intiates upon creating pull request to `master`.

Goals for the week:
- Continue working on essential screens
  - Kevin: main chat interface
  - Riya: my profile / statuses
- Kevin: continue figuring out Xcode and Github Actions CD (& TestFlight)

Next Week:
- Finish any remaining essential screens and/or make essential flows more complete
- Assign supplemental screens (creating chats, uploading content, mutual contacts, user profiles)

### Fullstack Team

Sulaiman and Abas

- We have created the messagign screen and the contacts screen 
- We are still working on integrating the send endpoint into our messaging app

Goals for the week: 
- Continue working on implementing send functionality in the messaging page
- Work with the front end team to finish the remaining essential screens and connect the parts 

