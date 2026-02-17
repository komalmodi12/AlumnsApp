import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alumns_app/features/home/widgets/app_layout.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _currentIndex = 2; // Events tab index
  int _selectedTab = 0; // 0=All, 1=Posted, 2=Attending, 3=Invites

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/profile');
    } else if (index == 2) {
      // Already on Events
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/jobs');
    } else if (index == 4) {
      Navigator.pushReplacementNamed(context, '/circle');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: _buildEventsBody(),
      currentIndex: _currentIndex,
      onTabSelected: _onTabSelected,
    );
  }

  Widget _buildEventsBody() {
    final List<String> tabs = [
      "All Events",
      "Posted Events",
      "Attending Events",
      "Event Invites",
    ];

    final List<Map<String, String>> events = [
      {
        "code": "CONF000001",
        "title": "Alumni Meet 2025 – NIT Allahabad",
        "type": "CONFERENCE",
        "start": "11/18/23 4:00 PM",
      },
      {
        "code": "ALUM000001",
        "title": "Interaction",
        "type": "OTHER",
        "start": "9/19/23 11:00 AM",
      },
      {
        "code": "MEET000001",
        "title": "IIM Lucknow – 12th Batch meet at Noida Campus",
        "type": "MEETUP",
        "start": "8/2/23 10:00 AM",
      },
    ];

    return Column(
      children: [
        // Tabs
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

        // Search bar + filters
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: "Search Events",
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

        // Event Table
        Expanded(
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
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
                    // Event Code
                    Text(
                      "Event Code: ${event['code']}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5C3FCA),
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Event Title
                    Text(
                      event['title']!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Type + Start Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Type: ${event['type']}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          "Start: ${event['start']}",
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
      ],
    );
  }
}
