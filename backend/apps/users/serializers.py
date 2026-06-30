from rest_framework import serializers
from django.contrib.auth import get_user_model

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'email', 'phone', 'full_name', 'role', 'is_verified']
        read_only_fields = ['id', 'role', 'is_verified']
        extra_kwargs = {
            'password': {'write_only': True}
        }
    
    def create(self, validated_data):
        user = User.objects.create_user(
            email=validated_data['email'],
            username=validated_data['email'],
            full_name=validated_data.get('full_name', ''),
            phone=validated_data.get('phone', ''),
            password=validated_data['password']
        )
        return user
