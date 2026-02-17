import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alumns_app/features/home/widgets/app_layout.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  int _currentIndex = 3; // Jobs tab index
  int _selectedTab = 0; // 0=All, 1=Applied, 2=Posted

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
      // Already on Jobs
    } else if (index == 4) {
      Navigator.pushReplacementNamed(context, '/memory');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: _buildJobsBody(),
      currentIndex: _currentIndex,
      onTabSelected: _onTabSelected,
    );
  }

  Widget _buildJobsBody() {
    final List<String> tabs = ["All Jobs", "Applied Jobs", "Posted Jobs"];

    final List<Map<String, String>> jobs = [
      {
        "id": "JOB920e",
        "position": "SDE",
        "company": "Alitreya Tech Solution",
        "location": "Prayagraj",
      },
      {
        "id": "JOBa5f5",
        "position": "Sales Executive",
        "company": "HDFC Bank",
        "location": "Allahabad",
      },
      {
        "id": "JOB2b2z",
        "position": "SDE",
        "company": "Alitreya Tech Solution",
        "location": "Prayagraj",
      },
    ];

    return Column(
      children: [
        // ✅ Tabs
        SizedBox(
          height: 50.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              final bool isSelected = _selectedTab == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTab = index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF5C3FCA)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 10.h),

        // ✅ Search bar + filters
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: "Search by job title, company, location, etc.",
                    hintStyle: TextStyle(fontSize: 14.sp),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 12.w,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF5C3FCA),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "Filters",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 15.h),

        // ✅ Job Table
        Expanded(
          child: ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                padding: EdgeInsets.all(12.w),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job ID
                    Text(
                      "Job ID: ${job['id']}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5C3FCA),
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Position
                    Text(
                      "Position: ${job['position']}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Company + Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Company: ${job['company']}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          "Location: ${job['location']}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // ✅ Pagination
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  
                },
                child: Text(
                  "Previous",
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C3FCA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  
                },
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
