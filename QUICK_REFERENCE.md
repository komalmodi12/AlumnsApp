# 🚀 Alumns App - API Integration Quick Reference Card

## 📌 Pin This File for Quick Access

---

## ⚡ Ultra-Quick Start

### Initialize (Already Done in main.dart)
```dart
ApiService.initialize(useQa: true);  // QA: https://alumns-qa-render.onrender.com
ApiService.initialize(useQa: false); // Production: https://alumns.com
```

### Track Page View (1 line in initState)
```dart
context.trackPageView('page_name');
```

### Login (Call from button)
```dart
await ApiHelper.performLogin(
  context: context,
  email: 'user@example.com',
  password: 'password',
);
```

---

## 🎯 Common Tasks

### Login
```dart
final result = await ApiService.auth.login(
  email: 'user@example.com',
  password: 'password',
);
// result.token → JWT token (auto-stored)
// result.user → User object
```

### Register
```dart
final result = await ApiService.auth.register(
  name: 'John Doe',
  email: 'user@example.com',
  password: 'password',
  confirmPassword: 'password',
);
```

### Logout
```dart
await ApiService.auth.logout();
// Token automatically cleared
```

### Get User Profile
```dart
final user = await ApiService.user.getUserProfile();
// user.name, user.email, user.phone, user.avatar, user.bio
```

### Update Profile
```dart
final user = await ApiService.user.updateUserProfile(
  name: 'New Name',
  phone: '1234567890',
  avatar: 'https://...',
  bio: 'Updated bio',
);
```

### Track Page View
```dart
await ApiService.pageView.trackPageView(pageName: 'home');
```

### Get Page View Count
```dart
final count = await ApiService.pageView.getPageViewCount(
  pageName: 'home',
);
print('Views: ${count.count}');
```

### Check if Authenticated
```dart
final isAuth = await ApiService.manager.isAuthenticated();
```

### Get Token
```dart
final token = await ApiService.manager.getToken();
```

---

## 🎨 UI Helpers (Recommended)

### Show Success
```dart
context.showSuccess('Operation successful');
// or
ApiHelper.showSuccessSnackBar(context, 'Success message');
```

### Show Error
```dart
context.showError('Something went wrong');
// or
ApiHelper._showErrorSnackBar(context, 'Error message');
```

### Show Loading
```dart
context.showLoading(message: 'Loading...');
```

### Close Loading
```dart
context.closeLoading();
// or
ApiHelper.closeLoadingDialog(context);
```

### Safe Login with Error Handling
```dart
await ApiHelper.performLogin(
  context: context,
  email: email,
  password: password,
  onSuccess: () {
    context.showSuccess('Logged in!');
    Navigator.pushReplacementNamed(context, '/home');
  },
  onError: (error) {
    print('Error: ${error.message}');
  },
);
```

---

## 📁 File Locations

| What | Where |
|------|-------|
| Config | `lib/core/api/api_config.dart` |
| Services | `lib/services/*.dart` |
| Models | `lib/features/auth/models/api_models.dart` |
| Helpers | `lib/core/api/api_helper.dart` |
| Manager | `lib/core/api/api_service_manager.dart` |

---

## 🔗 API Endpoints

| Method | Endpoint | Service Method |
|--------|----------|-----------------|
| POST | `/auth/login` | `auth.login()` |
| POST | `/auth/register` | `auth.register()` |
| POST | `/auth/logout` | `auth.logout()` |
| PUT | `/auth/change-password` | `auth` (not wrapped) |
| GET | `/api/user` | `user.getUserProfile()` |
| PUT | `/api/user` | `user.updateUserProfile()` |
| DELETE | `/api/user` | `user.deleteAccount()` |
| GET | `/api/users` | `user.getAllUsers()` |
| GET | `/api/users/:id` | `user.getUserById()` |
| POST | `/api/user/change-password` | `user.changePassword()` |
| GET | `/api/v1/pageview/count` | `pageView.getPageViewCount()` |
| POST | `/api/v1/pageview/increment` | `pageView.incrementPageView()` |

---

## 📊 Data Models

### User
```dart
User {
  int? id,
  String name,
  String email,
  String? phone,
  String? avatar,
  String? bio,
  DateTime? createdAt
}
```

### AuthResponse
```dart
AuthResponse {
  String token,
  User user,
  String? refreshToken
}
```

### PageViewCountResponse
```dart
PageViewCountResponse {
  String pageName,
  int count,
  DateTime? lastUpdated
}
```

### ApiError
```dart
ApiError {
  String message,
  int? statusCode,
  String? code,
  dynamic originalError
}
```

---

## ⚠️ Error Handling

### Catch API Errors
```dart
try {
  await ApiService.auth.login(email: 'user@example.com', password: 'pass');
} on ApiError catch (e) {
  print('Error: ${e.message}');
  print('Status: ${e.statusCode}');
  print('Code: ${e.code}');
}
```

