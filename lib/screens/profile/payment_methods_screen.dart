import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import 'add_payment_method_screen.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentMethods = [
      {
        'type': 'Credit Card',
        'cardNumber': '**** **** **** 1234',
        'expiry': '12/28',
        'isDefault': true,
        'icon': LucideIcons.creditCard,
      },
      {
        'type': 'Apple Pay',
        'cardNumber': 'apple_pay_linked',
        'expiry': '',
        'isDefault': false,
        'icon': LucideIcons.smartphone,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: paymentMethods.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final item = paymentMethods[index];
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: item['isDefault'] == true ? AppTheme.primaryColor : Colors.grey.shade200,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: item['isDefault'] == true ? AppTheme.primaryColor.withOpacity(0.1) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['isDefault'] == true ? AppTheme.primaryColor : AppTheme.textSecondary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item['type'] as String,
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
                      SizedBox(height: 4.h),
                      Text(
                        item['cardNumber'] as String == 'apple_pay_linked' ? 'Linked Account' : item['cardNumber'] as String,
                        style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPaymentMethodScreen()));
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }
}
