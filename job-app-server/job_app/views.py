# import os
# from rest_framework import status
# from rest_framework.response import Response
# from rest_framework.decorators import api_view
# from bson.objectid import ObjectId

# from helpFunctions import *
# from .models import *
# from files_path import FilePath

# # Create your views here.

# SECRET_KEY = 'BkRvCy1yaKnbV8c3wTDL33CMJKukwCdd'

# @api_view(['GET'])
# def search(request):
#     if request.method == 'GET':
#         # Hà Nội;Hải Dương;Ninh Bình
#         query = request.GET.get('q')
#         alo = request.GET.get('alo')
#         print(alo)
#         print(len(query))
#         alo = list(alo.split(";"))
#         print(alo)
#         # query = json.loads(query) 
#         # print(query)
#         return Response(status=status.HTTP_200_OK) 

# @api_view(['GET', 'POST'])
# def recruitment_list(request):
#     if request.method == 'GET':
#         post_hirer_join = post_col.aggregate([
#         {
#             "$match": {
#                 # '_id': ObjectId('65d8bc0ed57daa27aebb8e04'),
#                 # 'tags' : {'$all' : ["NoSQL", 'SQL']},
#                 # 'tags' :  {'$in' : ["NoSQL", 'mySQL']},
#                 '$text': { '$search': "mongodb database" }
#             }
#         },
#         {
#             "$project": {
#                 'title': 1,
#                 'oID' : { '$toObjectId': '$ownerID' },
#             }
#         },
#         {
#             '$lookup': {
#                 'from': 'applicant_account', 
#                 'localField': 'oID', 
#                 'foreignField': '_id',
#                 'pipeline': [
#                     {'$project':{
#                         '_id' : 1,
#                         'email': 1
#                     }}
#                 ],
#                 'as': 'hirer'
#             }
#         }])
#         array = (cursorHandler(post_hirer_join))

#         resData =[]
#         for data in array:
#             hirer = data['hirer'][0]
#             resData.append({
#                 '_id' : data['_id'],
#                 'title' : data['title'],
#             })
#         print(array)
#         # joinedList = cursorHandler(list(post_hirer_join.find()))
#         # print(joinedList)
#         recruitment_posts = cursorHandler(list(post_col.find()))
#         for file in os.listdir(FilePath.APPLICANT_AVATAR_DIR):
#             print(file)
#         return Response(array)
    
#     if request.method == 'POST':
#         newData = request.data
#         post_col.insert_one(newData)
#         return Response(status=status.HTTP_200_OK)
    
# # Thông tin chi tiết việc làm
# @api_view(['GET','PUT','DELETE'])
# def recruitment_detail(request, id):
#     if request.method == 'GET':
#         recruitment_post = cursorHandler(post_col.find({'_id': ObjectId(id)}))
#         return Response(recruitment_post)
    
#     if request.method == 'PUT':
#         updateData = request.data
#         post_col.update_one({'_id': ObjectId(id)}, {'$set': updateData})
#         return Response(status=status.HTTP_200_OK)

#     if request.method == 'DELETE':
#         post_col.delete_one({'_id': ObjectId(id)})
#         return Response(status=status.HTTP_200_OK) 