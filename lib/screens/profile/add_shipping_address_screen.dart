import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddShippingAddressScreen extends StatelessWidget {
  const AddShippingAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            const CustomTextField(
              hintText: 'Address Title (e.g., Home, Office)',
              prefixIcon: LucideIcons.tag,
            ),
            SizedBox(height: 16.h),
            const CustomTextField(
              hintText: 'Full Name',
              prefixIcon: LucideIcons.user,
            ),
            SizedBox(height: 16.h),
            const CustomTextField(
              hintText: 'Phone Number',
              keyboardType: TextInputType.phone,
              prefixIcon: LucideIcons.phone,
            ),
            SizedBox(height: 16.h),
            const CustomTextField(
              hintText: 'Street Address',
              prefixIcon: LucideIcons.mapPin,
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                const Expanded(child: CustomTextField(hintText: 'City')),
                SizedBox(width: 16.w),
                const Expanded(child: CustomTextField(hintText: 'Zip Code', keyboardType: TextInputType.number)),
              ],
            ),
            SizedBox(height: 16.h),
            const CustomTextField(hintText: 'Country'),
            SizedBox(height: 24.h),
            Row(
              children: [
                Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: AppTheme.primaryColor,
                ),
                SizedBox(width: 8.w),
                Text('Set as default address', style: TextStyle(fontSize: 14.sp)),
              ],
            ),
            SizedBox(height: 32.h),
            CustomButton(
              text: 'Save Address',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Address added successfully!'),
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
