# PushServer

This module provides a push server that can handle the following things

* Push to APNS and GCM
* Dynamically register applications for APNS and GCM
* Create topics
* Subscribe clients to topics

## HTTP API

You can check availability by sending messages to `/ping`.

### Pagination

### Applications

#### `GET /api/apps`

List registered applications

```json
{
  "data": [
    {
      "settings": {
        "key": "the apns private key",
        "env": "prod",
        "cert": "the apns certificate"
      },
      "platform": "apns",
      "name": "dummy",
      "id": 1
    },
    {
      "settings": {
        "auth_key": "the gcm authentication token"
      },
      "platform": "gcm",
      "name": "dummy",
      "id": 2
    }
  ]
}
```
