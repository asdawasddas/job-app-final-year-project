from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view

from helpFunctions import *
from job_app.Models.admin import Admin

@api_view(['GET', 'POST'])
def login(request):
    if request.method == 'GET':
        responseData = Admin.authenticate(request.headers.get('Authorization'))
        if responseData:
            return Response(status=status.HTTP_200_OK, data=responseData)
        return Response(status=status.HTTP_404_NOT_FOUND)
        
    if request.method == 'POST':
        responseData = Admin.login(request.data)
        if responseData:
            return Response(status=status.HTTP_200_OK, data=responseData)
        return Response(status=status.HTTP_401_UNAUTHORIZED)

@api_view(['GET','PUT','DELETE'])
def getInfo(request, id):
    if request.method == 'GET':
        responseData = Admin.getInfo(id, request.headers.get('Authorization'))
        if responseData:
            return Response(status=status.HTTP_200_OK, data=responseData)
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'DELETE':
        responseData = Admin.delete(id, request.headers.get('Authorization'))
        if responseData:
            return Response(status=status.HTTP_200_OK,)
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'PUT':
        responseData = Admin.update(id, request.data, request.headers.get('Authorization'))
        if responseData:
            return Response(status=status.HTTP_200_OK,)
        return Response(status=status.HTTP_404_NOT_FOUND)

@api_view(['GET','POST'])
def admins(request):
    if request.method == 'GET':
        responseData = Admin.admins(request.headers.get('Authorization'))
        if responseData is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        return Response(status=status.HTTP_200_OK, data=responseData)
    
    if request.method == 'POST':
        responseData = Admin.create(request.data, request.headers.get('Authorization'))
        if responseData == '200':
            return Response(status=status.HTTP_200_OK,)
        elif responseData == '409':
            return Response(status=status.HTTP_409_CONFLICT,)
        return Response(status=status.HTTP_404_NOT_FOUND)

@api_view(['PUT'])
def changePassword(request, id):
    if request.method == 'PUT':
        responseData = Admin.changePassword(id, request.data, request.headers.get('Authorization'))
        if responseData:
            return Response(status=status.HTTP_200_OK,)
        return Response(status=status.HTTP_404_NOT_FOUND)