from rest_framework import serializers
from .models import Borrower

class BorrowerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Borrower
        fields = '__all__'
        read_only_fields = ['created_by', 'is_verified']

class BorrowerCreateSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(write_only=True)
    
    class Meta:
        model = Borrower
        fields = ['full_name', 'phone', 'email', 'address']
    
    def create(self, validated_data):
        email = validated_data.pop('email')
        from django.contrib.auth import get_user_model
        User = get_user_model()
        
        # Create user account
        user = User.objects.create_user(
            username=email,
            email=email,
            phone=validated_data['phone'],
            full_name=validated_data['full_name'],
            role='borrower',
            is_active=True,
            is_verified=False
        )
        
        # Create borrower profile
        borrower = Borrower.objects.create(
            user=user,
            created_by=self.context['request'].user,
            **validated_data
        )
        
        return borrower

class BorrowerVerificationSerializer(serializers.Serializer):
    national_id = serializers.CharField()
    id_front = serializers.ImageField()
    id_back = serializers.ImageField()
    selfie = serializers.ImageField()