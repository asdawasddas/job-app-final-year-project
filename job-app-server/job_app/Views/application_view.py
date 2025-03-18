import os
from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view

from helpFunctions import *
from files_path import FilePath
from job_app.Models.applicant import Applicant
from job_app.Models.application import Application
from job_app.Models.hirer import Hirer
from job_app.Models.job import Job

@api_view(['GET','PUT'])
def detail(request, id):
    if request.method == 'GET':
        # responseData = Job.getJob(id)
        # if responseData is None:
        #     return Response(status=status.HTTP_404_NOT_FOUND)
        return Response(status=status.HTTP_200_OK)
    
    if request.method == 'PUT':        
        responseData = Application.update(id, request.headers.get('Authorization'), request.data)
        if (not responseData):
            return Response(status=status.HTTP_404_NOT_FOUND)
        return Response(status=status.HTTP_200_OK)
    
@api_view(['GET','POST'])
def applications(request):
    if request.method == 'GET':
        # responseData = Job.hirerJobs(id)
        # if responseData is None:
        #     return Response(status=status.HTTP_404_NOT_FOUND)
        return Response(status=status.HTTP_200_OK,)
    
    if request.method == 'POST':
        return Response(status=status.HTTP_200_OK,)

@api_view(['GET'])
def jobApplications(request, id):
    if request.method == 'GET':
        sort = request.GET.get('sort', '0')
        sort = -1 if sort == '0' else 1
        token = request.headers.get('Authorization')
        responseData = Application.jobApplications(id, token, sort)
        if responseData is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        return Response(status=status.HTTP_200_OK, data=responseData)
    