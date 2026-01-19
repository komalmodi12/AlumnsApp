import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alumns_app/models/person.dart';
import 'package:alumns_app/services/people_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    // Start in the middle so you can scroll both directions infinitely
    _pageController = PageController(
      viewportFraction: 0.75,
      initialPage: 50000,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF3F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F6FF),
        elevation: 0,
        leadingWidth: 200.w,
        leading: SizedBox(
          width: 200.w,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.menu, color: Colors.black, size: 24.sp),
                onPressed: () {},
              ),
              SizedBox(width: 8.w),
              Image.asset('assets/images/AluLogo.png', height: 28.h),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: const Color(0xFF5C3FCA),
                size: 26.sp,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: TextField(
                        style: TextStyle(fontSize: 14.sp),
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(fontSize: 14.sp),
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Icon(
                    Icons.message,
                    color: const Color(0xFF5C3FCA),
                    size: 30.sp,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Mid card
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.r),
              ),
              elevation: 4,
              color: const Color(0xFFDACEF2),
              child: SizedBox(
                height: 200.h,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15.w),
                      child: Image.asset(
                        'assets/images/alu1.png',
                        width: 100.w,
                        height: 100.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "M.S Dhoni",
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "Add Intro Line",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Recommended header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommended",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Show All",
                    style: TextStyle(fontSize: 14.sp, color: Colors.blue),
                  ),
                ],
              ),
            ),

            // Carousel with scaling + shadow + circular scrolling
            Expanded(
              child: FutureBuilder<List<Person>>(
                future: PeopleService().loadLocalPeople(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  final people = snapshot.data ?? [];

                  return PageView.builder(
                    controller: _pageController,
                    itemCount: 100000, // huge number to simulate infinite loop
                    itemBuilder: (context, index) {
                      final person = people[index % people.length];

                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 1.0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                            value = (1 - (value.abs() * 0.3)).clamp(0.8, 1.0);
                          }
                          return Center(
                            child: Transform.scale(
                              scale: value,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 16.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    if (value > 0.95)
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                  ],
                                ),
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(person.imageUrl),
                              radius: 30.r,
                            ),
                            title: Text(
                              person.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${person.role}\n${person.organization}",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    bottomNavigationBar: Container(
    height: 70.h,
    color: Colors.white,
    child: Row(
      children: [
        // LEFT 1/3 — Home capsule
        Expanded(
          flex: 1, // 1/3 of total width
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEEE6FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF5C3FCA), // Alumns purple
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home, size: 22.sp, color: const Color(0xFF5C3FCA)),
                  SizedBox(width: 6.w),
                  Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5C3FCA),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

     
        Expanded(
          flex: 2, 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.people, size: 20.sp, color: Colors.grey),
              Icon(Icons.calendar_today, size: 20.sp, color: Colors.grey),
              Icon(Icons.apartment, size: 20.sp, color: Colors.grey),
              Icon(Icons.camera_alt, size: 20.sp, color: Colors.grey),
            ],
          ),
        ),
      ],
    ),
    ),

    );
  }
}
