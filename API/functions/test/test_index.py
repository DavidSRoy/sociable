import requests
import pytest
import json

BASE_URL = "https://us-central1-sociable-messenger.cloudfunctions.net/messaging_api/"
#API = BASE_URL + "?q={city_name}&appid={api_key}&units=metric"
API = ""
API_KEY = "fa8183b09992df0844473872b19d64fa7c400842"

class Test_Index:
    def test_messaging_getUsers_returns401WithoutAuth(self):
        url = BASE_URL + "getUsers"
        headers = {}
        res = requests.get(url, headers=headers)
        assert res.status_code == 401

    def test_messaging_getUsers_returns401WithAuth(self):
        url = BASE_URL + "getUsers"
        headers = {'auth': get_api_key()}
        res = requests.get(url, headers=headers)
        assert res.status_code == 200

def get_api_key():
    try:
        with open('../.runtimeconfig.json', 'r') as f:
            res = json.load(f)
            return res['messaging']['key']
    except Exception:
        return "null"
