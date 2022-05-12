# Status Report 5: `05/11/2022`

## Team Status
We just completed our beta release, which integrates the Messaging API with the frontend, and allows a user to send and receive messages. Following the beta release, we will improve upon our messaging story and begin working on status posting. We have completed setting up the TestFlight integration.

## Sub-team Status

### Backend Team

David & Anna

This week, we updated the test pipeline with a temporary fix to address a bug that resulted in failing tests. (The test pipeline pointed to production endpoints instead of local endpoints).

Goals for the week:
- Work on creating endpoint to receive statuses (get image from firebase storage) (and non-text messsages in general)
- Work on adding new users
- Coordinate with front end to add new users

Next Week:
- Coordinate with front end to set up system for subscribing to statuses.
- Work on enabling users to send images to other users

### Frontend Team

Riya & Kevin

Goals for the week:
- Continue working on and improving upon essential screens
  - Kevin: main chat interface
  - Riya: my profile / statuses

Next Week:
- Make essential flows more complete
- Assign supplemental screens (creating chats, uploading content, mutual contacts, user profiles)

### Fullstack Team

Sulaiman and Abas

- Having integrated the send endpoint into our messaging app, we will continue to fix the issue with messages appearing multiple times
- Fixing the issue with the sent messages not showing up immediately after sending

Goals for the week: 
- Work with the front end team to implement the post a status story
- Coordinate with backend team to send and receive status updates
