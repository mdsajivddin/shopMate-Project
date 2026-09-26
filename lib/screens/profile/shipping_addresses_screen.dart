import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import 'add_shipping_address_screen.dart';

class ShippingAddressesScreen extends StatelessWidget {
  const ShippingAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addresses = [
      {'title': 'Home', 'address': '123 Main Street, Apt 4B, New York, NY 10001, USA', 'isDefault': true},
      {'title': 'Office', 'address': '456 Business Blvd, Suite 200, San Francisco, CA 94107, USA', 'isDefault': false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Addresses'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: addresses.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final item = addresses[index];
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: item['isDefault'] == true ? AppTheme.primaryColor : Colors.grey.shade200, width: 1.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  item['title'] == 'Home' ? LucideIcons.home : LucideIcons.building,
                  color: item['isDefault'] == true ? AppTheme.primaryColor : AppTheme.textSecondary,
                  size: 24.sp,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item['title'] as String,
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                          if (item['isDefault'] == true) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text('Default', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        item['address'] as String,
                        style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary, height: 1.5),
                      ),
                    ],
                  ),
                ),
                Icon(LucideIcons.moreVertical, size: 20.sp, color: AppTheme.textSecondary),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddShippingAddressScreen()));
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }
}
