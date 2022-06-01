# Messaging API

## `sendMessage`
Parameters

| Param | Description |
|-------|-------------|
| `uid`   | recipient uid|
| `msg`   | message to deliver |
| `sender` | sender uid |


## `getMessages`
Parameters

| Param | Description |
|-------|-------------|
| `uid`   | uid of interest |

## `getImage`
`getImage` can be used to retrieve any image, 
including profile photos, statuses, or images in messages. To get the file name,
check the `filename` attribute associated with the object of interest (e.g filename
under a document in the STATUS collection or the profile pic path under a user's document)
Parameters

| Param | Description |
|-------|-------------|
| `filename`   | name of image to retrieve |

# Users API

## 'getUsers'
No Parameters
returns everything about all users

## `getUserInfo`
Returns everything about a user except messages

Parameters

| Param | Description |
|-------|-------------|
| `uid`   | uid of interest |


## `createUser`
Parameters

| Param | Description |
|-------|-------------|
| `displayName`   | [required]|
| `password` | [required]|
| `email`   | |
| `phone`   |  |
| `dob` | date of birth [required] |


## `login`
Parameters

| Param | Description |
|-------|-------------|
| `uid`   | uid of interest |
| `password`   | user's password |

Response

| Response | Description |
|-------|-------------|
| 200   | Valid password |
| 403   | Invalid password |

## `addFriend`
Parameters

| Param | Description |
|-------|-------------|
| `uid`   | uid of current user |
| `friendUid`   | uid of friend to be added|

## `removeFriend`
Parameters

| Param | Description |
|-------|-------------|
| `uid`   | uid of current user |
| `friendUid`   | uid of friend to be removed|

## `getFriend`
Parameters

| Param | Description |
|-------|-------------|
| `uid`   | uid of current user |

## `setDisplayName`
Parameters

| Param | Description |
|-------|-------------|
| `uid`   | uid of current user |
| `displayName`   | new display name |

## `setBio`
Parameters

| Param | Description |
|-------|-------------|
| `uid`   | uid of current user |
| `bio`   | new bio |

## `setProfilePhoto`
Parameters

| Param | Description |
|-------|-------------|
| `uid`   | uid of current user |
| `filePath`   | path to profile photo |


## Testing

Test can be run using pytest

```pytest --auth=[AUTH_TOKEN]```

Be sure to add tests for every endpoint. Every endpoint must
have a test that checks for an authorization check.


