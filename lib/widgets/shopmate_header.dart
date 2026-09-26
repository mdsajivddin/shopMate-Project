import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/theme.dart';
import '../core/dummy_data.dart';
import '../screens/home/location_screen.dart';
import '../screens/scanner/qr_scanner_screen.dart';
import '../screens/wishlist/wishlist_screen.dart';
import '../screens/seller/seller_login_modal.dart';
import '../screens/seller/seller_dashboard_screen.dart';
import '../screens/home/all_products_screen.dart';

class ShopMateHeader extends StatefulWidget {
  final VoidCallback? onCartTap;
  final VoidCallback? onWishlistTap;
  final ValueChanged<String>? onSearchSubmitted;
  final ValueChanged<String>? onSearchChanged;

  const ShopMateHeader({
    super.key,
    this.onCartTap,
    this.onWishlistTap,
    this.onSearchSubmitted,
    this.onSearchChanged,
  });

  @override
  State<ShopMateHeader> createState() => _ShopMateHeaderState();
}

class _ShopMateHeaderState extends State<ShopMateHeader> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: AppState.instance.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final wishlistCount = AppState.instance.wishlistCount;
        final isVendor = AppState.instance.isVendorLoggedIn;
        final currentPersona = AppState.instance.currentVendorPersona;

        // Keep search controller in sync if cleared externally
        if (_searchController.text != AppState.instance.searchQuery) {
          _searchController.value = _searchController.value.copyWith(
            text: AppState.instance.searchQuery,
            selection: TextSelection.collapsed(offset: AppState.instance.searchQuery.length),
          );
        }

        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF8F5).withValues(alpha: 0.98),
            border: Border(
              bottom: BorderSide(
                color: AppTheme.borderColor.withValues(alpha: 0.8),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. TOP ACTIONS ROW: Logo + Location + QR + Wishlist + Become a Seller
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Brand Logo ("ShopMate" with squircle icon)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A5D4E),
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF4A5D4E,
                                ).withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              LucideIcons.shoppingBag,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.outfit(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.6,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Shop',
                                style: TextStyle(color: Color(0xFF171717)),
                              ),
                              TextSpan(
                                text: 'Mate',
                                style: TextStyle(color: Color(0xFF4A5D4E)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),

                    // Location Selector Pill ("● 📍 Downtown Cen...")
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LocationScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(999.r),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Icon(
                              LucideIcons.mapPin,
                              size: 12.sp,
                              color: const Color(0xFF15803D),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Downtown Cen...',
                              style: GoogleFonts.outfit(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // QR Scanner Button (Circular white button)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QrScannerScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            LucideIcons.qrCode,
                            size: 16.sp,
                            color: const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Wishlist (Heart) Button (Opens WishlistScreen)
                    GestureDetector(
                      onTap: () {
                        if (widget.onWishlistTap != null) {
                          widget.onWishlistTap!();
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WishlistScreen(),
                            ),
                          );
                        }
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                LucideIcons.heart,
                                size: 16.sp,
                                color: wishlistCount > 0
                                    ? const Color(0xFFF43F5E)
                                    : const Color(0xFF334155),
                              ),
                            ),
                          ),
                          if (wishlistCount > 0)
                            Positioned(
                              right: -2.w,
                              top: -2.h,
                              child: Container(
                                padding: EdgeInsets.all(3.w),
                                constraints: BoxConstraints(
                                  minWidth: 16.w,
                                  minHeight: 16.h,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF43F5E),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '$wishlistCount',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 8.5.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),

                    // "Become a Seller" / "Vendor Admin" Button (Opens SellerLoginModal / SellerDashboardScreen)
                    GestureDetector(
                      onTap: () {
                        if (isVendor) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SellerDashboardScreen(),
                            ),
                          );
                        } else {
                          SellerLoginModal.show(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 13.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(999.r),
                          border: Border.all(
                            color: isVendor
                                ? const Color(0xFF10B981).withValues(alpha: 0.45)
                                : Colors.white.withValues(alpha: 0.12),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF0F172A,
                              ).withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isVendor) ...[
                              Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 5.w),
                            ],
                            Icon(
                              LucideIcons.store,
                              color: isVendor ? const Color(0xFF34D399) : const Color(0xFF10B981),
                              size: 14.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              isVendor
                                  ? (currentPersona != null ? 'Seller: ${currentPersona.name.split(' ').first}' : 'Vendor Admin')
                                  : 'Become a Seller',
                              style: GoogleFonts.outfit(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              // 2. SEARCH BAR ("Search products, kicks...") - 1:1 Live WebApp Input
              Container(
                height: 42.h,
                padding: EdgeInsets.only(left: 12.w, right: 6.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.search,
                      size: 16.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search products, kicks...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 12.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) {
                          AppState.instance.setSearchQuery(val);
                          widget.onSearchChanged?.call(val);
                          setState(() {});
                        },
                        onSubmitted: (val) {
                          AppState.instance.setSearchQuery(val);
                          if (widget.onSearchSubmitted != null) {
                            widget.onSearchSubmitted!(val);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AllProductsScreen(initialSearch: val),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                          });
                          AppState.instance.clearSearchQuery();
                          widget.onSearchChanged?.call('');
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              LucideIcons.x,
                              size: 13.sp,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: () {
                        final query = _searchController.text.trim();
                        AppState.instance.setSearchQuery(query);
                        if (widget.onSearchSubmitted != null) {
                          widget.onSearchSubmitted!(query);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AllProductsScreen(initialSearch: query),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(7.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Icon(
                          LucideIcons.slidersHorizontal,
                          size: 12.sp,
                          color: const Color(0xFF15803D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
