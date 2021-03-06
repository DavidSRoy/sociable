# Status Report 3: `04/27/2022`

## Team Status

We are making good progress toward creating the messaging proof-of-concept where a user will be able to send a message from one device to another, as mentioned in the last status report. The backend infrastructure is successfully set up such that the frontend can make the appropriate API calls. To aid the front end in doing so, we have provided documentation for Firebase, including useful functions. We have made the wireframes using Figma so we can kickstart building the actual app in Xcode. Our next step as a team is to coordinate with the front and back end teams so that the API endpoints can be called. Once that is done, which is our goal for this week, we will be done with our proof of concept.

## Sub-team Status

### Backend Team

David & Anna

The `send` and `getMessages` endpoints were set up. A message can now be ‘sent’ to a user (ie data will be populated in the user’s document in Firebase upon calling the `send` endpoint). We have structured it such that front end keeps calling getmessages function, and once the data is returned, the function then deletes the messages that were just retrieved from the backend. We identified that we might end up losing messages in the case where there's no internet. To reduce the likelihood of losing data, we will separate responsibility of getting and deleting into separate functions. 

Goals for the week:
- Build the `deleteMessages` endpoint to ensure integrity of data.
- Collaborate with other teams to complete messaging proof-of-concept.

Next Week:
- Once the proof-of-concept is complete, we will turn our focus to sending/receiving statuses.
- Coordinate with front end to help them call the endpoints within the app. We will work on creating documentation including the function inputs, purposes, and return and error values.

### Frontend Team

Riya & Kevin 

Built a UI for the login story, and app design in Figma including the UI for proof of concept done

Goals for the week: make API calls to the messaging API

### Fullstack Team

Sulaiman and Abas
Built the Figma deigns and UI, helped front team build the UI in Xcode. UI for proof of concept done.

Goals for the week: coordinate with back end to call all the existing endpoints to send and retrieve message 
