import requests
import os
from django.conf import settings

class PayChanguClient:
    BASE_URL = "https://api.paychangu.com/v1"  # Replace with actual URL
    PAYOUT_URL = f"{BASE_URL}/payouts/mobile-money"
    VERIFY_URL = f"{BASE_URL}/transactions/verify"
    
    @classmethod
    def get_headers(cls):
        return {
            "Authorization": f"Bearer {os.getenv('PAYCHANGU_SECRET_KEY')}",
            "Content-Type": "application/json"
        }
    
    @classmethod
    def send_money(cls, phone_number, amount, reference):
        """Send money to borrower via mobile money"""
        payload = {
            "phone_number": phone_number,
            "amount": amount,
            "reference": reference,
            "network": "airtel_money",  # or tnm_mpamba
            "description": "Loan disbursement"
        }
        
        response = requests.post(
            cls.PAYOUT_URL,
            json=payload,
            headers=cls.get_headers()
        )
        
        return response.json()
    
    @classmethod
    def verify_payment(cls, transaction_id):
        """Verify payment status"""
        response = requests.get(
            f"{cls.VERIFY_URL}/{transaction_id}",
            headers=cls.get_headers()
        )
        return response.json()
    
    @classmethod
    def generate_payment_link(cls, amount, reference, borrower_email):
        """Generate payment link for borrower"""
        payload = {
            "amount": amount,
            "reference": reference,
            "email": borrower_email,
            "description": "Loan repayment"
        }
        
        response = requests.post(
            f"{cls.BASE_URL}/checkout/initiate",
            json=payload,
            headers=cls.get_headers()
        )
        
        return response.json()