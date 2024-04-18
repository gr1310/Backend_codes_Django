from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from rest_framework.parsers import JSONParser
from django.http.response import JsonResponse

from ImageApp.models import Images
from ImageApp.serializers import ImageSerializer

from django.core.files.storage import default_storage
# Create your views here.
import cv2
import numpy as np
from PIL import Image
import base64
from io import BytesIO

# Function to convert base64 string to numpy array
def base64_to_numpy(base64_string):
    decoded_data = base64.b64decode(base64_string)
    nparr = np.frombuffer(decoded_data, np.uint8)
    img_np = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    return img_np

def rotateImage(images):
    img64= base64_to_numpy(images['ImagePath'])
    # Rotate the image
    rotated_image = cv2.rotate(img64, cv2.ROTATE_90_CLOCKWISE)
    pil_image = Image.fromarray(rotated_image)
    buffered = BytesIO()
    pil_image.save(buffered, format="JPEG")
    image_bytes = buffered.getvalue()

    # Encode the bytes using base64
    base64_image = base64.b64encode(image_bytes).decode()
    images['ImagePath']= base64_image
    return images

@csrf_exempt

def imageApi(request, id=0):
    if request.method=='GET':
        images= Images.objects.all()
        # print(images)
        images_serializer= ImageSerializer(images,many=True)
        return JsonResponse(images_serializer.data, safe=False)
    
    elif request.method=='POST':
        images_data= JSONParser().parse(request)
        print(images_data)
        images_data=rotateImage(images_data)
        print(images_data)
        images_serializer= ImageSerializer(data= images_data)
        
        if images_serializer.is_valid():
            images_serializer.save()
            return JsonResponse("Added Successfully", safe=False)
        return JsonResponse("Failed to add", safe=False)
    
    elif request.method=='PUT':
        images_data= JSONParser().parse(request)
        image= Images.objects.get(ImageId= images_data['ImageId'])
        images_serializer= ImageSerializer(image, data=images_data)
        if images_serializer.is_valid():
            images_serializer.save()
            return JsonResponse("Updated Successfully", safe=False)
        return JsonResponse("Failed to update", safe=False)
    
    elif request.method=='DELETE':
        image= Images.objects.get(ImageId= id)
        image.delete()
        return JsonResponse("Deleted Successfully", safe=False)
    
@csrf_exempt

def SaveFile(request):
    file= request.FILES['file']
    file_name= default_storage.save(file.name,file)
    return JsonResponse(file_name, safe=False)

import cv2
from PIL import Image as im 
from matplotlib import pyplot as plt

# @csrf_exempt

# def RotateImage(request):
#     file= request.FILES['file']

#     image= cv2.imread(file)

#     rows,cols,channels = image.shape

#     rotate_90= cv2.rotate(image,cv2.ROTATE_90_CLOCKWISE)
#     data= im.fromarray(rotate_90)
#     print(data)
#     file_name= default_storage.save(file.name,file)
#     return JsonResponse(file_name, safe=False)