# Meeting Notes for 4/30/22
Discussion on the future milestones and required endpoints

Next Milestone: Send/receive status (stories)

- Create new collection for STATUS

STATUS
    - uid
    - content
    - timestamp
    - views (uid and timestamp)


## Status Endpoints

`sendStatus`

Parameters:
- uid
- content


`getStatus`

Parameters:
- uid


Whenever user opens the app, delete all their old statuses (> 24 hrs)

`deleteStatus`

Parameters:
- uid


Next Milestone: Friends

## Friends Endpoints

`addFriend`

Parameters:
- uid
- uid of friend

(store timestamp of when you became friends)