### Common Status Codes
| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success | Continue |
| 400 | Bad Request | Check input |
| 401 | Unauthorized | Clear token & redirect to login |
| 404 | Not Found | Show "Not found" message |
| 500 | Server Error | Show "Server error" message |

---

## 🔐 Security Notes

✅ JWT tokens automatically stored securely
✅ Tokens automatically added to all requests
✅ 401 responses automatically clear token
✅ Always use HTTPS in production
✅ Never hardcode credentials

---

## 🧪 Testing Checklist

- [ ] Login with valid credentials
- [ ] Login with invalid credentials (error shown)
- [ ] User profile loads
- [ ] Profile update works
- [ ] Page views tracked
- [ ] Logout clears token
- [ ] Token persists after app restart
- [ ] Network errors handled gracefully

---

## 🔄 Implementation Steps

### Step 1: Update Login Screen
```dart
// Add imports
import 'core/api/api_helper.dart';

// Use in button handler
await ApiHelper.performLogin(
  context: context,
  email: email,
  password: password,
);
```

### Step 2: Add Page Tracking
```dart
@override
void initState() {
  super.initState();
  context.trackPageView('page_name');
}
```

### Step 3: Add User Profile Loading
```dart
@override
void initState() {
  super.initState();
  _loadProfile();
}

void _loadProfile() async {
  final user = await ApiService.user.getUserProfile();
  if (user != null) {
    setState(() => _user = user);
  }
}
```

### Step 4: Add Logout
```dart
ElevatedButton(
  onPressed: () => ApiHelper.performLogout(context: context),
  child: const Text('Logout'),
)
```

---

## 📚 Documentation Files

| File | Purpose |
|------|-----------|
| `START_HERE.md` | Overview & quick start |
| `API_SETUP.md` | Setup & configuration |
| `api_integration_guide.dart` | 17+ code examples |
| `practical_implementation.dart` | Ready-to-use screens |
| `IMPLEMENTATION_CHECKLIST.md` | Step-by-step guide |
| `FILE_STRUCTURE.md` | File organization |
| `QUICK_REFERENCE.md` | This file |

---

## 💡 Pro Tips

1. **Always use context extensions** - They're cleaner:
   ```dart
   context.trackPageView('home');      // Instead of...
   context.showSuccess('Success');     // Instead of...
   context.showError('Error');         // Instead of...
   ```

2. **Use ApiHelper for UI screens** - Better error handling:
   ```dart
   await ApiHelper.performLogin(context: context, ...);
   ```

3. **Track all screens** - For analytics:
   ```dart
   context.trackPageView('screen_name'); // in initState
   ```

4. **Handle errors specifically**:
   ```dart
   if (error.statusCode == 401) {
     // Unauthorized - clear data
   } else if (error.statusCode == 404) {
     // Not found
   }
   ```

5. **Test with QA first** - Before production:
   ```dart
   ApiService.initialize(useQa: true);  // Test
   ApiService.initialize(useQa: false); // Production
   ```

---

## 🚨 Troubleshooting

| Problem | Solution |
|---------|----------|
| 401 Unauthorized | Login token expired - ask user to login again |
| Token not persisting | Check FlutterSecureStorage is properly set up |
| API not responding | Check base URL and network connection |
| Model serialization error | Verify API response matches model fields |
| Page tracking not working | Call `context.trackPageView()` in `initState` |
| Loading dialog stuck | Call `context.closeLoading()` after operation |

---

## 🎯 Your Next Actions

1. **Read**: `START_HERE.md` (5 min)
2. **Review**: `PRACTICAL_IMPLEMENTATION.dart` (15 min)
3. **Implement**: Update your login screen (30 min)
4. **Test**: Test login with QA endpoint (15 min)
5. **Extend**: Add profile screen, page tracking, logout (depends)

---

## 📞 Quick Lookups

**Where's the User model?**
→ `lib/features/auth/models/api_models.dart`

**How do I access the token?**
→ `await ApiService.manager.getToken()`

**How do I switch to production?**
→ `ApiService.initialize(useQa: false)`

**What are all the data models?**
→ Check `lib/features/auth/models/api_models.dart`

**How do I add error handling?**
→ See example 10 in `API_INTEGRATION_GUIDE.dart`

---

## ✅ Your Integration Status

- [x] API infrastructure set up
- [x] Services created and configured
- [x] Data models ready
- [x] Secure storage configured
- [x] Error handling in place
- [x] Documentation complete
- [ ] Update your login screen ← START HERE
- [ ] Add page tracking
- [ ] Implement user profile
- [ ] Add logout
- [ ] Test thoroughly
- [ ] Deploy

---

**Print This**: Save as PDF or bookmark for quick access during development

**Last Updated**: February 16, 2026
**Status**: Ready for Implementation ✅
