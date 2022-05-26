

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

## `createUser`
Parameters

| Param | Description |
|-------|-------------|
| `firstName`   | [required]|
| `lastName`   |  |
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


## Testing

Test can be run using pytest

```pytest --auth=[AUTH_TOKEN]```

Be sure to add tests for every endpoint. Every endpoint must
have a test that checks for an authorization check.


