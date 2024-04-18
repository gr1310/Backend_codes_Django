from rest_framework import serializers
from ImageApp.models import Images

class ImageSerializer(serializers.ModelSerializer):
    class Meta:
        model= Images
        fields= ('ImageId', 'ImagePath')