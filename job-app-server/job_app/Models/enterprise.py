from job_app.Models.admin import Admin
from job_app.Models.hirer import Hirer
from ..models import *
from bson import ObjectId
from helpFunctions import cursorHandler


class Enterprise:
    @staticmethod 
    def create (token, data):
        if not Admin.authenticate(token):
            return None
        createData = {
            'name' : data.get('name'),
            'tax_code' : data.get('tax_code')
        }
        if enterprise_col.find_one({ '$or' : [ { 'name' : createData.get('name') } , { 'tax_code' : createData.get('tax_code') } ] }):
            return '409'
        enterprise_col.insert_one(createData)
        return '200'

    @staticmethod    
    def enterprises(query):
        # enterprise_col.create_index([('name', pymongo.TEXT)])
        searchTxt = query.get('search', '')
        responseData = cursorHandler(enterprise_col.find(
            { 'tax_code' : searchTxt },
            {
                'id': { '$toString': "$_id" },
                '_id': 0,
                'name': 1,
                'email': 1,
                'phone_number': 1,
                'industry': 1,
                'logo_url': 1,
                'employee_amount': 1,
                'address': 1,
                'infomation': 1,
                'tax_code': 1
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
        responseData = enterprise_col.aggregate([
            {
                '$match' : match
            },
            {
                "$project": {
                    'id': { '$toString': "$_id" },
                    '_id': 0,
                    'name': 1,
                    'email': 1,
                    'phone_number': 1,
                    'industry': 1,
                    'logo_url': 1,
                    'employee_amount': 1,
                    'address': 1,
                    'infomation': 1,
                    'tax_code': 1
                }
            },
            {
                '$sort': sortA
            },
        ])
        responseData = cursorHandler(responseData)
        return responseData

    @staticmethod
    def getInfo(id):
        enterprise = cursorHandler(enterprise_col.aggregate([
            {
                "$match": {
                    '_id': ObjectId(id),
                }
            },
            {
                "$project": {
                    'id': { '$toString': "$_id" },
                    '_id': 0,
                    'name': 1,
                    'email': 1,
                    'phone_number': 1,
                    'industry': 1,
                    'logo_url': 1,
                    'employee_amount': 1,
                    'address': 1,
                    'infomation': 1,
                    'tax_code': 1
                }
            },
            {
                '$lookup': {
                    'from': 'applicant', 
                    'localField': 'id', 
                    'foreignField': 'fav_enterprises',
                    'as': 'followers'
                }
            },
            {
                "$project": {
                    'id': 1,
                    '_id': 0,
                    'name': 1,
                    'email': 1,
                    'phone_number': 1,
                    'industry': 1,
                    'logo_url': 1,
                    'employee_amount': 1,
                    'address': 1,
                    'infomation': 1,
                    'tax_code': 1,
                    'total_followers': {'$size':'$followers'},
                }
            },
        ]))
        return enterprise[0] if len(enterprise) != 0 else None
    
    @staticmethod
    def update(id, token, data):
        if Admin.authenticate(token):
            if enterprise_col.find_one(
                { 
                    '_id' : {'$ne': ObjectId(id)},
                    '$or' : [
                        { 'name' : data.get('name') },
                        { 'tax_code' : data.get('tax_code')}
                    ]
                },
            ):
                return '409'
            enterprise_col.update_one(
                {
                    '_id' : ObjectId(id)
                },
                {
                    '$set' : {
                        'name' : data.get('name'),
                        'tax_code' : data.get('tax_code'),
                    }
                }
            )
            return '200'

        if Hirer.authenticateEnterprise(token, id):
            # hirerId = verifyToken(token).get('id')
            # if not hirer_col.find_one(
            #     {
            #         '_id' : ObjectId(hirerId), 'is_confirmed' : 2, 'is_blocked' : { '$ne' : True}, 'enterprise_id' : id
            #     }
            # ):
            #     return None
            updateData = {}
            if ('email' in data):
                updateData['email'] = data.get('email')
            if ('phone_number' in data):
                updateData['phone_number'] = data.get('phone_number')
            if ('industry' in data):
                updateData['industry'] = data.get('industry')
            if ('logo_url' in data):
                updateData['logo_url'] = data.get('logo_url')
            if ('employee_amount' in data):
                updateData['employee_amount'] = data.get('employee_amount')
            if ('address' in data):
                updateData['address'] = data.get('address')
            if ('infomation' in data):
                updateData['infomation'] = data.get('infomation')
            enterprise_col.update_one({'_id': ObjectId(id)}, {'$set': updateData})
            return '200'
        else:
            return '403'
        # return '404'

    @staticmethod
    def changeLogo(id, url):
        enterprise_col.update_one({'_id': ObjectId(id)}, {'$set': {'logo_url': url}})

    @staticmethod
    def deleteLogo(id):
        enterprise_col.update_one({'_id': ObjectId(id)}, {'$set': {'logo_url': ''}})

    @staticmethod
    def applicantFav(applicantId):
        applicant = cursorHandler(applicant_col.find_one(
            {
                '_id' : ObjectId(applicantId)
            }
        ))
        favList = applicant.get('fav_enterprises') or []
        for i in range(len(favList)):
            favList[i] = ObjectId(favList[i])
        enterprises = enterprise_col.find(
            {
                '_id' : { '$in' :  favList}
            },
            {
                'id': { '$toString': "$_id" },
                '_id': 0,
                'name': 1,
                'email': 1,
                'phone_number': 1,
                'industry': 1,
                'logo_url': 1,
                'employee_amount': 1,
                'address': 1,
                'infomation': 1,
                'tax_code': 1
            }
        )
        return cursorHandler(enterprises)