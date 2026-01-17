import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import '../../../routes/app_routes.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});



  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repo = AuthRepository();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FF),
      appBar: AppBar(backgroundColor: const Color(0xFFF3F6FF)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 44.0),
                      child: Image.asset(
                        'assets/images/AluLogo.png',
                        height: 54,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCE6FF),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.black54,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _idController,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlign: TextAlign.left,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: const InputDecoration(
                                    hintText: 'User ID (email)',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 12,
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    final emailRegex = RegExp(
                                      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}",
                                    );
                                    if (!emailRegex.hasMatch(v)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCE6FF),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.lock,
                                  color: Colors.black54,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _passwordController,
                                  textAlign: TextAlign.left,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: const InputDecoration(
                                    hintText: 'Password',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 12,
                                    ),
                                  ),
                                  obscureText: true,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Please enter your password'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_error != null) ...[
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                        ],
                        _loading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF373636),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Sign In'),
                                ),
                              ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: OutlinedButton(
                            onPressed: _handleGoogle,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: Image.asset(
                                      'assets/images/google-logo-png-29534.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Continue with Google',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _handleForgotPassword,
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.black54),
                              ),
                              TextButton(
                                onPressed: _handleSignUp,
                                child: const Text('Sign Up'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final id = _idController.text.trim();
    final password = _passwordController.text;

    final success = await _repo.login(id: id, password: password);

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
    });

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      setState(() {
        _error = 'Login failed. Check your credentials.';
      });
    }
  }

  Future<void> _handleGoogle() async {
    // Placeholder - replace with real Google sign-in flow
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Continue with Google')));
  }

  void _handleForgotPassword() {
    // Placeholder - replace with real forgot-password flow/navigation
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Forgot password tapped')));
  }

  void _handleSignUp() {
    // Validate email and password then navigate to home (replace with real sign-up flow if needed)
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // At this point we could create the account; for now navigate to Home
    if (!mounted) {
      return;
    }
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
