import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F6FF),
        elevation: 0,
        leadingWidth: 200,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20), // 👈 space before image
              child: Image.asset('assets/images/AluLogo.png', height: 28),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top:
                              constraints.maxHeight * 0.2, // responsive spacing
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Connecting ',
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Roots...',
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF5C3FCA),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: constraints.maxWidth * 0.9,
                                child: const Text(
                                  'Alumns is your bridge back to where it all began - your alma mater and the lifelong network that came with it.',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              _primaryButton(
                                'Join Now',
                                constraints,
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.loginForm,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _secondaryButton('Learn More', constraints),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, bottom: 24),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  _overlapAvatar(
                                    imagePath: 'assets/images/Ashutosh_Sir.png',
                                    offset: 0,
                                  ),
                                  _overlapAvatar(
                                    imagePath: 'assets/images/Dr. Shashi.png',
                                    offset: -8,
                                  ),
                                  _overlapAvatar(
                                    imagePath:
                                        'assets/images/Shalini_Singh.png',
                                    offset: -16,
                                  ),
                                  // ✅ Colored avatar instead of image
                                  _overlapAvatar(
                                    offset: -24,
                                    backgroundColor: Colors.purple,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Join our growing community of alumns',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _primaryButton(
  String text,
  BoxConstraints constraints, {
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: constraints.maxWidth * 0.9,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5E4FD1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget _secondaryButton(String text, BoxConstraints constraints) {
  return SizedBox(
    width: constraints.maxWidth * 0.9,
    height: 50,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFF5C3FCA), width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5C3FCA),
        ),
      ),
    ),
  );
}

/// Flexible overlap avatar: supports image OR background color
Widget _overlapAvatar({
  String? imagePath,
  double offset = 0,
  Color? backgroundColor,
}) {
  return Transform.translate(
    offset: Offset(offset, 0),
    child: CircleAvatar(
      radius: 18,
      backgroundColor: Color(0xFFDACEF2),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: backgroundColor ?? Colors.white,
        backgroundImage: imagePath != null ? AssetImage(imagePath) : null,
        child: imagePath == null
            ? const Icon(Icons.person, color: Colors.white, size: 16)
            : null,
      ),
    ),
  );
}
