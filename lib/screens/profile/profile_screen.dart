import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../core/dummy_data.dart';
import 'customer_auth_modal.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onBrowseProducts;

  const ProfileScreen({super.key, this.onBrowseProducts});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final customer = AppState.instance.currentCustomer;
        final orders = AppState.instance.customerOrders;
        final isLoggedIn = AppState.instance.isCustomerLoggedIn;

        return Scaffold(
          backgroundColor: const Color(0xFFFAF8F5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Account',
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF171717),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: const Color(0xFFE2E8F0), height: 1),
            ),
            actions: [
              if (isLoggedIn)
                TextButton.icon(
                  onPressed: () {
                    AppState.instance.logoutCustomer();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Signed out successfully',
                          style: GoogleFonts.plusJakartaSans(fontSize: 12.sp),
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: Icon(
                    LucideIcons.logOut,
                    size: 14.sp,
                    color: const Color(0xFF64748B),
                  ),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                )
              else
                TextButton.icon(
                  onPressed: () => CustomerAuthModal.show(context),
                  icon: Icon(
                    LucideIcons.user,
                    size: 14.sp,
                    color: AppTheme.primaryColor,
                  ),
                  label: Text(
                    'Sign In',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              SizedBox(width: 8.w),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. PROFILE INFO CARD (Web App 1:1 Replica)
                _buildProfileCard(context, customer, isLoggedIn),

                SizedBox(height: 24.h),

                // 2. ORDER HISTORY & RECEIPTS (Web App 1:1 Replica)
                _buildOrderHistorySection(context, orders),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    CustomerProfile? customer,
    bool isLoggedIn,
  ) {
    if (!isLoggedIn || customer == null) {
      // Guest Shopper Card
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  LucideIcons.user,
                  size: 32.sp,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Guest Shopper',
              style: GoogleFonts.outfit(
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF171717),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Sign in to access your orders and saved wishlist',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.sp,
                color: const Color(0xFF64748B),
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: () => CustomerAuthModal.show(context),
              icon: const Icon(LucideIcons.logIn, size: 15),
              label: Text(
                'Sign In / Register',
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Logged-in Vicky Sharma Card
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryLight, width: 4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999.r),
                  child: Image.network(
                    customer.avatar,
                    width: 62.w,
                    height: 62.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 62.w,
                      height: 62.w,
                      color: const Color(0xFFF1F5F9),
                      child: const Icon(
                        LucideIcons.user,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Name, Email, Verified Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: GoogleFonts.outfit(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF171717),
                        letterSpacing: -0.4,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      customer.email,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // "Verified Shopper" Badge matching web app
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(999.r),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.badgeCheck,
                            size: 13.sp,
                            color: const Color(0xFF047857),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            customer.badge,
                            style: GoogleFonts.outfit(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF047857),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Switch / Manage Account Button
          InkWell(
            onTap: () => CustomerAuthModal.show(context),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.userCog,
                        size: 15.sp,
                        color: const Color(0xFF475569),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Switch Account / Demo Sign In',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    LucideIcons.chevronRight,
                    size: 15.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHistorySection(
    BuildContext context,
    List<CustomerOrder> orders,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title matching Web App: "Order History & Receipts"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order History & Receipts',
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF171717),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                '${orders.length} ${orders.length == 1 ? 'Order' : 'Orders'}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // If Empty State
        if (orders.isEmpty)
          Container(
            padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.packageOpen,
                    size: 40.sp,
                    color: const Color(0xFFCBD5E1),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'No orders placed yet.',
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Your receipt & trackings will appear here after checkout.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          // Orders List matching Web App Receipt Card 1:1
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (_, __) => SizedBox(height: 14.h),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildReceiptCard(order);
            },
          ),
      ],
    );
  }

  Widget _buildReceiptCard(CustomerOrder order) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Order ID & Date + Total Amount & Payment Method
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.orderId,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Date: ${order.date}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${order.totalAmount.toStringAsFixed(0)}',
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF4A5D4E),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    order.paymentMethod,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12.h),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          SizedBox(height: 12.h),

          // 2. Items List
          Column(
            children: order.items.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    // Product Thumbnail in #F4F0EB squircle
                    Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F0EB),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          item.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            LucideIcons.package,
                            size: 16,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),

                    // Name × Quantity
                    Expanded(
                      child: Text(
                        '${item.name} × ${item.quantity}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Price
                    Text(
                      '₹${(item.price * item.quantity).toStringAsFixed(0)}',
                      style: GoogleFonts.outfit(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 6.h),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          SizedBox(height: 10.h),

          // 3. Footer: Status + Deliver to
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Status: ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    order.status,
                    style: GoogleFonts.outfit(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    LucideIcons.mapPin,
                    size: 11.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Deliver to: ${order.city}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.sp,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
