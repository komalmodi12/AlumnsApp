import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alumns_app/features/home/widgets/app_layout.dart';
import 'package:alumns_app/features/home/recommended_page.dart';
import 'package:alumns_app/core/api/api_helper.dart';
import 'package:alumns_app/features/auth/models/api_models.dart';
import 'widgets/post_input_bar.dart';
import 'widgets/post_card.dart';
import '../home/widgets/animated_carousel_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  User? _currentUser;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    context.trackPageView('home');
  }

  Future<void> _loadUserData() async {
    try {
      final user = await ApiHelper.getUserProfile(context: context);
      if (mounted) {
        setState(() {
          _currentUser = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load profile';
          _isLoading = false;
        });
      }
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _onRefresh() async {
    await _loadUserData();
    setState(() {
      _currentIndex = 0; // reset to home tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentIndex: _currentIndex,
      onTabSelected: _onTabSelected,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadUserData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Top profile card with dynamic data
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDACEF2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 36.r,
                              backgroundImage: _currentUser?.avatar != null
                                  ? NetworkImage(_currentUser!.avatar!)
                                  : const AssetImage('assets/images/alu1.png')
                                        as ImageProvider,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _currentUser?.name ?? "User",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _currentUser?.bio ?? "Add Intro Line",
                                    style: TextStyle(
                                      fontSize: 12.sp,
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
                  ),

                  // Recommended section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recommended",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RecommendedPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Show All",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF5C3FCA),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Carousel
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: AnimatedCarouselList(itemCount: 10),
                    ),
                  ),

                  // Sticky + Floating PostInputBar
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true, // 👈 allows it to float in/out
                    delegate: _StickyHeaderDelegate(
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        child: const PostInputBar(),
                      ),
                    ),
                  ),

                  // Gap before posts
                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // Post feed
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const PostCard(),
                      childCount: 10,
                    ),
                  ),

                  // Bottom spacing
                  SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                ],
              ),
      ),
    );
  }
}

/// Sticky header delegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 110.h; // enough space for PostInputBar + padding
  @override
  double get minExtent => 110.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
