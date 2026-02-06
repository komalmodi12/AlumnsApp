import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedCarouselList extends StatefulWidget {
  final int itemCount;

  const AnimatedCarouselList({super.key, required this.itemCount});

  @override
  State<AnimatedCarouselList> createState() => _AnimatedCarouselListState();
}

class _AnimatedCarouselListState extends State<AnimatedCarouselList> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Start in the middle so user can scroll both directions infinitely
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: widget.itemCount * 1000, // big offset
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.h,
      child: PageView.builder(
        controller: _pageController,
        // instead of itemCount, make it "infinite"
        itemBuilder: (context, index) {
          // map index back to real item using modulo
          final realIndex = index % widget.itemCount;

          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = (1 - (value.abs() * 0.3)).clamp(0.85, 1.0);
              }
              return Transform.scale(scale: value, child: child);
            },
            child: _profileCard(realIndex),
          );
        },
      ),
    );
  }

  Widget _profileCard(int index) {
    return Container(
      width: 260.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // 🔹 Square top half
          Container(
            height: 110.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
              color: const Color(0xFFDACEF2),
              image: DecorationImage(
                image: AssetImage('assets/images/Dr.Shashi.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Bottom half text
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile $index",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text("Role", style: TextStyle(fontSize: 13.sp)),
                  Text(
                    "Company",
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
