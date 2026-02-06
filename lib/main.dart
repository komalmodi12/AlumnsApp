import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/splash/splash_screen.dart';
import 'features/auth/Login/login_screen.dart';
import 'features/auth/Login/login_form_screen.dart';
import 'features/home/home_screen.dart';
import 'features/home/recommended_page.dart';
import 'features/home/logout.dart'; // ✅ added logout
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // base design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // 👇 For testing, start at LogoutPage
          initialRoute: '/login',

          routes: {
            // ✅ existing routes
            AppRoutes.splash: (context) => const SplashScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.loginForm: (context) => const LoginFormScreen(),
            AppRoutes.home: (context) => const HomeScreen(),
            AppRoutes.recommended: (context) => const RecommendedPage(),

            // ✅ new routes
            '/logout': (context) => const LogoutPage(),
          },
        );
      },
    );
  }
}
