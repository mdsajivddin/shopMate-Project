import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../core/dummy_data.dart';
import '../../widgets/custom_button.dart';
import '../main_wrapper.dart';
import '../profile/help_support_screen.dart';

class TrackOrderScreen extends StatefulWidget {
  final String orderId;
  final Product? product;

  const TrackOrderScreen({
    super.key,
    this.orderId = '#ORD-98234',
    this.product,
  });

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 4.0, end: 12.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayProduct = widget.product ?? DummyData.products.first;

    final List<Map<String, dynamic>> timeline = [
      {
        'title': 'Order Placed',
        'subtitle': 'Your order has been received.',
        'date': '18 Aug 2026, 10:30 PM',
        'isCompleted': true,
        'isCurrent': false,
        'icon': LucideIcons.shoppingBag,
      },
      {
        'title': 'Order Confirmed',
        'subtitle': 'Seller has confirmed your order.',
        'date': '19 Aug 2026, 09:15 AM',
        'isCompleted': true,
        'isCurrent': false,
        'icon': LucideIcons.checkCircle2,
      },
      {
        'title': 'Shipped',
        'subtitle': 'Package left logistics facility (FedEx - #FX-849204).',
        'date': '19 Aug 2026, 04:45 PM',
        'isCompleted': true,
        'isCurrent': false,
        'icon': LucideIcons.packageCheck,
      },
      {
        'title': 'Out for Delivery',
        'subtitle': 'Courier agent is on the way to your destination.',
        'date': 'Expected Today by 05:00 PM',
        'isCompleted': false,
        'isCurrent': true,
        'icon': LucideIcons.truck,
      },
      {
        'title': 'Delivered',
        'subtitle': 'Package will be delivered to your address.',
        'date': 'Pending',
        'isCompleted': false,
        'isCurrent': false,
        'icon': LucideIcons.home,
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Track Order'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.headphones),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Header Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            widget.orderId,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'In Transit',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24.h, color: Colors.grey.shade200),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.calendar,
                        size: 18.sp,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Estimated Delivery: ',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        '22 Aug 2026',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Item Details Card
            Text(
              'Item Details',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      displayProduct.images.first,
                      width: 60.w,
                      height: 60.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayProduct.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Qty: 1  |  Color: Default',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '\$${displayProduct.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Order Tracking Status Timeline Card
            Text(
              'Order Status',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: timeline.length,
                itemBuilder: (context, index) {
                  final step = timeline[index];
                  final isLast = index == timeline.length - 1;
                  final isCompleted = step['isCompleted'] as bool;
                  final isCurrent = step['isCurrent'] as bool;

                  Color circleColor;
                  Color iconColor;
                  if (isCompleted) {
                    circleColor = AppTheme.primaryColor;
                    iconColor = Colors.white;
                  } else if (isCurrent) {
                    circleColor = Colors.orange;
                    iconColor = Colors.white;
                  } else {
                    circleColor = Colors.grey.shade200;
                    iconColor = Colors.grey.shade500;
                  }

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Dot & Line
                        Column(
                          children: [
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Container(
                                  width: 36.w,
                                  height: 36.w,
                                  decoration: BoxDecoration(
                                    color: circleColor,
                                    shape: BoxShape.circle,
                                    boxShadow: isCurrent
                                        ? [
                                            BoxShadow(
                                              color: Colors.orange.withOpacity(0.45),
                                              blurRadius: _pulseAnimation.value,
                                              spreadRadius: _pulseAnimation.value / 3,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: child,
                                );
                              },
                              child: Icon(
                                step['icon'] as IconData,
                                color: iconColor,
                                size: 18.sp,
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2.w,
                                  color: isCompleted
                                      ? AppTheme.primaryColor
                                      : Colors.grey.shade300,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(width: 14.w),

                        // Right Column: Title, Subtitle, Date
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      step['title'] as String,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: (isCompleted || isCurrent)
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        color: (isCompleted || isCurrent)
                                            ? AppTheme.textPrimary
                                            : AppTheme.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      step['date'] as String,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: isCurrent
                                            ? Colors.orange.shade800
                                            : AppTheme.textSecondary,
                                        fontWeight: isCurrent
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  step['subtitle'] as String,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppTheme.textSecondary,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20.h),

            // Courier Agent Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child: Icon(
                      LucideIcons.user,
                      color: AppTheme.primaryColor,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Agent',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          'Alex Morgan',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Calling delivery agent...'),
                        ),
                      );
                    },
                    icon: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.phone,
                        color: AppTheme.primaryColor,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Back to Home Button
            CustomButton(
              text: 'Back to Home',
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainWrapper()),
                  (route) => false,
                );
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
