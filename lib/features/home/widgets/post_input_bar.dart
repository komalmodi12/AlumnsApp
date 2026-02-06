import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostInputBar extends StatelessWidget {
  const PostInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 First Row: Avatar + TextField + Post Button
          Row(
            children: [
              CircleAvatar(
                backgroundImage: const AssetImage('assets/images/alu1.png'),
                radius: 20.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: TextField(
                  minLines: 1,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Start a post",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 3.h,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              ElevatedButton(
                onPressed: () {
                  // handle post action
                },
                child: const Text("Post"),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // 🔹 Second Row: Write Article option
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Container(
                      height: 400.h,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: TextField(
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Start writing your article...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.edit, color: Colors.purple),
                SizedBox(width: 6.w),
                Text("Write an article"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
