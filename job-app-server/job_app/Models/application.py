from job_app.Models.hirer import Hirer
from ..models import *
from bson import ObjectId
from helpFunctions import cursorHandler

class Application:
    @staticmethod
    def detail(applicationId):
        return None
    
    @staticmethod
    def applicantApplications (token, applicantId):
        payload = verifyToken(token) #sort?
        if payload is None:
            return None
        if (payload.get('type') == 'applicant' and applicant_col.find_one({'_id' : ObjectId(payload.get('id'))}) and payload.get('id') == applicantId):
            applications = application_col.aggregate([
                {
                    "$match": {
                        'applicant_id': applicantId,
                    },
                },
                {
                    "$project": {
                        'id' : { '$toString': "$_id" },
                        "job_id": 1,
                        "job_oid" : { '$toObjectId' : '$job_id' },
                        "applicant_id": 1,
                        "cv_url": 1,
                        "status": 1,
                        "applied_time": { '$dateToString': { 'format': "%H:%M:%S %d-%m-%Y", 'date': "$applied_date" } },
                    }
                },
                {
                    '$lookup': {
                        'from': 'job', 
                        'localField': 'job_oid', 
                        'foreignField': '_id',
                        'pipeline': [
                            {'$project':{
                                '_id': 0,
                                'title' : 1,
                            }}
                        ],
                        'as': 'jobs'
                    }
                },
                {
                    '$unwind': {
                        'path': "$jobs",
                        'preserveNullAndEmptyArrays': True
                    }
                },
                {
                    "$project": {
                        'id' : 1,
                        "job_id": 1,
                        "applicant_id": 1,
                        "cv_url": 1,
                        "status": 1,
                        "applied_time": 1,
                        'job_title': '$jobs.title',
                    }
                },
                {
                    '$sort' : { 'id' : -1 }
                }
            ])
            applications = cursorHandler(applications)
            return applications
        return None

    @staticmethod
    def jobApplications(jobId, token, sort):
        payload = verifyToken(token)
        if payload is None:
            return None
        
        if (payload.get('type') == 'applicant' and applicant_col.find_one({'_id' : ObjectId(payload.get('id'))})):
            application = application_col.find_one(
                {
                    'applicant_id': payload.get('id'),
                    'job_id': jobId,
                },
                {
                    'id' : { '$toString': "$_id" },
                    "job_id": 1,
                    "applicant_id": 1,
                    "cv_url": 1,
                    "status": 1,
                    "applied_time": { '$dateToString': { 'format': "%H:%M:%S %d-%m-%Y", 'date': "$applied_date" } },
                }
            )
            application = cursorHandler(application)
            return application

        if (payload.get('type') != 'enterprise' or not job_col.find_one({'_id': ObjectId(jobId), 'hirer_id': payload.get('id')})): 
            return None
        
        applications = application_col.aggregate([
            {
                "$match": {
                    'job_id': jobId,
                },
            },
            { '$sort' : { 'applied_date': sort } },
            {
                "$project": {
                    'id' : { '$toString': "$_id" },
                    "job_id": 1,
                    "applicant_id": 1,
                    "cv_url": 1,
                    "status": 1,
                    "applied_time": { '$dateToString': { 'format': "%H:%M:%S %d-%m-%Y", 'date': "$applied_date" } },
                    'applicant_oid': { '$toObjectId': "$applicant_id" },
                }
            },
            {
                '$lookup': {
                    'from': 'applicant', 
                    'localField': 'applicant_oid', 
                    'foreignField': '_id',
                    'pipeline': [
                        {'$project':{
                            '_id': 0,
                            'avatar_url' : 1,
                            'email': 1,
                            'phone_number': 1,
                            'full_name': 1,
                        }}
                    ],
                    'as': 'applicant'
                }
            },
            {
                '$unwind': {
                    'path': "$applicant",
                    'preserveNullAndEmptyArrays': True
                }
            },
            {
                "$project": {
                    'id' : 1,
                    "job_id": 1,
                    "cv_url": 1,
                    "status": 1,
                    "applied_time": 1,
                    'applicant_name': '$applicant.full_name',
                    'applicant_email': '$applicant.email',
                    'applicant_phone': '$applicant.phone_number',
                    'applicant_avatar_url': '$applicant.avatar_url'
                }
            },
        ])
        applications = cursorHandler(applications)
        return applications
     
    @staticmethod
    def update(applicationId, hirerToken, data):
        payload = verifyToken(hirerToken)
        if payload is None:
            return None
        if (payload.get('type') != 'enterprise' or not application_col.find_one({'_id': ObjectId(applicationId), 'hirer_id': payload.get('id')})):
            return None
        if ('status' in data and isinstance(data.get('status'), int)):
            application_col.find_one_and_update({'_id': ObjectId(applicationId)}, {'$set': { 'status' : data.get('status')}})
            return True
        return None
    
    @staticmethod
    def create(applicantId, jobId, url):
        job = cursorHandler(job_col.find_one({'_id' : ObjectId(jobId)}))
        application_col.insert_one(
            {
                'job_id' : jobId,
                'hirer_id' : job.get('hirer_id'),
                'applicant_id' : applicantId,
                'cv_url' : url,
                'status' : 0,
                'applied_date' : datetime.now()
            }
        )
        return True