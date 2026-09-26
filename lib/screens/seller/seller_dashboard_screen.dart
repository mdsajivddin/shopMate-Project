import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/dummy_data.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final currentPersona = AppState.instance.currentVendorPersona ?? DummyData.vendorPersonas[0];
        final permittedNavItems = _getPermittedNavItems(currentPersona);

        if (_currentNavIndex >= permittedNavItems.length) {
          _currentNavIndex = 0;
        }

        final activeNavItem = permittedNavItems[_currentNavIndex];

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: _buildTopAppBar(currentPersona),
          body: Column(
            children: [
              // 1. Role switcher notice & Persona info bar
              _buildRoleBanner(currentPersona),

              // 2. Horizontal Scrollable Navigation Tabs
              _buildHorizontalTabBar(permittedNavItems),

              // 3. Tab Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 30.h),
                  child: _buildActiveTabContent(activeNavItem.id),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildTopAppBar(VendorPersona persona) {
    return AppBar(
      backgroundColor: const Color(0xFF0F172A), // Dark slate
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16.w,
      title: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF43F5E), Color(0xFFEC4899)],
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Icon(
                LucideIcons.store,
                color: Colors.white,
                size: 17.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Urban Threads',
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.5),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        'LIVE POS',
                        style: GoogleFonts.outfit(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF34D399),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Sector 29, Galleria • Flagship Partner',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // "← Customer Store" button to easily return
        Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              LucideIcons.arrowLeft,
              size: 13.sp,
              color: const Color(0xFF38BDF8),
            ),
            label: Text(
              'Storefront',
              style: GoogleFonts.outfit(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF38BDF8),
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999.r),
                side: BorderSide(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
        ),
        // Sign Out button
        Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: IconButton(
            icon: const Icon(LucideIcons.logOut, color: Color(0xFFFB7185), size: 17),
            tooltip: 'Sign Out from Portal',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              AppState.instance.logoutVendor();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(LucideIcons.checkCircle2, color: Color(0xFF34D399), size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Logged out from Vendor Portal',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFF0F172A),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  duration: const Duration(milliseconds: 2000),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoleBanner(VendorPersona persona) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14.r,
            backgroundImage: NetworkImage(persona.avatar),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      persona.name,
                      style: GoogleFonts.outfit(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: persona.badgeBg,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        persona.role,
                        style: GoogleFonts.outfit(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w800,
                          color: persona.badgeTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${persona.permissions.length} Modules Permitted • ${persona.email}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.5.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),

          // Switch Persona Button
          GestureDetector(
            onTap: () => _showPersonaSwitcherDialog(persona),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.users,
                    size: 12.sp,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Switch Role',
                    style: GoogleFonts.outfit(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPersonaSwitcherDialog(VendorPersona current) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Switch Demo Persona (Role-Based Access)',
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Select an employee to instantly test their allowed tabs and permissions:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5.sp,
                  color: const Color(0xFF64748B),
                ),
              ),
              SizedBox(height: 14.h),
              ...DummyData.vendorPersonas.map((persona) {
                final isSelected = persona.id == current.id;
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(persona.avatar),
                    ),
                    title: Text(
                      persona.name,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.sp,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    subtitle: Text(
                      persona.subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.sp,
                        color: persona.badgeTextColor,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(LucideIcons.check, color: Color(0xFF3B82F6))
                        : null,
                    onTap: () {
                      AppState.instance.loginAsVendorPersona(persona);
                      setState(() => _currentNavIndex = 0);
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHorizontalTabBar(List<_NavItem> items) {
    return Container(
      height: 46.h,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = _currentNavIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () {
                setState(() => _currentNavIndex = index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE11D48) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 13.sp,
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      item.label,
                      style: GoogleFonts.outfit(
                        fontSize: 11.5.sp,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveTabContent(String tabId) {
    switch (tabId) {
      case 'dashboard':
        return _buildDashboardOverview();
      case 'orders':
        return _buildOrdersManagement();
      case 'pos':
        return _buildPosBilling();
      case 'attendance':
        return _buildAttendanceTracker();
      case 'products':
      case 'add-product':
        return _buildCatalogView();
      case 'shop':
        return _buildShopProfile();
      case 'analytics':
        return _buildAnalyticsView();
      default:
        return _buildDashboardOverview();
    }
  }

  // --- TAB 1: DASHBOARD OVERVIEW ---
  Widget _buildDashboardOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top 4 Metric Cards
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Total Gross Sales',
                value: '₹1,72,500',
                delta: '+18.4% this month',
                isPositive: true,
                icon: LucideIcons.indianRupee,
                iconColor: const Color(0xFFE11D48),
                bgColor: const Color(0xFFFDF2F8),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildMetricCard(
                title: 'Total Orders',
                value: '82 Orders',
                delta: '64 delivered, 18 live',
                isPositive: true,
                icon: LucideIcons.shoppingBag,
                iconColor: const Color(0xFF8B5CF6),
                bgColor: const Color(0xFFF5F3FF),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'POS Counter Sales',
                value: '₹94,875',
                delta: '55% of all revenue',
                isPositive: true,
                icon: LucideIcons.creditCard,
                iconColor: const Color(0xFF06B6D4),
                bgColor: const Color(0xFFECFEFF),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildMetricCard(
                title: 'Average Basket (AOV)',
                value: '₹2,103',
                delta: 'High basket size',
                isPositive: true,
                icon: LucideIcons.trendingUp,
                iconColor: const Color(0xFFF59E0B),
                bgColor: const Color(0xFFFFFBEB),
              ),
            ),
          ],
        ),

        SizedBox(height: 18.h),

        // Omnichannel Channel Split Card
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Omnichannel Sales Channel Split',
                    style: GoogleFonts.outfit(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      'Live Sync',
                      style: GoogleFonts.outfit(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF166534),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(999.r),
                child: SizedBox(
                  height: 10.h,
                  child: Row(
                    children: [
                      Expanded(flex: 55, child: Container(color: const Color(0xFFE11D48))),
                      Expanded(flex: 33, child: Container(color: const Color(0xFF8B5CF6))),
                      Expanded(flex: 12, child: Container(color: const Color(0xFF06B6D4))),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLegendItem('Counter POS (55%)', const Color(0xFFE11D48)),
                  _buildLegendItem('Web Store (33%)', const Color(0xFF8B5CF6)),
                  _buildLegendItem('QR Scan (12%)', const Color(0xFF06B6D4)),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 18.h),

        // Recent Orders Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Dispatch & Counter Orders',
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              'View All',
              style: GoogleFonts.outfit(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFE11D48),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // Recent orders list
        ...DummyData.vendorOrders.map((order) => _buildOrderTile(order)),
      ],
    );
  }

  // --- TAB 2: ORDERS MANAGEMENT ---
  Widget _buildOrdersManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fulfillment & Dispatch Counter (${DummyData.vendorOrders.length} Orders)',
          style: GoogleFonts.outfit(
            fontSize: 14.5.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Update status for delivery executives or print instant GST tax invoices.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.sp,
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(height: 14.h),
        ...DummyData.vendorOrders.map((order) => _buildOrderTile(order, showAction: true)),
      ],
    );
  }

  // --- TAB 3: POS BILLING ---
  Widget _buildPosBilling() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Walk-in Counter POS Terminal',
                    style: GoogleFonts.outfit(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Active Cart: Aarav Sharma (Walk-in)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Text(
                  'CART #101',
                  style: GoogleFonts.outfit(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF065F46),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _buildPosItemTile('ShopMate Heavyweight Hoodie', 'Size: L • Onyx Black', 1999, 1),
          SizedBox(height: 8.h),
          _buildPosItemTile('AeroGlide Pro Court Sneakers', 'Size: UK 8 • Crimson', 4299, 1),
          SizedBox(height: 14.h),
          const Divider(color: Color(0xFFE2E8F0)),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payable (incl. GST 12%):',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
              Text(
                '₹7,054',
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFE11D48),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Split Payment Dialog: Cash ₹3,527 + Online UPI ₹3,527')),
                    );
                  },
                  icon: Icon(LucideIcons.split, size: 14.sp),
                  label: const Text('Split 50/50'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('POS Order Billed Successfully! Bill #ORD-POS-9051')),
                    );
                  },
                  icon: Icon(LucideIcons.check, size: 14.sp),
                  label: const Text('Complete Bill'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE11D48),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 4: ATTENDANCE TRACKER ---
  Widget _buildAttendanceTracker() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.clock,
                    color: const Color(0xFF166534),
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Store Staff QR Attendance',
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Real-time punch register with device fingerprint & timestamps',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.sp,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _buildAttendanceRow('Rahul Verma', 'Cashier Staff', '09:14 AM', 'iPhone 15 Pro', true),
          SizedBox(height: 8.h),
          _buildAttendanceRow('Sneha Kapoor', 'Inventory Staff', '09:28 AM', 'Galaxy S24 Ultra', true),
          SizedBox(height: 8.h),
          _buildAttendanceRow('Amit Patel', 'Floor Sales', '01:30 PM', 'OnePlus 12 5G', false),
        ],
      ),
    );
  }

  // --- TAB 5: CATALOG & INVENTORY ---
  Widget _buildCatalogView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Store Merchandise Catalog (${DummyData.products.length})',
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE11D48),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.plus, size: 11.sp, color: Colors.white),
                  SizedBox(width: 4.w),
                  Text(
                    'Add Product',
                    style: GoogleFonts.outfit(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...DummyData.products.take(6).map((product) => _buildCatalogItem(product)),
      ],
    );
  }

  // --- TAB 6: SHOP PROFILE ---
  Widget _buildShopProfile() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Merchant Store Identity',
            style: GoogleFonts.outfit(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 12.h),
          _buildProfileField('Business Legal Name', 'Urban Threads & Footwear Studio'),
          _buildProfileField('Store Address', 'Shop 14, Ground Floor, Galleria Promenade, Sector 29'),
          _buildProfileField('GSTIN Registration', '07AAAAA0000A1Z5 (12% Standard)'),
          _buildProfileField('Merchant UPI VPA', 'urbanthreads@icici (Instant POS QR)'),
          _buildProfileField('Operating Hours', '10:00 AM - 09:30 PM (Everyday)'),
        ],
      ),
    );
  }

  // --- TAB 7: ANALYTICS ---
  Widget _buildAnalyticsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance & Revenue Analytics',
          style: GoogleFonts.outfit(
            fontSize: 14.5.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monthly Revenue Trajectory (Jan - Mar 2026)',
                style: GoogleFonts.outfit(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildChartBar('Oct', 64, false),
                  _buildChartBar('Nov', 92, false),
                  _buildChartBar('Dec', 145, false),
                  _buildChartBar('Jan', 118, false),
                  _buildChartBar('Feb', 135, false),
                  _buildChartBar('Mar', 172, true),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartBar(String month, double amount, bool isCurrent) {
    final height = (amount / 180) * 120.h;
    return Column(
      children: [
        Text(
          '₹${amount.toInt()}k',
          style: GoogleFonts.outfit(
            fontSize: 9.sp,
            fontWeight: FontWeight.w700,
            color: isCurrent ? const Color(0xFFE11D48) : const Color(0xFF94A3B8),
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 28.w,
          height: height,
          decoration: BoxDecoration(
            color: isCurrent ? const Color(0xFFE11D48) : const Color(0xFFCBD5E1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(6.r)),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          month,
          style: GoogleFonts.outfit(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String delta,
    required bool isPositive,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(icon, size: 13.sp, color: iconColor),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            delta,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderTile(VendorOrder order, {bool showAction = false}) {
    Color statusColor;
    Color statusBg;
    if (order.status == 'Delivered') {
      statusColor = const Color(0xFF047857);
      statusBg = const Color(0xFFD1FAE5);
    } else if (order.status == 'Shipped') {
      statusColor = const Color(0xFF0369A1);
      statusBg = const Color(0xFFE0F2FE);
    } else if (order.status == 'Ready for Pickup') {
      statusColor = const Color(0xFF7C3AED);
      statusBg = const Color(0xFFEDE9FE);
    } else {
      statusColor = const Color(0xFFB45309);
      statusBg = const Color(0xFFFEF3C7);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Icon(
                order.channel.contains('POS') ? LucideIcons.creditCard : LucideIcons.globe,
                size: 16.sp,
                color: const Color(0xFF475569),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      order.orderId,
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        order.status,
                        style: GoogleFonts.outfit(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  '${order.customerName} • ${order.items.first}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5.sp,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${order.totalAmount.toInt()}',
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                order.time,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9.sp,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPosItemTile(String name, String variant, int price, int qty) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  variant,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$qty × ₹$price',
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRow(String name, String role, String time, String device, bool isClockedIn) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: isClockedIn ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  '$role • via $device',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.5.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.outfit(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogItem(Product product) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              product.image,
              width: 44.w,
              height: 44.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'SKU: ${product.qrCode} • In Stock: 18 units',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${product.price.toInt()}',
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  List<_NavItem> _getPermittedNavItems(VendorPersona persona) {
    final allItems = [
      const _NavItem('dashboard', 'Overview', LucideIcons.layoutDashboard),
      const _NavItem('orders', 'Orders', LucideIcons.shoppingBag),
      const _NavItem('pos', 'Counter POS', LucideIcons.creditCard),
      const _NavItem('attendance', 'Attendance', LucideIcons.clock),
      const _NavItem('products', 'Inventory', LucideIcons.boxes),
      const _NavItem('shop', 'Shop Profile', LucideIcons.store),
      const _NavItem('analytics', 'Analytics', LucideIcons.trendingUp),
    ];

    return allItems.where((item) => persona.hasPermission(item.id)).toList();
  }
}

class _NavItem {
  final String id;
  final String label;
  final IconData icon;

  const _NavItem(this.id, this.label, this.icon);
}
