import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alumns_app/features/home/widgets/app_layout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  // 👈 Make sure this matches the actual number of tabs in AppLayout
  int _currentIndex = 4; // set to last valid index if you only have 5 items

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/profile');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/events');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/jobs');
    } else if (index == 4) {
      Navigator.pushReplacementNamed(context, '/memory');
    } else if (index == 5) {
      // Organization tab — only valid if AppLayout has 6 items
      Navigator.pushReplacementNamed(context, '/organization');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: _buildOrganizationBody(),
      currentIndex: _currentIndex,
      onTabSelected: _onTabSelected,
    );
  }

  Widget _buildOrganizationBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: "Search ALUMNS",
                hintStyle: TextStyle(fontSize: 14.sp),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // ✅ My Organizations Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Organizations / Institutes / Schools",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5C3FCA),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Manage your organizations and members",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // ✅ Contact Us Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact Us",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5C3FCA),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Email: admin@aitreya.tech", // 👈 fixed email format
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // ✅ Branding Section
          Center(
            child: Column(
              children: [
                Text(
                  "ALUMNS",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5C3FCA),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Empowering Alumni Connections",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // ✅ Social Media Section
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.facebook,
                  color: const Color(0xFF5C3FCA),
                  size: 28.sp,
                ),
                SizedBox(width: 12.w),
                Icon(
                  FontAwesomeIcons.twitter,
                  color: const Color(0xFF5C3FCA),
                  size: 28.sp,
                ),
                SizedBox(width: 12.w),
                Icon(
                  FontAwesomeIcons.instagram,
                  color: const Color(0xFF5C3FCA),
                  size: 28.sp,
                ),
                SizedBox(width: 12.w),
                Icon(
                  FontAwesomeIcons.linkedin,
                  color: const Color(0xFF5C3FCA),
                  size: 28.sp,
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // ✅ Footer
          Center(
            child: Column(
              children: [
                Text(
                  "© 2025 ALUMNS",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  "© 2025 Aitreya Tech",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
