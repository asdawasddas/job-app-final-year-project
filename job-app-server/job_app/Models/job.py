from job_app.Models.hirer import Hirer
from ..models import *
from bson import ObjectId
from helpFunctions import cursorHandler

from datetime import datetime, timedelta
from bson import Int64
import pytz


class Job:
    @staticmethod
    def detail(jobId):
        job = job_col.aggregate([
            {
                "$match": { '_id' : ObjectId(jobId) }
            },
            {
                "$project": {
                    'id' : { '$toString': "$_id" },
                    "enterprise_oid": { '$toObjectId' : '$enterprise_id' },
                    "enterprise_id": 1,
                    "title": 1,
                    "min_salary": 1,
                    "max_salary": 1,
                    "areas": 1,
                    "experience": 1,
                    "position": 1,
                    "amount": 1,
                    "working_type": 1,
                    "occupations": 1,
                    "descriptions": 1,
                    "requirements": 1,
                    "benefits": 1,
                    "addresses": 1,
                    "working_time": 1,
                    "created_date": { '$dateToString': { 'format': "%H:%M:%S %d-%m-%Y", 'date': "$created_date" } },
                    "expired_date": { '$dateToString': { 'format': "%d-%m-%Y", 'date': "$expired_date" } },
                    'is_closed': 1,
                }
            },
            {
                '$lookup': {
                    'from': 'enterprise', 
                    'localField': 'enterprise_oid', 
                    'foreignField': '_id',
                    'as': 'enterprise'
                }
            },
            {
                '$unwind': {
                    'path': "$enterprise",
                    'preserveNullAndEmptyArrays': True
                }
            },
            {
                "$project": {
                    'id' : 1,
                    "hirer_id": 1,
                    "title": 1,
                    "min_salary": 1,
                    "max_salary": 1,
                    "areas": 1,
                    "experience": 1,
                    "position": 1,
                    "amount": 1,
                    "working_type": 1,
                    "occupations": 1,
                    "descriptions": 1,
                    "requirements": 1,
                    "benefits": 1,
                    "addresses": 1,
                    "working_time": 1,
                    "created_date": 1,
                    "expired_date": 1,
                    'is_closed': 1,
                    'logo_url': '$enterprise.logo_url',
                    'enterprise_name': '$enterprise.name',
                    "enterprise_id": 1,
                }
            },
        ])
        job = cursorHandler(job)
        return job
    
    @staticmethod
    def applicantFavJobs(applicantId):
        applicant = cursorHandler(applicant_col.find_one(
            {
                '_id' : ObjectId(applicantId)
            }
        ))
        favList = applicant.get('fav_jobs') or []
        for i in range(len(favList)):
            favList[i] = ObjectId(favList[i])
        jobs = job_col.aggregate([
            {
                "$match": {
                    '_id' : { '$in' : favList}
                }
            },
            {
                "$project": {
                    'id' : { '$toString': "$_id" },
                    "enterprise_oid": { '$toObjectId' : '$enterprise_id' },
                    "enterprise_id": 1,
                    "title": 1,
                    "min_salary": 1,
                    "max_salary": 1,
                    "areas": 1,
                    "experience": 1,
                    "position": 1,
                    "amount": 1,
                    "working_type": 1,
                    "occupations": 1,
                    "descriptions": 1,
                    "requirements": 1,
                    "benefits": 1,
                    "addresses": 1,
                    "working_time": 1,
                    "created_date": { '$dateToString': { 'format': "%H:%M:%S %d-%m-%Y", 'date': "$created_date" } },
                    "expired_date": { '$dateToString': { 'format': "%d-%m-%Y", 'date': "$expired_date" } },
                    'is_closed': 1,
                }
            },
            {
                '$lookup': {
                    'from': 'enterprise', 
                    'localField': 'enterprise_oid', 
                    'foreignField': '_id',
                    'as': 'enterprise'
                }
            },
            {
                '$unwind': {
                    'path': "$enterprise",
                    'preserveNullAndEmptyArrays': True
                }
            },
            {
                "$project": {
                    'id' : 1,
                    "hirer_id": 1,
                    "title": 1,
                    "min_salary": 1,
                    "max_salary": 1,
                    "areas": 1,
                    "experience": 1,
                    "position": 1,
                    "amount": 1,
                    "working_type": 1,
                    "occupations": 1,
                    "descriptions": 1,
                    "requirements": 1,
                    "benefits": 1,
                    "addresses": 1,
                    "working_time": 1,
                    "created_date": 1,
                    "expired_date": 1,
                    'is_closed': 1,
                    'logo_url': '$enterprise.logo_url',
                    'enterprise_name': '$enterprise.name',
                    "enterprise_id": 1,
                }
            },
        ])
        return cursorHandler(jobs)
   
    @staticmethod
    def search(query):
        job_col.create_index([('title', pymongo.TEXT)])
        match = {
            'is_closed' : { '$ne' : True},
            'expired_date' : { '$gte' : datetime.now() }
        }
        sortA = {}

        # kieu lam viec 
        workingType = query.get('wt', '')
        if workingType:
            match['working_type'] = workingType

        # nganh nghe
        occupations = query.get('occ', '')
        if occupations:
            occupations = list(occupations.split("#"))
            match['occupations'] = { '$in' : occupations }
        
        # vi tri
        position = query.get('ps', '')
        if position:
            match['position'] = position

        # kinh nghiem
        experience = query.get('exp', '')
        if experience:
            try:
                experience = int(experience)
            except ValueError:
                experience = 0
            match['experience'] = experience

        # khu vuc
        areas = query.get('areas', '')
        if areas:
            areas = list(areas.split("#"))
            match['areas'] = { '$in' : areas }

        # muc luong
        salary = query.get('salary' , '0')
        # print(salary)
        try:
            salary = int(salary)
        except ValueError:
            salary = 0
        if salary != 0:
            match['$or'] = [ 
                { 'min_salary' : { '$lte' : salary }, 'max_salary' : { '$gte' : salary } } , 
                { 'min_salary' : { '$lte' : salary }, 'max_salary' : 0} , 
                { 'min_salary' : 0 , 'max_salary' : { '$gte' : salary }} 
            ]

        # title
        title = query.get('title', '')
        # print(title)
        if title:
            match['$text'] = { '$search': title }

        # loc
        sort = query.get('sort', '0')
        if sort == '0' and title:
            sortA = { 'score' : { '$meta' : 'textScore' }}
        else:
            sortA = { 'created_date': -1 }

        # print(match)
        jobs = job_col.aggregate([
            {
                "$match": match
            },
            {
                "$project": {
                    'id' : { '$toString': "$_id" },
                    "enterprise_oid": { '$toObjectId' : '$enterprise_id' },
                    "enterprise_id": 1,
                    "title": 1,
                    "min_salary": 1,
                    "max_salary": 1,
                    "areas": 1,
                    "experience": 1,
                    "position": 1,
                    "amount": 1,
                    "working_type": 1,
                    "occupations": 1,
                    "descriptions": 1,
                    "requirements": 1,
                    "benefits": 1,
                    "addresses": 1,
                    "working_time": 1,
                    "created_date": { '$dateToString': { 'format': "%H:%M:%S %d-%m-%Y", 'date': "$created_date" } },
                    "expired_date": { '$dateToString': { 'format': "%d-%m-%Y", 'date': "$expired_date" } },
                    'is_closed': 1,
                }
            },
            {
                '$lookup': {
                    'from': 'enterprise', 
                    'localField': 'enterprise_oid', 
                    'foreignField': '_id',
                    'as': 'enterprise'
                }
            },
            {
                '$unwind': {
                    'path': "$enterprise",
                    'preserveNullAndEmptyArrays': True
                }
            },
            {
                "$project": {
                    'id' : 1,
                    "hirer_id": 1,
                    "title": 1,
                    "min_salary": 1,
                    "max_salary": 1,
                    "areas": 1,
                    "experience": 1,
                    "position": 1,
                    "amount": 1,
                    "working_type": 1,
                    "occupations": 1,
                    "descriptions": 1,
                    "requirements": 1,
                    "benefits": 1,
                    "addresses": 1,
                    "working_time": 1,
                    "created_date": 1,
                    "expired_date": 1,
                    'is_closed': 1,
                    'logo_url': '$enterprise.logo_url',
                    'enterprise_name': '$enterprise.name',
                    "enterprise_id": 1,
                }
            },
            {
                '$sort': sortA
            },
        ])
        jobs = cursorHandler(jobs)
        # print(jobs)
        return jobs

    @staticmethod
    def appliable(jobId):
        return job_col.find_one({
            '_id' : ObjectId(jobId),
            'is_closed' : { '$ne' : True},
            'expired_date' : { '$gte' : datetime.now() }
        })

    @staticmethod
    def hirerJobs(hirerId, sort):
        job_hirer_join = job_col.aggregate([
        {
            "$match": {
                'hirer_id': hirerId,
            }
        },
        # -1 newest 1 oldest
        { '$sort' : { 'created_date': sort } },
        {
            "$project": {
                'id' : { '$toString': "$_id" },
                "hirer_id": 1,
                "title": 1,
                "min_salary": 1,
                "max_salary": 1,
                "areas": 1,
                "experience": 1,
                "position": 1,
                "amount": 1,
                "working_type": 1,
                "occupations": 1,
                "descriptions": 1,
                "requirements": 1,
                "benefits": 1,
                "addresses": 1,
                "working_time": 1,
                "created_date": { '$dateToString': { 'format': "%H:%M:%S %d-%m-%Y", 'date': "$created_date" } },
                "expired_date": { '$dateToString': { 'format': "%d-%m-%Y", 'date': "$expired_date" } },
                'is_closed': 1,
            }
        },
        {
            '$lookup': {
                'from': 'application', 
                'localField': 'id', 
                'foreignField': 'job_id',
                'as': 'applications'
            }
        },
        {
            "$project": {
                'id' : 1,
                "hirer_id": 1,
                "title": 1,
                "min_salary": 1,
                "max_salary": 1,
                "areas": 1,
                "experience": 1,
                "position": 1,
                "amount": 1,
                "working_type": 1,
                "occupations": 1,
                "descriptions": 1,
                "requirements": 1,
                "benefits": 1,
                "addresses": 1,
                "working_time": 1,
                "created_date": 1,
                "expired_date": 1,
                'is_closed': 1,
                'applications_count': {'$size':'$applications'},
            }
        },
        # {
        #     '$unwind': {
        #         'path': "$enterprise",
        #         'preserveNullAndEmptyArrays': True
        #     }
        # },
        # {
        #     "$project": {
        #         "_id": 1,
        #         "hirer_id": 1,
        #         "title": 1,
        #         "min_salary": 1,
        #         "max_salary": 1,
        #         "areas": 1,
        #         "experience": 1,
        #         "position": 1,
        #         "amount": 1,
        #         "working_type": 1,
        #         "occupations": 1,
        #         "descriptions": 1,
        #         "requirements": 1,
        #         "benefits": 1,
        #         "addresses": 1,
        #         "working_time": 1,
        #         "created_date": { '$dateToString': { 'format': "%H:%M:%S %d-%m-%Y", 'date': "$created_date" } },
        #         "expired_date": { '$dateToString': { 'format': "%d-%m-%Y", 'date': "$expired_date" } },
        #         'logo_url': "$enterprise.logo_url",
        #         'enterprise_name' : "$enterprise.enterprise_name",
        #     }
        # },
        ])
        result = cursorHandler(job_hirer_join)
        return result

    @staticmethod
    def enterpriseJobs(enterpriseId):
        jobs = job_col.aggregate([
            {
                "$match": {
                    'enterprise_id' : enterpriseId,
                    'is_closed' : { '$ne' : True},
                    'expired_date' : { '$gte' : datetime.now() }
                }
            },
            {
                "$project": {
                    'id' : { '$toString': "$_id" },
                    "enterprise_oid": { '$toObjectId' : '$enterprise_id' },
                    "enterprise_id": 1,
                    "title": 1,
                    "min_salary": 1,
                    "max_salary": 1,
                    "areas": 1,
                    "experience": 1,
                    "position": 1,
                    "amount": 1,
                    "working_type": 1,
                    "occupations": 1,
                    "descriptions": 1,
                    "requirements": 1,
                    "benefits": 1,
                    "addresses": 1,
                    "working_time": 1,
                    "created_date": { '$dateToString': { 'format': "%H:%M:%S %d-%m-%Y", 'date': "$created_date" } },
                    "expired_date": { '$dateToString': { 'format': "%d-%m-%Y", 'date': "$expired_date" } },
                    'is_closed': 1,
                }
            },
            {
                '$lookup': {
                    'from': 'enterprise', 
                    'localField': 'enterprise_oid', 
                    'foreignField': '_id',
                    'as': 'enterprise'
                }
            },
            {
                '$unwind': {
                    'path': "$enterprise",
                    'preserveNullAndEmptyArrays': True
                }
            },
            {
                '$sort' : { 'id' : -1 }
            },
            {
                "$project": {
                    'id' : 1,
                    "hirer_id": 1,
                    "title": 1,
                    "min_salary": 1,
                    "max_salary": 1,
                    "areas": 1,
                    "experience": 1,
                    "position": 1,
                    "amount": 1,
                    "working_type": 1,
                    "occupations": 1,
                    "descriptions": 1,
                    "requirements": 1,
                    "benefits": 1,
                    "addresses": 1,
                    "working_time": 1,
                    "created_date": 1,
                    "expired_date": 1,
                    'is_closed': 1,
                    'logo_url': '$enterprise.logo_url',
                    'enterprise_name': '$enterprise.name',
                    "enterprise_id": 1,
                }
            },
        ])
        result = cursorHandler(jobs)
        return result

    @staticmethod
    def create(token, data):
        if Hirer.authenticate(token):
            id = Hirer.authenticate(token).get('id')
            if ('title' in data and isinstance(data.get('title'), str) and
                'enterprise_id' in data and hirer_col.find_one({ '_id': ObjectId(id), 'is_confirmed' : 2, 'is_blocked' : { '$ne' : True}, 'enterprise_id' : data.get('enterprise_id') }) and
                'min_salary' in data and isinstance(data.get('min_salary'), int) and
                'max_salary' in data and isinstance(data.get('max_salary'), int) and
                'areas' in data and checkStringList(data.get('areas')) and
                'experience' in data and isinstance(data.get('experience'), int) and
                'position' in data and isinstance(data.get('position'), str) and
                'amount' in data and isinstance(data.get('amount'), int) and
                'working_type' in data and isinstance(data.get('working_type'), str) and
                'occupations' in data and checkStringList(data.get('occupations')) and
                'descriptions' in data and isinstance(data.get('descriptions'), str) and
                'requirements' in data and isinstance(data.get('requirements'), str) and
                'benefits' in data and isinstance(data.get('benefits'), str) and
                'addresses' in data and isinstance(data.get('addresses'), str) and
                'working_time' in data and isinstance(data.get('working_time'), str) and
                'expired_date' in data and checkDateString(data.get('expired_date'))
            ):

                addData = {
                    'hirer_id': Hirer.authenticate(token).get('id'),
                    'enterprise_id': data.get('enterprise_id'),
                    'title': data.get('title'),
                    'min_salary': data.get('min_salary'),
                    'max_salary': data.get('max_salary'),
                    'areas': data.get('areas'),
                    'experience': data.get('experience'),
                    'position': data.get('position'),
                    'amount': data.get('amount'),
                    'working_type': data.get('working_type'),
                    'occupations': data.get('occupations'),
                    'descriptions': data.get('descriptions'),
                    'requirements': data.get('requirements'),
                    'benefits': data.get('benefits'),
                    'addresses': data.get('addresses'),
                    'working_time': data.get('working_time'),
                    'created_date': getCurrentTime(),
                    'expired_date' : datetime.strptime(data.get('expired_date'), '%d-%m-%Y'),
                    'is_closed' : False,
                    'is_checked' : False,                
                }
                try:
                    job_col.insert_one(addData)
                    return '200'
                except ValueError:
                    return None
            else:
                return None
        else:
            return None

    def close(jobId, token):
        if (Hirer.authenticate(token)):
            if (job_col.find_one({'_id': ObjectId(jobId), 'hirer_id': Hirer.authenticate(token).get('id')})):
                job_col.find_one_and_update({'_id': ObjectId(jobId)}, {'$set': {'is_closed' : True}})
                return '200'
        return '404'

    def update(jobId, token ,data):
        if (job_col.find_one({'_id': ObjectId(jobId), 'is_closed': True})):
            return '404'
        
        id = ''
        updateData = {}
        if (Hirer.authenticate(token)):
            id = Hirer.authenticate(token).get('id')
        else:
            return '404'

        if application_col.count_documents({'job_id' : jobId}) > 0 :            
            if 'expired_date' in data and checkDateString(data.get('expired_date')):
                updateData['expired_date'] = datetime.strptime(data.get('expired_date'), '%d-%m-%Y')
                job_col.find_one_and_update({'_id': ObjectId(jobId), 'hirer_id': id}, {'$set': updateData})
            return '200'

        if 'title' in data and isinstance(data.get('title'), str):
            updateData[ 'title'] = data.get('title')
        if 'min_salary' in data and isinstance(data.get('min_salary'), int) :
            updateData[ 'min_salary'] = data.get('min_salary')
        if 'max_salary' in data and isinstance(data.get('max_salary'), int) :
            updateData[ 'max_salary'] = data.get('max_salary')
        if 'areas' in data and checkStringList(data.get('areas')) :
            updateData[ 'areas'] = data.get('areas')
        if 'experience' in data and isinstance(data.get('experience'), int) :
            updateData[ 'experience'] = data.get('experience')
        if 'position' in data and isinstance(data.get('position'), str) :
            updateData[ 'position'] = data.get('position')
        if 'amount' in data and isinstance(data.get('amount'), int) :
            updateData[ 'amount'] = data.get('amount')
        if 'working_type' in data and isinstance(data.get('working_type'), str) :
            updateData[ 'working_type'] = data.get('working_type')
        if 'occupations' in data and checkStringList(data.get('occupations')) :
            updateData[ 'occupations'] = data.get('occupations')
        if 'descriptions' in data and isinstance(data.get('descriptions'), str): 
            updateData[ 'descriptions'] = data.get('descriptions')
        if 'requirements' in data and isinstance(data.get('requirements'), str) :
            updateData[ 'requirements'] = data.get('requirements')
        if 'benefits' in data and isinstance(data.get('benefits'), str) :
            updateData[ 'benefits'] = data.get('benefits')
        if 'addresses' in data and isinstance(data.get('addresses'), str): 
            updateData[ 'addresses'] = data.get('addresses')
        if 'working_time' in data and isinstance(data.get('working_time'), str) :
            updateData[ 'working_time'] = data.get('working_time')
        if 'expired_date' in data and checkDateString(data.get('expired_date')):
            updateData['expired_date'] = datetime.strptime(data.get('expired_date'), '%d-%m-%Y')

        job_col.find_one_and_update({'_id': ObjectId(jobId), 'hirer_id': id}, {'$set': updateData})
        return '200'
                
    @staticmethod
    def favEnterprisesJob(applicantId):
        applicant = cursorHandler(applicant_col.find_one(
            {
                '_id' : ObjectId(applicantId)
            }
        ))
        favList = applicant.get('fav_enterprises') or []
        jobs = job_col.aggregate([
            {
                "$match": {
                    'enterprise_id' : { '$in' : favList},
                    'is_closed' : { '$ne' : True},
                    'expired_date' : { '$gte' : datetime.now() }
                }
            },
            {
                "$project": {
                    'id' : { '$toString': "$_id" },
                    "enterprise_oid": { '$toObjectId' : '$enterprise_id' },
                    "enterprise_id": 1,
                    "title": 1,
                    "min_salary": 1,
                    "max_salary": 1,
                    "areas": 1,
                    "experience": 1,
                    "position": 1,
                    "amount": 1,
                    "working_type": 1,
                    "occupations": 1,
                    "descriptions": 1,
                    "requirements": 1,
                    "benefits": 1,
                    "addresses": 1,
                    "working_time": 1,
                    "created_date": { '$dateToString': { 'format': "%H:%M:%S %d-%m-%Y", 'date': "$created_date" } },
                    "expired_date": { '$dateToString': { 'format': "%d-%m-%Y", 'date': "$expired_date" } },
                    'is_closed': 1,
                }
            },
            {
                '$lookup': {
                    'from': 'enterprise', 
                    'localField': 'enterprise_oid', 
                    'foreignField': '_id',
                    'as': 'enterprise'
                }
            },
            {
                '$unwind': {
                    'path': "$enterprise",
                    'preserveNullAndEmptyArrays': True
                }
            },
            {
                '$sort' : { 'id' : -1 }
            },
            {
                "$project": {
                    'id' : 1,
                    "hirer_id": 1,
                    "title": 1,
                    "min_salary": 1,
                    "max_salary": 1,
                    "areas": 1,
                    "experience": 1,
                    "position": 1,
                    "amount": 1,
                    "working_type": 1,
                    "occupations": 1,
                    "descriptions": 1,
                    "requirements": 1,
                    "benefits": 1,
                    "addresses": 1,
                    "working_time": 1,
                    "created_date": 1,
                    "expired_date": 1,
                    'is_closed': 1,
                    'logo_url': '$enterprise.logo_url',
                    'enterprise_name': '$enterprise.name',
                    "enterprise_id": 1,
                }
            },
        ])
        # print(cursorHandler(jobs))
        return cursorHandler(jobs)