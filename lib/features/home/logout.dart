import 'package:flutter/material.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  Future<void> _logout() async {
    // Example async operation
    await Future.delayed(const Duration(seconds: 2));

    // ✅ Fix: check if widget is still mounted before using context
    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: _logout, child: const Text("Logout")),
      ),
    );
  }
}
