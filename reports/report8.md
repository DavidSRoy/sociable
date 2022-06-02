# Status Report 8: `06/01/2022`

## Team Status
We have released our app (version 7). We are using TestFlight to distribute our final release (ie. there is no public link, as this would require a review by the App Store and would take extra time.) We were able to address most of the issues addressed during our peer review, including messages not sending and disfunctional login.
## Sub-team Status

### Backend Team
David & Anna

We added extra endpoints as requested by the frontend team. This includes endpoints for adding and removing friends and setting a profile photo and bio. We also made changes to the `getUsers` endpoint upon request. We also updated the function deployment pipeline so that it could access our service account details during the deployment.


### Frontend Team
Riya & Kevin

The home screen was the main priority that was worked on after the login and signup flow were integrated and correctly worked with the backend. Within the home screen displays the name and bio of the logged in user, and the home screen populates chat boxes with any messages received on app startup. There is also a screen to send a new message that displays all the registered users on the app. Upon reopening the app, the user remains logged in and can communicate with the server and can logout by deleting the app. The app also uses a tab bar to transition between the home screen and a prototype of the contacts screen. The overall work done can be summed up into calling endpoints and integrating it within the app in conjunction with building a user interface where the data appears correctly.

### Fullstack Team
Sulaiman & Abas

We have come quite close to completing the messaging screen. We are also working on the contact screen right now. 
Goals for the week:
- Finsh messaging screen

Next Week:
- Complete the contact screen 
