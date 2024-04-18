import cv2
from PIL import Image as im 
from matplotlib import pyplot as plt

image= cv2.imread('C:\\Users\\Garima Ranjan\\Desktop\\All files\\app_dev\\ML_django\\ML_model\\image.jpg')

rows,cols,channels = image.shape

rotate_90= cv2.rotate(image,cv2.ROTATE_90_CLOCKWISE)
data= im.fromarray(rotate_90)
print(data)
data.save('rotated_pic.jpg')
# print(type(rotate_90))