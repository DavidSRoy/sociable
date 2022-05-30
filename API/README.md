

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

# Users API

## 'getUsers'
No Parameters
returns everything about all users

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

## `getFriend`
Parameters

| Param | Description |
|-------|-------------|
| `uid`   | uid of current user |


## Testing

Test can be run using pytest

```pytest --auth=[AUTH_TOKEN]```

Be sure to add tests for every endpoint. Every endpoint must
have a test that checks for an authorization check.


