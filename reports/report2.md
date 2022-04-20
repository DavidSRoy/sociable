# Status Report 2
04/20/2022

## Team Status
We have set up resources in Firebase and started dividing sub-tasks for our first milestone. We are working toward creating a messaging proof-of-concept where a user will be able to send a message from one device to another. This will require the backend infrastructure to be set up such that the frontend can make the appropriate API calls to send and read messages.
We have also added more use cases to our requirements doc (as per feedback from the last project meeting).

## Sub-team Status
Backend Team
- David & Anna
This week, Firebase resources (database and cloud functions) were set up. An initial version of the Messaging API has been deployed (it allows callers to read users messages [will be secured in future iterations]). Authorization checks were added to each endpoint such that only callers that provide the correct authorization key will be allowed to use the endpoint. Additionally, a CI/CD deployment workflow was set up such that a build/deployment of the Cloud Functions will occur whenever a new commit is pushed to `master`.

Goals for the week:
- Build the `send` and `getMessages` endpoints for the Messaging API

Next Week:
- Once the proof-of-concept is complete, we will turn our focus to sending/receiving statuses. 
