# Status Report 7: `05/25/2022`

## Team Status

## Sub-team Status

### Backend Team
David & Anna

Anna just completed the getImage and getStatus endpoints. David worked on fixing deployment pipeline issues and updated API documentation. At this point, the backend team is done implementing features, and will be focused on maintaining the APIs.

Note: the deployment pipelines pertaining to the functions will be failing for the moment. We had an issue where a sensitive file (`serviceaccount.json`) needed to be uploaded in order for the deployment to work. While we figure out a way to upload in such a way that the pipeline can access it, we are deploying our functions from our local machines for the moment. The pipeline is failing because there is a hardcoded reference to a service account file that does not exist in the repo (but exists locally).

Goals for the week:
- Make sure the APIs are up and running, fix any bugs that may pop up
- Add `serviceaccount.json` to deployment pipeline

Next Week:
- Final release

### Frontend Team
Riya & Kevin

Currently working on screens.

Goals for the week:
- Implement some basic tests
- Have profile and main interface screen by final release

Next Week:
- Final release

### Fullstack Team
Sulaiman & Abas

We have come quite close to completing the messaging screen. We are also working on the contact screen right now. 
Goals for the week:
- Finsh messaging screen

Next Week:
- Complete the contact screen 
