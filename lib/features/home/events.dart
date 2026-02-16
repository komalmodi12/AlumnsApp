import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alumns_app/features/home/widgets/app_layout.dart';
import 'package:alumns_app/core/api/api_helper.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _currentIndex = 2; // Events tab index
  int _selectedTab = 0; // 0=All, 1=Posted, 2=Attending, 3=Invites
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.trackPageView('events');
  }

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

    // Sample event data - Replace with API call when available
    final List<Map<String, dynamic>> events = [
      {
        "id": "EVT001",
        "title": "Annual Alumni Meet 2026",
        "date": "March 15, 2026",
        "time": "6:00 PM - 9:00 PM",
        "location": "Grand Ballroom, Downtown",
        "description":
            "Join us for an evening of networking with fellow alumni",
        "attendees": 150,
      },
      {
        "id": "EVT002",
        "title": "Tech Workshop Series",
        "date": "March 20, 2026",
        "time": "10:00 AM - 12:00 PM",
        "location": "Virtual Event",
        "description":
            "Learn about latest technologies and career opportunities",
        "attendees": 85,
      },
      {
        "id": "EVT003",
        "title": "Sports Day Championship",
        "date": "April 5, 2026",
        "time": "9:00 AM - 5:00 PM",
        "location": "University Sports Complex",
        "description": "Compete with your peers in various sports activities",
        "attendees": 200,
      },
    ];

    // Filter events based on search query
    final filteredEvents = events
        .where(
          (event) =>
              event['title'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              event['location'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();

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
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: "Search events...",
                    hintStyle: TextStyle(fontSize: 14.sp),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
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
          child: filteredEvents.isEmpty
              ? const Center(
                  child: Text('No events found matching your search'),
                )
              : ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
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
                          // Event ID
                          Text(
                            "Event ID: ${event['id']}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF5C3FCA),
                            ),
                          ),
                          SizedBox(height: 6.h),

                          // Event Title
                          Text(
                            event['title'],
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 6.h),

                          // Date & Time
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "📅 ${event['date']}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                "🕐 ${event['time']}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          // Location
                          Text(
                            "📍 ${event['location']}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // Description
                          Text(
                            event['description'],
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),

                          // Attendees Count
                          Row(
                            children: [
                              const Icon(Icons.people, size: 16, color: Colors.grey),
                              SizedBox(width: 4.w),
                              Text(
                                "${event['attendees']} attending",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          // Action Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5C3FCA),
                              ),
                              onPressed: () {
                                
                                context.showSuccess('Event details coming soon');

                                context.showSuccess('Event marked as attending');
                              },
                              child: Text(
                                'Mark As Attending',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
