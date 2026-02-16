# API Integration Setup for Alumns App

## 🎯 Overview

This document describes the complete API integration setup for the Alumns Flutter app, connecting to the provided backend API endpoints.

## ✅ Setup Complete

All API services are now integrated with your Flutter frontend:

- ✅ **AuthenticationService** - Login, Register, Logout
- ✅ **PageViewService** - Track and count page views
- ✅ **UserService** - User profile management
- ✅ **ApiServiceManager** - Centralized service management
- ✅ **Secure Storage** - JWT token persistence via Flutter Secure Storage
- ✅ **Error Handling** - Unified ApiError model for consistent error handling

## 📋 API Endpoints

### Authentication Endpoints
```
POST   /auth/login           - User login
POST   /auth/register        - User registration  
POST   /auth/logout          - User logout
PUT    /auth/change-password - Change password (optional)
```

### User Endpoints
```
GET    /api/user             - Get current user profile
PUT    /api/user             - Update user profile
DELETE /api/user             - Delete account
GET    /api/users            - Get all users
GET    /api/users/:id        - Get specific user
POST   /api/user/change-password - Change password
```

### PageView Analytics Endpoints
```
GET    /api/v1/pageview/count      - Get page view count
POST   /api/v1/pageview/increment  - Increment page view
```

## 🔧 Service Configuration

### Base URLs
- **QA Environment**: `https://alumns-qa-render.onrender.com` (default)
- **Production**: `https://alumns.com`

### Configuration (in `lib/core/api/api_config.dart`)
```dart
// Switch between environments
ApiService.initialize(useQa: true);  // QA
ApiService.initialize(useQa: false); // Production
```

## 📦 Created Files

### Core API Files
- `lib/core/api/api_config.dart` - API configuration and constants
- `lib/core/api/api_service_manager.dart` - Central service manager
- `lib/core/api/api_helper.dart` - Helper utilities and extensions
- `lib/core/api/api_client.dart` - Updated with token handling

### Services
- `lib/services/authentication_service.dart` - Auth operations
- `lib/services/pageview_service.dart` - Page view tracking
- `lib/services/user_service.dart` - User management

### Models
- `lib/features/auth/models/api_models.dart` - All data models

## 🚀 Quick Start

### 1. Initialize in main.dart
```dart
void main() {
  // Initialize API Service
  ApiService.initialize(useQa: true);
  runApp(const MyApp());
}
```

### 2. Use in Screens

#### Login Example
```dart
await ApiHelper.performLogin(
  context: context,
  email: 'user@example.com',
  password: 'password',
  onSuccess: () => Navigator.pushReplacementNamed(context, '/home'),
);
```

#### Get User Profile
```dart
final user = await ApiHelper.getUserProfile(context: context);
print('User: ${user?.name}');
```

#### Track Page View
```dart
@override
void initState() {
  super.initState();
  context.trackPageView('home'); // Simple one-liner
}
```

## 📊 Data Models

### AuthResponse
```dart
AuthResponse {
  String token,           // JWT token
  User user,             // User information
  String? refreshToken   // Optional refresh token
}
```

### User
```dart
User {
  int? id
  String name
  String email
  String? phone
  String? avatar
  String? bio
  DateTime? createdAt
}
```

### PageViewCountResponse
```dart
PageViewCountResponse {
  String pageName
  int count
  DateTime? lastUpdated
}
```

## 🔐 Security

- **JWT Storage**: Uses `flutter_secure_storage` for secure token storage
- **Auto Token Injection**: Token automatically added to all authenticated requests
- **401 Handling**: Tokens cleared on unauthorized responses
- **Password Encryption**: Always use HTTPS in production

## ⚠️ Error Handling

All API errors are wrapped in `ApiError`:

```dart
try {
  await ApiService.auth.login(email: 'user@example.com', password: 'pass');
} on ApiError catch (e) {
  print('Error: ${e.message}');
  print('Status: ${e.statusCode}');
  print('Code: ${e.code}');
}
```

## 📝 Usage Examples

See `api_integration_guide.dart` for 17+ complete examples including:

1. Login in screens
2. User registration
3. Logout
4. Get/update user profile
5. Track page views
6. Get page view counts
7. Error handling
8. Secure storage access
9. Context extensions
10. Environment switching
11. And more...

## 🎨 Context Extensions

Simplified syntax available in BuildContext:

```dart
// Track page view
context.trackPageView('page_name');

// Show feedback
context.showSuccess('Operation successful');
context.showError('Error message');

// Manage dialogs
context.showLoading(message: 'Loading...');
context.closeLoading();

// Access API manager
final manager = context.apiManager;
```

## 🔄 Interceptors

The following interceptors are automatically configured:

1. **Auth Interceptor** - Adds JWT token to all requests
2. **401 Handler** - Clears token on unauthorized responses
3. **Logging Interceptor** - Logs requests/responses in debug mode

## 📱 Working with Static URLs

For accessing static files (images, media):

```
https://alumns.com/static/media/login.c08a1dc79c9b2e9654c1.jpg
```

Use standard Flutter Image widgets:

```dart
Image.network('https://alumns.com/static/media/login.c08a1dc79c9b2e9654c1.jpg')
```

## ✨ Features Included

- ✅ Centralized API management
- ✅ JWT token persistence
- ✅ Automatic token injection
- ✅ Comprehensive error handling
- ✅ Page view analytics
- ✅ User profile management
- ✅ Easy-to-use helper functions
- ✅ Context extensions
- ✅ Logging and debugging
- ✅ Environment switching (QA/Production)

## 🐛 Debugging

Enable verbose logging to see all API requests/responses:

```dart
// Already enabled in debug mode via LogInterceptor
// Check console for: 📤 request logs, 📥 response logs, ❌ error logs
```

## 📚 Related Files

- Main entry: `lib/main.dart`
- Configuration: `lib/core/api/api_config.dart`
- Implementation guide: `API_INTEGRATION_GUIDE.dart`
- Dependency configuration: `pubspec.yaml`

## 🎯 Next Steps

1. Review `API_INTEGRATION_GUIDE.dart` for implementation examples
2. Update your login screen to use `ApiHelper.performLogin()`
3. Add page view tracking to each screen's `initState()`
4. Update user profile screen to use `UserService`
5. Test with QA endpoint before switching to production
6. Configure production URL when production API is ready

## 📞 Support

For issues or questions:
1. Check error logs in console
2. Review example in `API_INTEGRATION_GUIDE.dart`
3. Verify API config in `lib/core/api/api_config.dart`
4. Check FlutterSecureStorage access in device permissions

---

**Status**: ✅ Ready for implementation
**Last Updated**: February 16, 2026
