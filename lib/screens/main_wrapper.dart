import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/theme.dart';
import '../core/dummy_data.dart';
import 'home/home_screen.dart';
import 'home/all_products_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';
import 'scanner/qr_scanner_screen.dart';

class MainWrapper extends StatefulWidget {
  final int initialIndex;
  const MainWrapper({super.key, this.initialIndex = 0});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    if (index == 2) {
      // Open in-store QR scanner directly
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QrScannerScreen()),
      );
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigateTab: _onTabSelected),
      const AllProductsScreen(title: 'All Products'),
      const SizedBox.shrink(), // Center button placeholder
      const CartScreen(),
      const ProfileScreen(),
    ];

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final cartCount = AppState.instance.cartCount;

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.98),
              border: Border(
                top: BorderSide(
                  color: AppTheme.borderColor.withValues(alpha: 0.9),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabSelected,
              backgroundColor: Colors.white,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor: const Color(0xFFA1A1AA),
              selectedLabelStyle: GoogleFonts.outfit(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
              ),
              unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
              ),
              items: [
                // 1. Home
                const BottomNavigationBarItem(
                  icon: Icon(LucideIcons.home),
                  activeIcon: Icon(LucideIcons.home, color: AppTheme.primaryColor),
                  label: 'Home',
                ),

                // 2. Products
                const BottomNavigationBarItem(
                  icon: Icon(LucideIcons.layoutGrid),
                  activeIcon: Icon(LucideIcons.layoutGrid, color: AppTheme.primaryColor),
                  label: 'Products',
                ),

                // 3. Scan QR (Elevated Center Button)
                BottomNavigationBarItem(
                  icon: Container(
                    width: 44.w,
                    height: 44.w,
                    margin: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.qrCode,
                        size: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  label: 'Scan QR',
                ),

                // 4. Cart with Live Badge
                BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(LucideIcons.shoppingBag),
                      if (cartCount > 0)
                        Positioned(
                          right: -8.w,
                          top: -4.h,
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.h),
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$cartCount',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  activeIcon: const Icon(LucideIcons.shoppingBag, color: AppTheme.primaryColor),
                  label: 'Cart',
                ),

                // 5. Profile / Account (Web App 1:1)
                BottomNavigationBarItem(
                  icon: const Icon(LucideIcons.user),
                  activeIcon: const Icon(LucideIcons.user, color: AppTheme.primaryColor),
                  label: AppState.instance.isCustomerLoggedIn
                      ? (AppState.instance.currentCustomer?.name.split(' ').first ?? 'Account')
                      : 'Account',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
