from job_app.Models.admin import Admin
from ..models import *
from bson import ObjectId
from helpFunctions import cursorHandler

class Applicant:
    @staticmethod
    def findById(id):
        user = applicant_col.aggregate([
            {
                "$match": {
                    '_id': ObjectId(id),
                },
            },
            {
                "$project": {
                    'id': { '$toString': "$_id" },
                    '_id': 0,
                    'email': 1,
                    'full_name': 1,
                    'phone_number': 1,
                    'avatar_url': 1,
                    'fav_jobs' : 1,
                    'fav_enterprises' : 1,
                    'is_blocked' : 1
                },        
            },
            {
                '$lookup': {
                    'from': 'application', 
                    'localField': 'id', 
                    'foreignField': 'applicant_id',
                    'pipeline': [
                        {'$project':{
                            'id': { '$toString': "$_id" },
                            '_id': 0,
                            'job_id': 1
                        }}
                    ],
                    'as': 'applications'
                }
            },
            {
                "$project": {
                        'id': 1,
                        'email': 1,
                        'full_name': 1,
                        'phone_number': 1,
                        'avatar_url': 1,
                        'fav_jobs' : 1,
                        'fav_enterprises' : 1,
                        'applied_jobs' : '$applications.job_id',
                        'is_blocked' : 1
                },        
            },
        ])
        user = cursorHandler(user)
        return user[0] if (len(user) != 0) else None
    
    @staticmethod
    def findByEmail(email):
        user = cursorHandler(applicant_col.find({'email': email}))
        return user[0] if (len(user) != 0) else None

    @staticmethod
    def authenticate(token):
        payload = verifyToken(token)
        if payload is None:
            return None
        elif (payload.get('type') == 'applicant' and Applicant.findById(payload.get('id'))): 
            return { 'id' : payload.get('id')}
        else:
            return None
    
    @staticmethod
    def isBlocked(token):
        payload = verifyToken(token)
        if payload is None:
            return True
        if applicant_col.find_one(
            {
                '_id' : ObjectId(payload.get('id')),
                'is_blocked' : True
            }
        ):
            return True
        return False
    @staticmethod
    def authenticateWithId(token, id):
        if Applicant.authenticate(token) and verifyToken(token).get('id') == id :
            return True
        return None
        
    @staticmethod
    def login(data):
        if ("email" in data and "password" in data):
            user = Applicant.findByEmail(data.get('email'))
            if (user is None):
                return None
            else:
                if (user.get('password') == data.get('password')):
                    token = createToken( user.get('_id')['$oid'], 'applicant' )
                    return { 'token': token, 'id': user.get('_id')['$oid']}
                else:
                    return None
        else:
            return None
    
    @staticmethod
    def signup(data):
        if ("email" in data and "password" in data and "full_name" in data and 'phone_number' in data):
            email = data.get('email')
            user = Applicant.findByEmail(email)
            if (user):
                return '409'
            else:
                signupData = {
                    'email' : data.get('email'),
                    'password' : data.get('password'),
                    'full_name' : data.get('full_name'),
                    'phone_number' : data.get('phone_number'),
                    'fav_jobs' : [],
                    'fav_enterprises' : [],
                    'is_blocked' : False,
                }
                alo = applicant_col.insert_one(signupData)
                print(alo)
                return '200'
        else:
            return '404'
    
    @staticmethod
    def changePassword(data, id):
        if ('old_password' in data and 'new_password' in data):
            user = cursorHandler(applicant_col.find_one({ '_id' : ObjectId(id)}))
            if (user is None):
                return '404'
            elif (user.get('password') == data.get('old_password')):
                
                applicant_col.update_one({'_id': ObjectId(id)}, {'$set': {'password': data.get('new_password')}})
                return '200'
            else:
                return '401' 
        else:
            return '404'
        
    @staticmethod
    def update(id, token, data):
        if Admin.authenticate(token):
            if data.get('is_blocked') in [True, False]:
                applicant_col.update_one({'_id': ObjectId(id)}, {'$set': {'is_blocked' : data.get('is_blocked')}})
            return True
        if not Applicant.authenticateWithId(token, id):
            return None
        updateData = {}
        if ('full_name' in data):
            updateData['full_name'] = data.get('full_name')
        if ('phone_number' in data):
            updateData['phone_number'] = data.get('phone_number')
        if ('fav_jobs' in data):
            updateData['fav_jobs'] = data.get('fav_jobs')
        if ('fav_enterprises' in data):
            updateData['fav_enterprises'] = data.get('fav_enterprises')
        applicant_col.update_one({'_id': ObjectId(id)}, {'$set': updateData})
        return True
  
    @staticmethod
    def changeAvatar(id, url):
        applicant_col.update_one({'_id': ObjectId(id)}, {'$set': {'avatar_url': url}})
    
    @staticmethod
    def deleteAvatar(id):
        applicant_col.update_one({'_id': ObjectId(id)}, {'$set': {'avatar_url': ''}})

    @staticmethod
    def getInfo(id, token):
        if not Applicant.authenticateWithId(token, id):
            return None
        return Applicant.findById(id)
    
    @staticmethod
    def applicants(query, token):
        if not Admin.authenticate(token):
            return None
        searchTxt = query.get('search', '')
        responseData = cursorHandler(applicant_col.find(
            { 
                '$or' : [
                    { 'phone_number' : searchTxt },
                    { 'email' : searchTxt}
                ]
            },
            {
                'id': { '$toString': "$_id" },
                '_id': 0,
                'full_name': 1,
                'email': 1,
                'phone_number': 1,
                'is_blocked': 1,
                'avatar_url': 1
            }
        ))
        if responseData:
            return responseData
        
        sortA = {'id' : -1}
        match = {}
        if searchTxt:
            match = {
                '$text' : { '$search': searchTxt } 
            }
            sortA = {
                'score' : { '$meta' : 'textScore' }
            }
        responseData = applicant_col.aggregate([
            {
                '$match' : match
            },
            {
                "$project": {
                    'id': { '$toString': "$_id" },
                    '_id': 0,
                    'full_name': 1,
                    'email': 1,
                    'phone_number': 1,
                    'is_blocked': 1,
                    'avatar_url': 1
                }
            },
            {
                '$sort': sortA
            },
        ])
        responseData = cursorHandler(responseData)
        return responseData
        

# print(Applicant.findById('6650698daeb84fcf2ce18788'))

# applicant_col.update_one({ '_id' : ObjectId('6650698daeb84fcf2ce18788')},  {"$set": {"some_key.param2": "val2_new", "some_key.param3": "val3_nasdsadew"}} )

