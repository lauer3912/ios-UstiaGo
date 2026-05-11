#!/usr/bin/env python3
import jwt
import requests
import time
import os

key_id = os.environ['APPSTORE_KEY_ID']
issuer_id = os.environ['APPSTORE_ISSUER_ID']
key_content = os.environ.get('APPSTORE_API_KEY_CONTENT', '')

print("KEY_LENGTH=" + str(len(key_content)))
print("KEY_BEGIN=" + ("1" if "BEGIN" in key_content else "0"))
print("KEY_FIRST80=" + key_content[:80])

payload = {
    'iss': issuer_id,
    'exp': int(time.time()) + 600,
    'aud': 'appstoreconnect-v1'
}
token = jwt.encode(payload, key_content, algorithm='ES256')
print("JWT=" + token[:50] + "...")

headers = {
    'Authorization': 'Bearer ' + token,
    'Content-Type': 'application/json'
}
resp = requests.get(
    'https://api.appstoreconnect.apple.com/v1/apps?filter[bundleId]=com.ggsheng.UstiaGo',
    headers=headers,
    timeout=30
)
print("STATUS=" + str(resp.status_code))
print("BODY=" + resp.text[:300])
