import requests
import pytest
import json

BASE_URL = "https://us-central1-sociable-messenger.cloudfunctions.net/messaging_api/"
#BASE_URL = "http://localhost:5001/sociable-messenger/us-central1/messaging_api/"
#API = BASE_URL + "?q={city_name}&appid={api_key}&units=metric"
API = ""

class Test_Index:

    def test_messaging_getMessages_returns401WithoutAuth(self):
        url = BASE_URL + "getMessages"
        headers = {}
        res = requests.get(url, headers=headers)
        assert res.status_code == 401