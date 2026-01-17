import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F6FF),
        elevation: 0,
        leadingWidth: 200,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {},
            ),

            Image.asset('assets/images/AluLogo.png', height: 28),
          ],
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 300),
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
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),

                                  TextSpan(
                                    text: 'Roots...',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF5C3FCA),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: 450,
                              child: Text(
                                'Alumns is your bridge back to where it all began - your alma'
                                ' mater and the lifelong network that came with it.',
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
                              onPressed: () => Navigator.pushNamed(
                                context,
                                AppRoutes.loginForm,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _secondaryButton('Learn More'),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(), // pushes content to bottom

                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, bottom: 24),

                        child: Row(
                          children: [
                            Row(
                              children: [
                                _overlapAvatar(
                                  'assets/images/Ashutosh_Sir.png',
                                  0,
                                ),
                                _overlapAvatar(
                                  'assets/images/Dr. Shashi.png',
                                  -8,
                                ),
                                _overlapAvatar(
                                  'assets/images/Shalini_Singh.png',
                                  -16,
                                ),
                                _overlapAvatar('assets/images/user4.png', -24),
                              ],
                            ),

                            const SizedBox(width: 12),

                            const Text(
                              'Join our growing community of alumns',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
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
    );
  }
}

Widget _primaryButton(String text, {required VoidCallback onPressed}) {
  return SizedBox(
    width: 450,
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

Widget _secondaryButton(String text) {
  return Container(
    width: 450,
    height: 50,
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
  );
}

Widget _overlapAvatar(String imagePath, double offset) {
  return Transform.translate(
    offset: Offset(offset, 0),
    child: CircleAvatar(
      radius: 18,
      backgroundColor: Colors.white,
      child: CircleAvatar(radius: 16, backgroundImage: AssetImage(imagePath)),
    ),
  );
}
