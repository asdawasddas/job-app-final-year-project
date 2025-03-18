import os
from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view

from helpFunctions import *
from files_path import FilePath
from job_app.Models.hirer import Hirer
from job_app.Models.job import Job

# Nhà tuyển dụng thêm job
@api_view(['GET'])
def jobs(request, id):
    if request.method == 'GET':
        sort = request.GET.get('sort', '0')
        sort = -1 if sort == '0' else 1
        responseData = Job.hirerJobs(id, sort)
        if responseData is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        return Response(status=status.HTTP_200_OK, data=responseData)

# Nhà tuyển dụng đăng nhập
@api_view(['GET','POST'])
def login(request):
    if request.method == 'GET':
        headers = request.headers
        token = headers.get('Authorization')
        responseData = Hirer.authenticate(token)
        if responseData is None:
            return Response(status=status.HTTP_401_UNAUTHORIZED)
        else:
            return Response(status=status.HTTP_200_OK, data=responseData)
        
    if request.method == 'POST':
        data = request.data
        responseData = Hirer.login(data)
        if responseData is None:
            return Response(status=status.HTTP_401_UNAUTHORIZED)
        else:
            return Response(status=status.HTTP_200_OK, data=responseData)

# Nhà tuyển dụng đăng ký    
@api_view(['POST'])
def signup(request):
    if request.method == 'POST':
        data = request.data
        resStatus = Hirer.signUp(data)
        if resStatus == '200':
            return Response(status=status.HTTP_200_OK)
        elif resStatus == '409':
            return Response(status=status.HTTP_409_CONFLICT)
        elif resStatus == '404':
            return Response(status=status.HTTP_404_NOT_FOUND)

# Nhà tuyển dụng đổi mật khẩu  
@api_view(['POST'])
def changePassword(request, id):
    if request.method == 'POST':
        resStatus = Hirer.changePassword(request.data, id)
        if (resStatus == '200'):
            return Response(status=status.HTTP_200_OK)
        elif (resStatus == '401'):
            return Response(status=status.HTTP_401_UNAUTHORIZED)
        else:
            return Response(status=status.HTTP_404_NOT_FOUND)

# thông tin Nhà tuyển dụng
@api_view(['GET', 'PUT'])
def info(request, id):
    if request.method == 'GET':
        headers = request.headers
        token = headers.get('Authorization')
        responseData = Hirer.getInfo(token, id)
        if (responseData):
            return Response(status=status.HTTP_200_OK, data=responseData)
        else:
            return Response(status=status.HTTP_404_NOT_FOUND)
        
    if request.method == 'PUT':
        token = request.headers.get('Authorization')
        data = request.data
        responseData = Hirer.update(id, token, data)
        if (responseData == '200'):
            return Response(status=status.HTTP_200_OK)
        else:
            return Response(status=status.HTTP_404_NOT_FOUND)


# avatar nhà tuyển dụng
@api_view(['POST', 'PUT', 'DELETE'])
def avatar(request, id):
    if request.method == 'DELETE':
        token = request.headers.get('Authorization')
        if (Hirer.authenticateWithId(token, id)):
            Hirer.deleteAvatar(id)
            return Response(status=status.HTTP_200_OK)
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)

    if request.method == 'PUT':
        headers = request.headers
        token = headers.get('Authorization')
        data = request.data
        if ('avatar_url' in data and isinstance(data.get('avatar_url'), str) and Hirer.authenticateWithId(token, id)):
            Hirer.changeAvatar(id, data.get('avatar_url'))
            return Response(status=status.HTTP_200_OK)
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)


    if request.method == 'POST':
        headers = request.headers
        token = headers.get('Authorization')
        if (Hirer.authenticateWithId(token, id)):
            with open(FilePath.HIRER_AVATAR_DIR + f"//{id}.jpeg", "wb+") as destination:
                for chunk in request.FILES['image'].file:
                    destination.write(chunk)
            # Hirer.changeAvatar(id, f'http://192.168.1.5:8000/media/hirer/{id}.jpeg')
            Hirer.changeAvatar(id, f'http://127.0.0.1:8000/media/hirer/{id}.jpeg')
            return Response(status=status.HTTP_200_OK)
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)

@api_view(['GET'])
def statistic(request, id):
    if request.method == 'GET':
        responseData = Hirer.statistic(id, request.headers.get('Authorization'))
        if responseData:
            return Response(status=status.HTTP_200_OK, data=responseData)
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)
        
@api_view(['GET'])
def hirers(request):
    if request.method == 'GET':
        responseData = Hirer.hirers(request.GET, request.headers.get('Authorization'))
        if responseData is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        else:
            return Response(status=status.HTTP_200_OK, data=responseData)

