import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Order Delivered',
        'body': 'Your order #ORD1000 has been successfully delivered.',
        'time': '2h ago',
        'icon': LucideIcons.packageCheck,
        'color': AppTheme.primaryColor,
      },
      {
        'title': 'Special Offer!',
        'body': 'Get 20% off on all premium electronics today.',
        'time': '1d ago',
        'icon': LucideIcons.tag,
        'color': Colors.orange,
      },
      {
        'title': 'Payment Failed',
        'body':
            'We couldn\'t process your payment for #ORD1002. Please try again.',
        'time': '3d ago',
        'icon': LucideIcons.alertCircle,
        'color': AppTheme.errorColor,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), centerTitle: true),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: notifications.length,
        separatorBuilder: (context, index) =>
            Divider(height: 32.h, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: item['color'] as Color,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['title'] as String,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item['time'] as String,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      item['body'] as String,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
