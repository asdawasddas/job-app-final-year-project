from job_app.Models.admin import Admin
from ..models import *
from bson import ObjectId
from helpFunctions import cursorHandler



class Hirer:
    @staticmethod
    def findById(id):
        user = cursorHandler(hirer_col.find_one(
            {'_id': ObjectId(id)},
            {
                'id': { '$toString': "$_id" },
                '_id': 0,
                'email': 1,
                'full_name': 1,
                'phone_number': 1,
                'avatar_url': 1,
                'enterprise_id': 1,
                'is_confirmed' : 1,
                'is_blocked' : 1
            }
            ))
        return user
    
    @staticmethod
    def findByEmail(email):
        user = cursorHandler(hirer_col.find_one({'email': email}))
        return user
    
    @staticmethod
    def getInfo(token, id):
        if (Hirer.authenticateWithId(token, id)):
            return Hirer.findById(id)
        else:
            return None

    @staticmethod
    def authenticate(token):
        payload = verifyToken(token)
        if payload is None:
            return None
        elif (payload.get('type') == 'enterprise' and Hirer.findById(payload.get('id'))): 
            return { 'id' : payload.get('id')}
        else:
            return None
        
    @staticmethod
    def authenticateWithId(token, id):
        payload = verifyToken(token)
        if payload is None:
            return None
        elif (payload.get('type') == 'enterprise' and Hirer.findById(id) and payload.get('id') == id): 
            return '200'
        else:
            return None

    @staticmethod
    def login(data):
        if ("email" in data and "password" in data):
            user = Hirer.findByEmail(data.get('email'))
            if (user is None):
                return None
            else:
                if (user.get('password') == data.get('password')):
                    token = createToken( user.get('_id')['$oid'], 'enterprise' )
                    return { 'token': token, 'id': user.get('_id')['$oid']}
                else:
                    return None
        else:
            return None
        
    @staticmethod
    def signUp(data):
        if ("email" in data and "password" in data and "full_name" in data and "phone_number" in data):
            user = Hirer.findByEmail(data.get('email'))
            if (user is not None):
                return '409'
            else:
                signupData = {
                    'email' : data.get('email'),
                    'password' : data.get('password'),
                    'full_name' : data.get('full_name'),
                    'phone_number' : data.get('phone_number'),
                }
                alo = hirer_col.insert_one(signupData)
                print(alo)
                return '200'
        else:
            return '404'
    
    @staticmethod
    def update(id, token, data):
        if Hirer.authenticateWithId(token, id):
            if 'enterprise_id' in data:
                job_col.update_many(
                    {'hirer_id' : id},
                    {
                        '$set' : {
                            'is_closed' : True,
                        }
                    }
                )
                if not data.get('enterprise_id'):
                    
                    hirer_col.update_one(
                        {
                            '_id' : ObjectId(id), 'is_blocked' : { '$ne' : True},
                        },
                        {
                            '$set' : {
                                'enterprise_id' : '',
                                'is_confirmed' : 0
                            }
                        }
                    )
                    return '200'
                hirer_col.update_one(
                    {
                        '_id' : ObjectId(id), 'is_blocked' : { '$ne' : True},
                    },
                    {
                        '$set' : {
                            'enterprise_id' : data.get('enterprise_id'),
                            'is_confirmed' : 1
                        }
                    }
                )
                return '200'
            updateData = {}
            if ('phone_number' in data):
                updateData['phone_number'] = data.get('phone_number')
            if ('full_name' in data):
                print(data.get('full_name'))
                updateData['full_name'] = data.get('full_name')
            hirer_col.update_one({'_id': ObjectId(id)}, {'$set': updateData})
            return '200'
        
        if Admin.authenticate(token):
            if 'is_blocked' in data:
                hirer_col.update_one(
                    {
                        '_id' : ObjectId(id),
                    },
                    {
                        '$set' : {
                            'is_blocked' : data.get('is_blocked')
                        }
                    }
                )
                if data.get('is_blocked') == True:
                    job_col.update_many(
                        {'hirer_id' : id},
                        {
                            '$set' : {
                                'is_closed' : True,
                            }
                        }
                    )

            if 'is_confirmed' in data and 'enterprise_id' in data and data.get('is_confirmed') == 2 and enterprise_col.find_one({ '_id': ObjectId(data.get('enterprise_id'))}):
                hirer_col.update_one(
                    {
                        '_id' : ObjectId(id),
                    },
                    {
                        '$set' : {
                            'is_confirmed' : 2,
                            'enterprise_id' : data.get('enterprise_id')
                        }
                    }
                )
            elif 'is_confirmed' in data and data.get('is_confirmed') == 1:
                hirer_col.update_one(
                    {
                        '_id' : ObjectId(id),
                    },
                    {
                        '$set' : {
                            'is_confirmed' : 1,
                        }
                    }
                )
                job_col.update_many(
                    {'hirer_id' : id},
                    {
                        '$set' : {
                            'is_closed' : True,
                        }
                    }
                )
            return '200'
        return '404'

    @staticmethod
    def changePassword(data, id):
        if ('old_password' in data and 'new_password' in data):
            user = cursorHandler(hirer_col.find_one({'_id': ObjectId(id), 'password' : data.get('old_password')}))
            if (user is None):
                return '401'
            elif (user.get('password') == data.get('old_password')):
                hirer_col.update_one({'_id': ObjectId(id)}, {'$set': {'password': data.get('new_password')}})
                return '200'
            else:
                return '401' 
        else:
            return '404'
        
    @staticmethod
    def changeAvatar(id, url):
        hirer_col.update_one({'_id': ObjectId(id)}, {'$set': {'avatar_url': url}})

    @staticmethod
    def deleteAvatar(id):
        hirer_col.update_one({'_id': ObjectId(id)}, {'$set': {'avatar_url': ''}})

    @staticmethod
    def statistic(id, token):
        if not Hirer.authenticateWithId(token, id):
            return None
        totalJob = job_col.count_documents({ 'hirer_id' : id })
        runningJob = job_col.count_documents({ 'hirer_id' : id , 'is_closed' : { '$ne' : True}, 'expired_date' : { '$gte' : datetime.now() } })
        totalCV = application_col.count_documents({ 'hirer_id' : id })
        newCV = application_col.count_documents({ 'hirer_id' : id , 'status' : 0})

        return {
           'total_job' : totalJob,
           'running_job' : runningJob,
           'total_cv' : totalCV,
           'new_cv' : newCV,
        }
        
    @staticmethod
    def hirers(query, token):
        if not Admin.authenticate(token):
            return None
        searchTxt = query.get('search', '')
        responseData = cursorHandler(hirer_col.find(
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
                'is_confirmed' : 1,
                'is_blocked': 1,
                'avatar_url': 1,
                'enterprise_id' : 1
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
        responseData = hirer_col.aggregate([
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
                    'is_confirmed': 1,
                    'is_blocked': 1,
                    'avatar_url': 1,
                    'enterprise_id' : 1
                }
            },
            {
                '$sort': sortA
            },
        ])
        responseData = cursorHandler(responseData)
        return responseData
    
    @staticmethod
    def authenticateEnterprise(token, enterpriseId):
        payload = Hirer.authenticate(token)
        if payload and hirer_col.find_one(
            {
                '_id' : ObjectId(payload.get('id')),
                'is_blocked' : { '$ne' : True},
                'is_confirmed' : 2,
                'enterprise_id' : enterpriseId
            }
        ):
            return True
        return None