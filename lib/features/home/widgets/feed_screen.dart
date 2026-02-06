import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'post_input_bar.dart';
import 'post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("Alumni Feed")),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        itemCount: 10 + 1, // 10 posts + 1 input bar
        itemBuilder: (context, index) {
          if (index == 0) {
            return const PostInputBar(); // Composer at top
          } else {
            return const PostCard(); // Posts below
          }
        },
      ),
    );
  }
}
