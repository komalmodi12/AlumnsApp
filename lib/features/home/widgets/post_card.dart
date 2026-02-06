import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/alu1.png', height: 35.h, width: 35.w),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "ALUMNS",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "2d ago",
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.public,
                          size: 14.sp,
                          color: Colors.grey.shade700,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "Shared With Public",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            "🚀 Unlock the Full Power of Your Alumni Network!",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            "Complete your profile and let your batchmates, college peers, and professional connections find you instantly. Add your education & professional details to discover alumni matches with shared roots.",
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                'assets/images/alu1.png',
                fit: BoxFit.scaleDown,
                width: double.infinity,
                height: 200.h,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Divider(thickness: 2, color: Colors.grey.shade300),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _interactionItem(Icons.emoji_emotions_outlined, "React"),
              _interactionItem(Icons.chat_bubble_outline, "Comment"),
              _interactionItem(Icons.repeat, "Repost"),
              _interactionItem(Icons.share_outlined, "Share"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _interactionItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade700),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 9.sp, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
