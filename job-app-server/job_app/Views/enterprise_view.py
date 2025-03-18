import os
from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view

from helpFunctions import *
from files_path import FilePath
from job_app.Models.hirer import Hirer
from job_app.Models.enterprise import Enterprise
from job_app.Models.job import Job

@api_view(['GET', 'PUT'])
def info(request, id):
    if request.method == 'GET':
        responseData = Enterprise.getInfo(id)
        if (responseData):
            return Response(status=status.HTTP_200_OK, data=responseData)
        else:
            return Response(status=status.HTTP_404_NOT_FOUND)
        
    if request.method == 'PUT':
        data = request.data
        token = request.headers.get('Authorization')
        responseData = Enterprise.update(id, token, data)
        if (responseData == '200'):
            return Response(status=status.HTTP_200_OK)
        elif responseData == '409':
            return Response(status=status.HTTP_409_CONFLICT)
        else:
            return Response(status=status.HTTP_403_FORBIDDEN)

@api_view(['POST', 'DELETE'])
def logo(request, id):
    if request.method == 'POST':
        token = request.headers.get('Authorization')
        if (Hirer.authenticateEnterprise(token, id)):
            with open(FilePath.HIRER_LOGO_DIR + f"//{id}.jpeg", "wb+") as destination:
                for chunk in request.FILES['image'].file:
                    destination.write(chunk)
            # Enterprise.changeLogo(id, f'http://192.168.1.5:8000/media/enterprise/{id}.jpeg')
            Enterprise.changeLogo(id, f'http://127.0.0.1:8000/media/enterprise/{id}.jpeg')
            return Response(status=status.HTTP_200_OK)
        else:
            return Response(status=status.HTTP_403_FORBIDDEN)

    
    if request.method == 'DELETE':
        token = request.headers.get('Authorization')
        if (Hirer.authenticateEnterprise(token, id)):
            Enterprise.deleteLogo(id)
            return Response(status=status.HTTP_200_OK)
        else:
            return Response(status=status.HTTP_403_FORBIDDEN)
        
@api_view(['GET', 'POST'])  
def enterprises(request):
    if request.method =='GET':
        responseData = Enterprise.enterprises(request.GET)
        return Response(status=status.HTTP_200_OK, data=responseData)
    
    if request.method == 'POST':
        responseData = Enterprise.create(request.headers.get('Authorization'), request.data)
        if responseData == '409':
            return Response(status=status.HTTP_409_CONFLICT)
        if responseData == '200':
            return Response(status=status.HTTP_200_OK,)
        return Response(status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
def jobs(request, id):
    if request.method =='GET':
        responseData = Job.enterpriseJobs(id)
        return Response(status=status.HTTP_200_OK, data=responseData)