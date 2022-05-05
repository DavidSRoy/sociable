# Status Report 3: `05/05/2022`

## Team Status



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

Goals for the week:
- Continue working on essential screens
  - Kevin: main chat interface
  - Riya: my profile / statuses

Next Week:
- Finish any remaining essential screens and/or make essential flows more complete
- Assign supplemental screens (creating chats, uploading content, mutual contacts, user profiles)

### Fullstack Team

Sulaiman and Abas
