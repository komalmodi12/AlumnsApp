import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alumns_app/services/person.dart';
import 'package:alumns_app/services/people_service.dart';
import 'package:alumns_app/features/home/widgets/app_layout.dart';
import 'package:alumns_app/features/home/circle.dart';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({super.key});

  @override
  State<RecommendedPage> createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
  int selectedIndex = 0;

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentIndex: selectedIndex,
      onTabSelected: onTabSelected,
      body: Column(
        children: [
          // 🔹 Top 4 icons row
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CirclePage(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: const BoxDecoration(
                          color: Color(0xFF5C3FCA),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.group,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text("", style: TextStyle(fontSize: 12.sp)),
                    ],
                  ),
                ),

                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: const BoxDecoration(
                        color: Color(0xFF5C3FCA),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.send, color: Colors.white, size: 20.sp),
                    ),
                    SizedBox(height: 6.h),
                    Text("", style: TextStyle(fontSize: 12.sp)),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: const BoxDecoration(
                        color: Color(0xFF5C3FCA),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.inbox,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text("", style: TextStyle(fontSize: 12.sp)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // 👈 Just refresh the page
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: const BoxDecoration(
                          color: Color(0xFF5C3FCA),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text("", style: TextStyle(fontSize: 12.sp)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Recommended list (always visible, refreshes on tap)
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
                if (people.isEmpty) {
                  return const Center(
                    child: Text("No recommended people found"),
                  );
                }

                return ListView.builder(
                  itemCount: people.length,
                  itemBuilder: (context, index) {
                    final person = people[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(person.imageUrl),
                        ),
                        title: Text(person.name),
                        subtitle: Text(
                          "${person.role} • ${person.organization}",
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
