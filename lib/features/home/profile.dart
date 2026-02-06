import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alumns_app/features/home/widgets/app_layout.dart';
import 'package:vector_math/vector_math_64.dart' as vmath; // for Vector3

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 1;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _focusedPage = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigation logic (replace with your routes)
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      // Already on Profile
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/events');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/jobs');
    } else if (index == 4) {
      Navigator.pushReplacementNamed(context, '/circle');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: _buildProfileCarousel(),
      currentIndex: _currentIndex,
      onTabSelected: _onTabSelected,
    );
  }

  Widget _buildProfileCarousel() {
    final List<String> sections = ["Personal", "Professional", "Education"];

    return SizedBox(
      height: 600.h,
      child: PageView.builder(
        controller: _pageController,
        itemCount: sections.length,
        onPageChanged: (index) {
          setState(() {
            _focusedPage = index;
          });
        },
        itemBuilder: (context, index) {
          final bool isFocused = _focusedPage == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: isFocused ? 20.h : 40.h,
            ),
            transform: Matrix4.identity()
              ..scaleByVector3(vmath.Vector3.all(isFocused ? 1.0 : 0.9)),
            decoration: BoxDecoration(
              color: const Color(0xFF5C3FCA),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: isFocused
                  ? [
                      const BoxShadow(
                        color: Colors.black26, // ✅ fixed
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sections[index],
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          // For example, open a dialog or navigate to a detailed edit page
                          debugPrint("Edit ${sections[index]} section");
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _buildSectionFields(sections[index]),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical: 12.h,
                      ),
                    ),
                    onPressed: () {
                      // Save logic here
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF5C3FCA),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildSectionFields(String section) {
    switch (section) {
      case "Personal":
        return [
          _buildTextField("First Name"),
          _buildTextField("Last Name"),
          _buildTextField("Email"),
          _buildTextField("Mobile"),
          _buildTextField("Date of Birth"),
          _buildTextField("Gender"),
          _buildTextField("Brief Introduction", maxLines: 2),
          _buildTextField("About Me", maxLines: 3),
          _buildTextField("Country"),
          _buildTextField("State"),
          _buildTextField("City"),
          _buildTextField("Street"),
          _buildTextField("Pincode"),
          _buildTextField("LinkedIn"),
          _buildTextField("Instagram"),
          _buildTextField("Facebook"),
        ];
      case "Professional":
        return [
          _buildTextField("Company Name"),
          _buildTextField("Current Employment"), // e.g., Yes/No
          _buildTextField(
            "Employment Type",
          ), // e.g., Full-time, Part-time, Contract
          _buildTextField("Designation"),
          _buildTextField("Country"),
          _buildTextField("State"),
          _buildTextField("City"),
          _buildTextField("Salary Band"), // explanation below
          _buildTextField("Start Year"),
          _buildTextField("End Year"),
          _buildTextField("Skills", maxLines: 2),
        ];
      case "Education":
        return [
          _buildTextField("Qualification"), // e.g., Bachelor's, Master's, PhD
          _buildTextField("Program"), // e.g., B.Tech, MBA
          _buildTextField(
            "Specialization",
          ), // e.g., Computer Science, Marketing
          _buildTextField(
            "Program Type",
          ), // e.g., Full-time, Part-time, Distance
          _buildTextField("University"),
          _buildTextField("Institute"),
          _buildTextField("Start Year"),
          _buildTextField("Completion Year"),
          _buildTextField("Country"),
          _buildTextField("State"),
          _buildTextField("City"),
          _buildTextField("Pincode"),
          _buildTextField("Percentage or CGPA"), // academic performance
          _buildTextField("Achievements", maxLines: 2),
        ];
      default:
        return [];
    }
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextField(
        maxLines: maxLines,
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
    );
  }
}
