import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../core/dummy_data.dart';
import '../checkout/track_order_screen.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Creating some dummy orders from dummy products
    final dummyOrders = [
      {'status': 'Delivered', 'date': '12 Aug 2026', 'product': DummyData.products[0]},
      {'status': 'Processing', 'date': '15 Aug 2026', 'product': DummyData.products[2]},
      {'status': 'Cancelled', 'date': '01 Aug 2026', 'product': DummyData.products[4]},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: dummyOrders.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final order = dummyOrders[index];
          final product = order['product'] as Product;
          final status = order['status'] as String;
          final date = order['date'] as String;

          Color statusColor;
          if (status == 'Delivered') {
            statusColor = AppTheme.primaryColor;
          } else if (status == 'Processing') {
            statusColor = Colors.orange;
          } else {
            statusColor = AppTheme.errorColor;
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrackOrderScreen(
                    orderId: '#ORD${1000 + index}',
                    product: product,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order ID: #ORD${1000 + index}', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    Text(date, style: TextStyle(fontSize: 12.sp, color: AppTheme.textSecondary)),
                  ],
                ),
                Divider(height: 24.h, color: Colors.grey.shade200),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        product.images.first,
                        width: 60.w,
                        height: 60.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4.h),
                          Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Icon(LucideIcons.truck, size: 16.sp, color: statusColor),
                    SizedBox(width: 8.w),
                    Text(
                      status,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primaryColor),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text('Details', style: TextStyle(color: AppTheme.primaryColor, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        },
      ),
    );
  }
}
