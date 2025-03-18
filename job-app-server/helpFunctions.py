import json
from bson import json_util
from datetime import datetime
import jwt

SECRET_KEY = 'BkRvCy1yaKnbV8c3wTDL33CMJKukwCdd'

def getCurrentTime():
    # local = datetime.now()
    # tz_VN = pytz.timezone('Asia/Ho_Chi_Minh')
    return datetime.now()

def createToken(id, type):
    return jwt.encode(
        payload = {
            'id' : id,
            'type' : type
        },
        key = SECRET_KEY,
        algorithm= 'HS512'
    )

def verifyToken(token):
    try:
        decode = jwt.decode(token, SECRET_KEY, algorithms="HS512")
        return decode
    except jwt.exceptions.InvalidTokenError as e:
        return None
    except Exception as e:
        return None

def cursorHandler(cursor):
    return json.loads(json_util.dumps(cursor))

def checkStringList(obj):
    # return bool(obj) and all(isinstance(elem, str) for elem in obj)
    return isinstance(obj, list) and all(isinstance(elem, str) for elem in obj)

def toDateString(obj, dateName):
    datetime_str = obj.get(dateName).get('$date')[0:19]
    try:
        datetime_object = datetime.strptime(datetime_str, '%Y-%m-%dT%H:%M:%S')
        return datetime_object.strftime("%H:%M:%S %d/%m/%Y")
    except ValueError:
        return None


def checkDateString(dateStr):
    try:
        datetime.strptime(dateStr, '%d-%m-%Y')
        return True
    except ValueError:
        return False