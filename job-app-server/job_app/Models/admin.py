from ..models import *
from bson import ObjectId
from helpFunctions import cursorHandler

class Admin:
    @staticmethod
    def authenticate(token):
        payload = verifyToken(token)
        if payload is None:
            return None
        elif (payload.get('type') == 'admin' and admin_col.find_one({ '_id' : ObjectId(payload.get('id')) })): 
            return { 'id' : payload.get('id')}
        else:
            return None
        
    def isApexAdmin(token):
        payload = verifyToken(token)
        if payload is None:
            return None
        elif (payload.get('type') == 'admin' and admin_col.find_one({ '_id' : ObjectId(payload.get('id')), 'is_apex_admin' : True })): 
            return True
        return None
    
    @staticmethod
    def login(data):
        if ("account_name" in data and "password" in data):
            print(data.get('account_name'))
            user = cursorHandler(admin_col.find_one({ 'account_name' : data.get('account_name')}))
            if (user is None):
                return None
            else:
                if (user.get('password') == data.get('password')):
                    token = createToken( user.get('_id')['$oid'], 'admin' )
                    return { 'token': token, 'id': user.get('_id')['$oid']}
                else:
                    return None
        else:
            return None
    
    @staticmethod
    def getInfo(id, token):
        if not Admin.authenticate(token):
            return None
        payload = verifyToken(token)
        if id == payload.get('id'):
            return cursorHandler(
                admin_col.find_one(
                        { 
                            '_id' : ObjectId(payload.get('id')) 
                        },
                        {
                            'id': { '$toString': "$_id" },
                            '_id': 0,
                            'account_name' : 1,
                            'full_name': 1,
                            'is_apex_admin' : 1
                        }
            ))
        return None
    
    def create(data, token):
        if not Admin.isApexAdmin(token):
            return None
        account_name = data.get('account_name')
        if admin_col.find_one({ 'account_name' : account_name}):
            return '409'
        else:
            admin_col.insert_one(
                {
                    'account_name' : account_name,
                    'password' : data.get('password'),
                    'full_name' : data.get('full_name'),
                    'is_apex_admin' : False
                }
            )
            return '200'
    
    def admins(token):
        if not Admin.isApexAdmin(token):
            return None
        admins = cursorHandler(admin_col.find(
            {
                'is_apex_admin' : { '$ne' : True }
            },
            {
                'id': { '$toString': "$_id" },
                '_id' : 0,
                'full_name' : 1,
                'account_name' : 1,
                'is_apex_admin' : 1
            }
        ))
        return admins
    
    def delete(id, token):
        if not Admin.isApexAdmin(token):
            return None
        if admin_col.find_one({ '_id' : ObjectId(id), 'is_apex_admin' : { '$ne' : True } }):
            admin_col.delete_one({ '_id' : ObjectId(id) })
            return True
        return True
    
    def update(id, data, token):
        payload = verifyToken(token)
        if Admin.authenticate(token) and payload.get('id') == id:
            admin_col.update_one(
                {
                    '_id' : ObjectId(id)
                },
                {
                    '$set' : {'full_name' : data.get('full_name')}
                }
            )
            return True
        if not Admin.isApexAdmin(token):
            return None

        if admin_col.find_one({ '_id' : ObjectId(id), 'is_apex_admin' : True }) and payload.get('id') != id:
            return None
        admin_col.update_one(
            {
                '_id' : ObjectId(id)
            },
            {
                '$set' : {'full_name' : data.get('full_name')}
            }
        )
        return True

    def changePassword(id, data, token):
        payload = verifyToken(token)
        if Admin.authenticate(token) and payload.get('id') == id:
            if admin_col.find_one({ '_id' : ObjectId(id), 'password' : data.get('old_password')}):
                admin_col.update_one(
                    {
                        '_id' : ObjectId(id)
                    },
                    {
                        '$set' : {'password' : data.get('new_password')}
                    }
                )
                return True
            else:
                return None
            
        if not Admin.isApexAdmin(token):
            return None
        if admin_col.find_one({ '_id' : ObjectId(id), 'is_apex_admin' : True }) and payload.get('id') != id:
            return None
        admin_col.update_one(
            {
                '_id' : ObjectId(id)
            },
            {
                '$set' : {'password' : data.get('new_password')}
            }
        )
        return True