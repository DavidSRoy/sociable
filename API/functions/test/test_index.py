import requests
import pytest
import json

BASE_URL = "https://us-central1-sociable-messenger.cloudfunctions.net/messaging_api/"
#API = BASE_URL + "?q={city_name}&appid={api_key}&units=metric"
API = ""

class Test_Index:
    def test_messaging_getUsers_returns401WithoutAuth(self):
        url = BASE_URL + "getUsers"
        headers = {}
        res = requests.get(url, headers=headers)
        assert res.status_code == 401

    def test_messaging_getUsers_returns401WithAuth(self, auth_token):
        url = BASE_URL + "getUsers"
        headers = {'auth': auth_token}
        print(auth_token)
        res = requests.get(url, headers=headers)
        assert res.status_code == 200

    def test_messaging_getMessages_returns401WithoutAuth(self):
        url = BASE_URL + "getMessages"
        headers = {}
        res = requests.get(url, headers=headers)
        assert res.status_code == 401

    def test_messaging_getMessages_returns401WithAuth(self, auth_token):
        url = BASE_URL + "getMessages"
        headers = {'auth': auth_token}
        print(auth_token)
        res = requests.get(url, headers=headers)
        assert res.status_code != 401