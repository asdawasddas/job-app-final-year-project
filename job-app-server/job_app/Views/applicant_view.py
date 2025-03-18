import os
from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view

from helpFunctions import *
from files_path import FilePath
from job_app.Models.applicant import Applicant
from job_app.Models.job import Job
from job_app.Models.enterprise import Enterprise
from job_app.Models.application import Application


@api_view(['GET', 'POST'])
def login(request):
    if request.method == 'GET':
        responseData = Applicant.authenticate(request.headers.get('Authorization'))
        if responseData:
            return Response(status=status.HTTP_200_OK, data=responseData)
        return Response(status=status.HTTP_401_UNAUTHORIZED)
        
        
    if request.method == 'POST':
        data = request.data
        responseData = Applicant.login(data)
        if responseData:
            return Response(status=status.HTTP_200_OK, data=responseData)
        return Response(status=status.HTTP_401_UNAUTHORIZED)
  
@api_view(['POST'])
def signup(request):
    if request.method == 'POST':
        data = request.data
        resStatus = Applicant.signup(data)
        if resStatus == '200':
            return Response(status=status.HTTP_200_OK)
        elif resStatus == '409':
            return Response(status=status.HTTP_409_CONFLICT)
        elif resStatus == '404':
            return Response(status=status.HTTP_404_NOT_FOUND)

@api_view(['PUT'])
def changePassword(request, id):
    if request.method == 'PUT':
        resStatus = Applicant.changePassword(request.data, id)
        if (resStatus == '200'):
            return Response(status=status.HTTP_200_OK)
        if (resStatus == '401'):
            return Response(status=status.HTTP_401_UNAUTHORIZED)
        else:
            return Response(status=status.HTTP_404_NOT_FOUND)

@api_view(['GET', 'PUT'])
def info(request, id):
    if request.method == 'GET':
        responData = Applicant.getInfo(id, request.headers.get('Authorization'))
        if responData:
            return Response(status=status.HTTP_200_OK, data=responData)
        return Response(status=status.HTTP_404_NOT_FOUND)


    if request.method == 'PUT':
        responData = Applicant.update(id, request.headers.get('Authorization'), request.data)
        if responData:
            return Response(status=status.HTTP_200_OK)
        return Response(status=status.HTTP_404_NOT_FOUND)
        
@api_view(['POST', 'PUT', 'DELETE'])
def avatar(request, id):
    if request.method == 'POST':
        if Applicant.authenticateWithId(request.headers.get('Authorization'), id):
            with open(FilePath.APPLICANT_AVATAR_DIR + f"//{id}.jpeg", "wb+") as destination:
                for chunk in request.FILES['image'].file:
                    destination.write(chunk)
            # Applicant.changeAvatar(id, f'http://192.168.1.5:8000/media/applicant/{id}.jpeg')
            Applicant.changeAvatar(id, f'http://127.0.0.1:8000/media/applicant/{id}.jpeg')
            return Response(status=status.HTTP_200_OK)
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'PUT':
        if Applicant.authenticateWithId(request.headers.get('Authorization'), id):
            url = request.data.get('avatar_url') or ''
            Applicant.changeAvatar(id, url)
            return Response(status=status.HTTP_200_OK)
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'DELETE':
        if Applicant.authenticateWithId(request.headers.get('Authorization'), id):
            Applicant.deleteAvatar(id)
            return Response(status=status.HTTP_200_OK)
        
@api_view(['GET'])
def applicants(request):
    if request.method == 'GET':
        responseData = Applicant.applicants(request.GET, request.headers.get('Authorization'))
        if responseData is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        return Response(status=status.HTTP_200_OK, data=responseData)
        
@api_view(['GET'])
def favJobs(request, id):
    if request.method == 'GET':
        if not Applicant.authenticateWithId(request.headers.get('Authorization'), id):
            return Response(status=status.HTTP_404_NOT_FOUND)
        responseData = Job.applicantFavJobs(id)
        print(responseData)
        return Response(status=status.HTTP_200_OK, data=responseData)

@api_view(['GET'])
def favEnterprises(request, id):
    if request.method == 'GET':
        if not Applicant.authenticateWithId(request.headers.get('Authorization'), id):
            return Response(status=status.HTTP_404_NOT_FOUND)
        responseData = Enterprise.applicantFav(id)
        return Response(status=status.HTTP_200_OK, data=responseData)

@api_view(['GET'])
def favEnterprisesJobs(request, id):
    if request.method == 'GET':
        if not Applicant.authenticateWithId(request.headers.get('Authorization'), id):
            return Response(status=status.HTTP_404_NOT_FOUND)
        responseData = Job.favEnterprisesJob(id)
        print(responseData)
        return Response(status=status.HTTP_200_OK, data=responseData)

@api_view(['GET'])
def appliedJobs(request, id):
    if request.method == 'GET':
        responseData = Application.applicantApplications(request.headers.get('Authorization'), id)
        if responseData is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        return Response(status=status.HTTP_200_OK, data=responseData)
