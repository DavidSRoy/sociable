# Sociable: Messaging API

## Important Endpoints

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


## Testing

Test can be run using pytest

```pytest --auth=[AUTH_TOKEN]```

Be sure to add tests for every endpoint. Every endpoint must
have a test that checks for an authorization check.


