class ApiConstants {
  // Change this to your machine's IP when testing on a real device
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Auth endpoints
  static const String login = '$baseUrl/auth/login/';
  static const String register = '$baseUrl/auth/register/';
  static const String refreshToken = '$baseUrl/auth/token/refresh/';
  
  // App endpoints
  static const String borrowers = '$baseUrl/borrowers/';
  static const String loans = '$baseUrl/loans/';
  static const String payments = '$baseUrl/payments/';
  static const String reports = '$baseUrl/reports/';
  static const String recovery = '$baseUrl/recovery/';
}
