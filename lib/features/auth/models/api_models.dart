import 'package:flutter/foundation.dart';

// ==================== Auth Models ====================

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'confirmPassword': confirmPassword,
  };
}

class User {
  final int? id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? bio;
  final DateTime? createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.bio,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: null, // backend uses _id as String
    name: '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(),
    email: json['email'] ?? '',
    phone: json['phone'] as String?,
    avatar: json['avatar'] as String?,
    bio: json['bio'] as String?,
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString())
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'avatar': avatar,
    'bio': bio,
    'createdAt': createdAt?.toIso8601String(),
  };

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? bio,
    DateTime? createdAt,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    avatar: avatar ?? this.avatar,
    bio: bio ?? this.bio,
    createdAt: createdAt ?? this.createdAt,
  );
}

class AuthResponse {
  final String token;
  final User user;
  final String? refreshToken;

  AuthResponse({required this.token, required this.user, this.refreshToken});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString(),
      user: User.fromJson(json),
    );
  }
}

// ==================== PageView Models ====================

class PageViewCountRequest {
  final String pageName;

  PageViewCountRequest({required this.pageName});

  Map<String, dynamic> toJson() => {'pageName': pageName};

  Map<String, String> toQueryParams() => {'pageName': pageName};
}

class PageViewCountResponse {
  final String pageName;
  final int count;
  final DateTime? lastUpdated;

  PageViewCountResponse({
    required this.pageName,
    required this.count,
    this.lastUpdated,
  });

  factory PageViewCountResponse.fromJson(Map<String, dynamic> json) =>
      PageViewCountResponse(
        pageName: json['pageName'] ?? '',
        count: (json['count'] as num?)?.toInt() ?? 0,
        lastUpdated: json['lastUpdated'] != null
            ? DateTime.tryParse(json['lastUpdated'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
    'pageName': pageName,
    'count': count,
    'lastUpdated': lastUpdated?.toIso8601String(),
  };
}

class PageViewIncrementRequest {
  final String pageName;
  final String? userId;
  final String? sessionId;

  PageViewIncrementRequest({
    required this.pageName,
    this.userId,
    this.sessionId,
  });

  Map<String, dynamic> toJson() => {
    'pageName': pageName,
    if (userId != null) 'userId': userId,
    if (sessionId != null) 'sessionId': sessionId,
  };
}

class PageViewIncrementResponse {
  final String pageName;
  final int newCount;
  final bool success;

  PageViewIncrementResponse({
    required this.pageName,
    required this.newCount,
    required this.success,
  });

  factory PageViewIncrementResponse.fromJson(Map<String, dynamic> json) =>
      PageViewIncrementResponse(
        pageName: json['pageName'] ?? '',
        newCount: (json['newCount'] as num?)?.toInt() ?? 0,
        success: json['success'] ?? false,
      );

  Map<String, dynamic> toJson() => {
    'pageName': pageName,
    'newCount': newCount,
    'success': success,
  };
}

// ==================== Generic API Response ====================

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) => ApiResponse(
    success: json['success'] ?? false,
    message: json['message'] as String?,
    data: json['data'] != null ? fromJsonT(json['data']) : null,
    statusCode: json['statusCode'] as int?,
  );

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) => {
    'success': success,
    'message': message,
    if (data != null) 'data': toJsonT(data as T),
    'statusCode': statusCode,
  };
}

// ==================== Error Models ====================

@immutable
class ApiError {
  final String message;
  final int? statusCode;
  final String? code;
  final dynamic originalError;

  const ApiError({
    required this.message,
    this.statusCode,
    this.code,
    this.originalError,
  });

  @override
  String toString() =>
      'ApiError(message: $message, statusCode: $statusCode, code: $code)';
}
