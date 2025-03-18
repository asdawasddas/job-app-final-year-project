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

# print(FilePath.CV_DIR)

@api_view(['GET','PUT', 'DELETE', 'POST'])
def detail(request, id):
    # Get Job detail
    if request.method == 'GET':
        responseData = Job.detail(id)
        if not responseData:
            return Response(status=status.HTTP_404_NOT_FOUND)
        return Response(status=status.HTTP_200_OK, data=responseData[0])
    
    # Update Job
    if request.method == 'PUT':        
        responseData = Job.update(id, request.headers.get('Authorization'), request.data)
        if (responseData == '200'):
            return Response(status=status.HTTP_200_OK)
        else:
            return Response(status=status.HTTP_404_NOT_FOUND)
    
    # Close job
    if request.method == 'DELETE':
        responseData = Job.close(id, request.headers.get('Authorization'))
        if responseData == '200':
            return Response(status=status.HTTP_200_OK)
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    # Apply job cv
    if request.method == 'POST':
        if not Job.appliable(id):
            return Response(status=status.HTTP_410_GONE)
        if not Applicant.authenticate(request.headers.get('Authorization')) or Applicant.isBlocked(request.headers.get('Authorization')):
            return Response(status=status.HTTP_403_FORBIDDEN)
        if not os.path.exists(FilePath.CV_DIR + f'//{id}'):
            try:
                os.makedirs(FilePath.CV_DIR + f'//{id}')
            except OSError as e:
                return Response(status=status.HTTP_404_NOT_FOUND)
            
        applicantId = verifyToken(request.headers.get('Authorization')).get('id')
        with open(FilePath.CV_DIR + f"//{id}//{applicantId}.pdf", "wb+") as destination:
            for chunk in request.FILES['cv'].file:
                destination.write(chunk)
        # Application.create(applicantId, id, f'http://192.168.1.5:8000/media/cv/{id}//{applicantId}.pdf')
        Application.create(applicantId, id, f'http://127.0.0.1:8000/media/cv/{id}//{applicantId}.pdf')
        return Response(status=status.HTTP_200_OK)


@api_view(['GET','POST'])
def jobs(request):
    if request.method == 'GET':
        responseData = Job.search(request.GET)
        if responseData is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        return Response(status=status.HTTP_200_OK, data=responseData)
    
    if request.method == 'POST':
        responseData = Job.create(request.headers.get('Authorization'), request.data)
        if responseData is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        return Response(status=status.HTTP_200_OK, data=responseData)