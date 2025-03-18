
import pymongo
from db_connection import db
from helpFunctions import *

# Create your models here.

admin_col = db['admin']

hirer_col = db['hirer']

applicant_col = db['applicant']

application_col = db['application']

enterprise_col = db['enterprise']

job_col = db['job']

job_col.create_index([('title', pymongo.TEXT)])
enterprise_col.create_index([('name', pymongo.TEXT)])
applicant_col.create_index([('full_name', pymongo.TEXT)])
hirer_col.create_index([('full_name', pymongo.TEXT)])
