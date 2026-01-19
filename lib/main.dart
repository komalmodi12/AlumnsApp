import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/login_form_screen.dart';
import 'features/home/home_screen.dart';
import 'routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main() {
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 690), // base design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => const MyApp(),
    

  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.loginForm: (context) => const LoginFormScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
      },
    );
  }
}
