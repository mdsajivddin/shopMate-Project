import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddPaymentMethodScreen extends StatelessWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment Method'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            // Dummy Card Preview
            Container(
              height: 200.h,
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, Color(0xFF00332B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(LucideIcons.creditCard, color: Colors.white, size: 32.sp),
                      Text('VISA', style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                    ],
                  ),
                  Text(
                    '**** **** **** ****',
                    style: TextStyle(color: Colors.white, fontSize: 22.sp, letterSpacing: 4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Card Holder', style: TextStyle(color: Colors.white70, fontSize: 10.sp)),
                          Text('YOUR NAME', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Expires', style: TextStyle(color: Colors.white70, fontSize: 10.sp)),
                          Text('MM/YY', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            
            // Form
            const CustomTextField(
              hintText: 'Cardholder Name',
              prefixIcon: LucideIcons.user,
            ),
            SizedBox(height: 16.h),
            const CustomTextField(
              hintText: 'Card Number',
              keyboardType: TextInputType.number,
              prefixIcon: LucideIcons.creditCard,
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                const Expanded(child: CustomTextField(hintText: 'Expiry Date (MM/YY)')),
                SizedBox(width: 16.w),
                const Expanded(child: CustomTextField(hintText: 'CVV', keyboardType: TextInputType.number, isPassword: true)),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: AppTheme.primaryColor,
                ),
                SizedBox(width: 8.w),
                Text('Set as default payment method', style: TextStyle(fontSize: 14.sp)),
              ],
            ),
            SizedBox(height: 32.h),
            CustomButton(
              text: 'Save Card',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Payment method added successfully!'),
                    backgroundColor: AppTheme.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                );
                Future.delayed(const Duration(seconds: 1), () {
                  if (context.mounted) Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
