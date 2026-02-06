import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alumns_app/features/home/events.dart';
import 'package:alumns_app/features/home/home_screen.dart';
import 'package:alumns_app/features/home/profile.dart';
import 'package:alumns_app/features/home/jobs.dart';
import 'package:alumns_app/features/home/circle.dart';
import 'package:alumns_app/features/home/memory_page.dart';
import 'package:alumns_app/features/home/organization_page.dart'; // 👈 import OrganizationPage

class AppLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Function(int) onTabSelected;

  const AppLayout({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FF),

      // ✅ Top AppBar
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F6FF),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black, size: 24.sp),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // ✅ open drawer
            },
          ),
        ),
        title: Image.asset(
          'assets/images/AluLogo.png',
          height: 28.h,
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: const Color(0xFF5C3FCA),
              size: 26.sp,
            ),
            onPressed: () {},
          ),
        ],
      ),

      // ✅ Drawer (Hamburger Menu)
      drawer: Drawer(
        child: Container(
          color: const Color(0xFFE6F0FA), // light background
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF5C3FCA), // header color
                ),
                accountName: const Text("Komal Modi"),
                accountEmail: const Text("admin@altreyatech.com"),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/profile.png"),
                ),
              ),

              // Menu items with Navigator.push
              _buildMenuItem(context, Icons.home, "Home", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              }),
              _buildMenuItem(context, Icons.person, "Profile", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              }),
              _buildMenuItem(context, Icons.group, "Circle", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CirclePage()),
                );
              }),
              _buildMenuItem(context, Icons.event, "Events", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EventsPage()),
                );
              }),
              _buildMenuItem(context, Icons.work, "Jobs", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JobPage()),
                );
              }),

              // ✅ New Organization menu item
              _buildMenuItem(context, Icons.business, "Organization", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrganizationPage()),
                );
              }),

              // ✅ Memories menu item
              _buildMenuItem(context, Icons.photo_album, "Memories", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MemoryPage()),
                );
              }),

              const Spacer(),

              _buildMenuItem(context, Icons.logout, "Logout", () {
                Navigator.pop(context);
                // Add logout logic here
              }),
            ],
          ),
        ),
      ),

      // ✅ Body with Search bar + Message icon
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  Flexible(
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
            Expanded(child: body),
          ],
        ),
      ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabSelected,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF5C3FCA),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: ""),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: "",
          ), // 👈 Memories icon
        ],
      ),
    );
  }

  // Helper method for menu items
  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // close drawer
        onTap();
      },
    );
  }
}
