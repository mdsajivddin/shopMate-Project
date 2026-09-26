import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/dummy_data.dart';
import '../checkout/checkout_screen.dart';
import '../home/all_products_screen.dart';
import '../product/product_details_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  String _couponError = '';

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCouponCode(String code) {
    final clean = code.trim().toUpperCase();
    if (clean.isEmpty) return;

    final success = AppState.instance.applyCoupon(clean);
    setState(() {
      if (success) {
        _couponError = '';
        _couponController.clear();
      } else {
        _couponError = 'Invalid coupon code. Try "SHOP50" or "SAVE20"';
      }
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coupon "$clean" Applied Successfully!'),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF047857),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRootTab = Navigator.canPop(context) == false;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final cart = AppState.instance.cart;
        final totalItemsCount = AppState.instance.cartCount;

        // Financials (Web App 1:1 'Qy')
        final subtotal = cart.fold<double>(0.0, (sum, i) => sum + i.product.price * i.quantity);
        final totalMRP = cart.fold<double>(0.0, (sum, i) {
          final orig = i.product.originalPrice > i.product.price
              ? i.product.originalPrice
              : i.product.price * 1.4;
          return sum + orig * i.quantity;
        });
        final discountOnMRP = (totalMRP - subtotal).clamp(0.0, double.infinity);

        final appliedCoupon = AppState.instance.appliedCoupon;
        double couponDiscount = 0.0;
        if (appliedCoupon != null) {
          couponDiscount = subtotal * appliedCoupon.discountPercent;
        }

        final isFreeShipping = subtotal >= 999 || (appliedCoupon?.isFreeShipping ?? false);
        final shippingFee = (subtotal > 0 && !isFreeShipping) ? 99.0 : 0.0;
        final totalAmount = (subtotal - couponDiscount + shippingFee).clamp(0.0, double.infinity);

        return Scaffold(
          backgroundColor: const Color(0xFFFAF8F5),
          appBar: _buildAppBar(isRootTab),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                // Sticky Sub-Header: Breadcrumb & Item Count Badge
                _buildSubHeader(totalItemsCount),

                // Main Content
                Expanded(
                  child: cart.isEmpty
                      ? _buildEmptyCart()
                      : SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 10.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. Free Shipping Progress Bar
                              _buildFreeShippingBar(subtotal, isFreeShipping),
                              SizedBox(height: 12.h),

                              // 2. Items in Bag Card
                              _buildCartItemsList(cart),
                              SizedBox(height: 12.h),

                              // 3. Trust & Value Props
                              _buildTrustGuarantees(),
                              SizedBox(height: 12.h),

                              // 4. Coupons & Offers Card
                              _buildCouponsCard(appliedCoupon),
                              SizedBox(height: 12.h),

                              // 5. Price Details Breakdown Card
                              _buildPriceDetailsCard(
                                itemsCount: cart.length,
                                totalMRP: totalMRP,
                                discountOnMRP: discountOnMRP,
                                couponDiscount: couponDiscount,
                                shippingFee: shippingFee,
                                totalAmount: totalAmount,
                              ),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // TOP APP BAR
  // ==========================================
  PreferredSizeWidget _buildAppBar(bool isRootTab) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: isRootTab
          ? null
          : IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF171717)),
              onPressed: () => Navigator.pop(context),
            ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: const Color(0xFF4A5D4E),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              LucideIcons.shoppingBag,
              color: Colors.white,
              size: 15.sp,
            ),
          ),
          SizedBox(width: 8.w),
          RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                fontSize: 17.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
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
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EEE7),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              'BAG',
              style: GoogleFonts.outfit(
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF4A5D4E),
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (AppState.instance.cart.isNotEmpty)
          TextButton.icon(
            onPressed: () {
              AppState.instance.clearCart();
            },
            icon: Icon(LucideIcons.trash2, size: 14.sp, color: const Color(0xFFE11D48)),
            label: Text(
              'Clear',
              style: GoogleFonts.outfit(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE11D48),
              ),
            ),
          ),
        SizedBox(width: 4.w),
      ],
    );
  }

  // ==========================================
  // STICKY SUB-HEADER (Breadcrumb & Items Selected Badge)
  // ==========================================
  Widget _buildSubHeader(int totalCount) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Breadcrumbs
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (Navigator.canPop(context)) Navigator.pop(context);
                },
                child: Text(
                  'Home',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.sp,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                '/',
                style: TextStyle(fontSize: 11.sp, color: const Color(0xFFCBD5E1)),
              ),
              SizedBox(width: 4.w),
              Text(
                'Shopping Bag',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.sp,
                  color: const Color(0xFF0F172A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          // Items Selected Pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EEE7),
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: const Color(0xFF4A5D4E).withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.shoppingBag, size: 11.sp, color: const Color(0xFF4A5D4E)),
                SizedBox(width: 4.w),
                Text(
                  '$totalCount Items Selected',
                  style: GoogleFonts.outfit(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF4A5D4E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // EMPTY SHOPPING BAG STATE (Web App 1:1)
  // ==========================================
  Widget _buildEmptyCart() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 36.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6EEE7),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.shoppingBag,
                    size: 34.sp,
                    color: const Color(0xFF4A5D4E),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Your Shopping Bag is Empty',
                style: GoogleFonts.outfit(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Explore our latest sneaker drops, trending trackpants, luxury watches, and street essentials to start your rotation!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.sp,
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 22.h),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllProductsScreen(title: 'All Products'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A5D4E),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(LucideIcons.arrowRight, size: 15),
                label: Text(
                  'EXPLORE PRODUCTS',
                  style: GoogleFonts.outfit(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. FREE SHIPPING PROGRESS BAR (Web App 1:1)
  // ==========================================
  Widget _buildFreeShippingBar(double subtotal, bool isFree) {
    final progress = (subtotal / 999).clamp(0.0, 1.0);
    final remaining = (999 - subtotal).clamp(0.0, 999.0);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
          ),
        ],
      ),
      child: isFree
          ? Row(
              children: [
                Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFECFDF5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.check,
                    size: 13.sp,
                    color: const Color(0xFF047857),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF065F46),
                      ),
                      children: const [
                        TextSpan(text: 'Yay! You have unlocked '),
                        TextSpan(
                          text: 'FREE Standard Delivery',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(text: ' on this order!'),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.sp,
                          color: const Color(0xFF334155),
                        ),
                        children: [
                          const TextSpan(text: 'Add '),
                          TextSpan(
                            text: '₹${remaining.toInt()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF4A5D4E),
                            ),
                          ),
                          const TextSpan(text: ' more to enjoy '),
                          const TextSpan(
                            text: 'FREE Shipping',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF047857),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4A5D4E)),
                    minHeight: 6.h,
                  ),
                ),
              ],
            ),
    );
  }

  // ==========================================
  // 2. ITEMS IN BAG LIST (Web App 1:1)
  // ==========================================
  Widget _buildCartItemsList(List<CartItem> cart) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Items in Bag (${cart.length})',
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppState.instance.clearCart();
                },
                child: Row(
                  children: [
                    Icon(LucideIcons.trash2, size: 13.sp, color: const Color(0xFFE11D48)),
                    SizedBox(width: 4.w),
                    Text(
                      'Clear Bag',
                      style: GoogleFonts.outfit(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFE11D48),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 20),

          // Items list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cart.length,
            separatorBuilder: (_, __) => const Divider(color: Color(0xFFF1F5F9), height: 24),
            itemBuilder: (context, index) {
              final item = cart[index];
              return _buildCartItemRow(item);
            },
          ),

          const Divider(color: Color(0xFFF1F5F9), height: 24),

          // Continue Shopping link
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllProductsScreen(title: 'All Products'),
                ),
              );
            },
            child: Row(
              children: [
                Icon(LucideIcons.arrowLeft, size: 13.sp, color: const Color(0xFF4A5D4E)),
                SizedBox(width: 5.w),
                Text(
                  'Continue Shopping',
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF4A5D4E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemRow(CartItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image in sand gradient box
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(product: item.product),
                  ),
                );
              },
              child: Container(
                width: 76.w,
                height: 76.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF6F3ED), Color(0xFFECE7DE)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.network(
                    item.product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.brand.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF4A5D4E),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: item.product),
                        ),
                      );
                    },
                    child: Text(
                      item.product.name,
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Meta chips
                  Row(
                    children: [
                      if (item.selectedSize.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          margin: EdgeInsets.only(right: 6.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'Size: ${item.selectedSize}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF475569),
                            ),
                          ),
                        ),
                      Text(
                        'In Stock',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF047857),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Pricing
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${item.product.price.toInt()}',
                        style: GoogleFonts.outfit(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      if (item.product.originalPrice > item.product.price) ...[
                        SizedBox(width: 5.w),
                        Text(
                          '₹${item.product.originalPrice.toInt()}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5.sp,
                            color: const Color(0xFF94A3B8),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 10.h),

        // Controls Row: Stepper + Line Total + Action Icons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Stepper controls
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      AppState.instance.updateQuantity(item, -1);
                    },
                    child: Container(
                      width: 26.w,
                      height: 26.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          LucideIcons.minus,
                          size: 12.sp,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 28.w,
                    child: Center(
                      child: Text(
                        '${item.quantity}',
                        style: GoogleFonts.outfit(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AppState.instance.updateQuantity(item, 1);
                    },
                    child: Container(
                      width: 26.w,
                      height: 26.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          LucideIcons.plus,
                          size: 12.sp,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Line Total
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${(item.product.price * item.quantity).toInt()}',
                  style: GoogleFonts.outfit(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Total',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),

            // Actions: Move to Wishlist & Remove
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    LucideIcons.heart,
                    size: 16.sp,
                    color: const Color(0xFF64748B),
                  ),
                  onPressed: () {
                    AppState.instance.toggleWishlist(item.product);
                    AppState.instance.removeFromCart(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Moved to Wishlist'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  tooltip: 'Move to Wishlist',
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: Icon(
                    LucideIcons.trash2,
                    size: 16.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                  onPressed: () {
                    AppState.instance.removeFromCart(item);
                  },
                  tooltip: 'Remove',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // 3. TRUST GUARANTEES (Web App 1:1)
  // ==========================================
  Widget _buildTrustGuarantees() {
    return Row(
      children: [
        Expanded(
          child: _buildTrustPill(
            LucideIcons.shieldCheck,
            '100% Genuine',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildTrustPill(
            LucideIcons.rotateCcw,
            '14 Days Return',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildTrustPill(
            LucideIcons.truck,
            'Fast Delivery',
          ),
        ),
      ],
    );
  }

  Widget _buildTrustPill(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: const Color(0xFF4A5D4E)),
          SizedBox(height: 4.h),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF334155),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. COUPONS & OFFERS CARD (Web App 1:1)
  // ==========================================
  Widget _buildCouponsCard(Coupon? applied) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.ticket, size: 14.sp, color: const Color(0xFF4A5D4E)),
              SizedBox(width: 6.w),
              Text(
                'COUPONS & OFFERS',
                style: GoogleFonts.outfit(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Input form
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: TextField(
                    controller: _couponController,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Enter coupon code',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF94A3B8),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (val) => _applyCouponCode(val),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: () => _applyCouponCode(_couponController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                child: Text(
                  'Apply',
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          if (_couponError.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              _couponError,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5.sp,
                color: const Color(0xFFE11D48),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          // Applied Coupon Badge
          if (applied != null) ...[
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.check, size: 14.sp, color: const Color(0xFF047857)),
                      SizedBox(width: 6.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${applied.code} Applied!',
                            style: GoogleFonts.outfit(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF047857),
                            ),
                          ),
                          Text(
                            applied.desc,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5.sp,
                              color: const Color(0xFF065F46),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      AppState.instance.removeCoupon();
                    },
                    child: Icon(LucideIcons.x, size: 14.sp, color: const Color(0xFF047857)),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 10.h),
          const Divider(color: Color(0xFFF1F5F9)),
          SizedBox(height: 6.h),

          // Quick Demo Chips
          Wrap(
            spacing: 8.w,
            children: [
              GestureDetector(
                onTap: () => _applyCouponCode('SHOP50'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6EEE7),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: const Color(0xFF4A5D4E).withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'SHOP50 (50% Off)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF4A5D4E),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _applyCouponCode('SAVE20'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6EEE7),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: const Color(0xFF4A5D4E).withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'SAVE20 (20% Off)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF4A5D4E),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 5. PRICE DETAILS BREAKDOWN CARD (Web App 1:1)
  // ==========================================
  Widget _buildPriceDetailsCard({
    required int itemsCount,
    required double totalMRP,
    required double discountOnMRP,
    required double couponDiscount,
    required double shippingFee,
    required double totalAmount,
  }) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRICE DETAILS ($itemsCount ITEMS)',
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
              letterSpacing: 0.5,
            ),
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 20),

          // Total MRP
          _buildPriceLine(
            'Total MRP',
            '₹${totalMRP.toInt()}',
          ),
          SizedBox(height: 8.h),

          // Discount on MRP
          if (discountOnMRP > 0) ...[
            _buildPriceLine(
              'Discount on MRP',
              '-₹${discountOnMRP.toInt()}',
              isGreen: true,
            ),
            SizedBox(height: 8.h),
          ],

          // Coupon Discount
          if (couponDiscount > 0) ...[
            _buildPriceLine(
              'Coupon Discount',
              '-₹${couponDiscount.toInt()}',
              isGreen: true,
            ),
            SizedBox(height: 8.h),
          ],

          // Shipping Fee
          _buildPriceLine(
            'Shipping Fee',
            shippingFee == 0 ? 'FREE' : '₹${shippingFee.toInt()}',
            isGreen: shippingFee == 0,
          ),

          const Divider(color: Color(0xFFF1F5F9), height: 22),

          // Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                '₹${totalAmount.toInt()}',
                style: GoogleFonts.outfit(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF4A5D4E),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // PROCEED TO CHECKOUT BUTTON
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A5D4E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PROCEED TO CHECKOUT',
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(LucideIcons.arrowRight, size: 16.sp),
                ],
              ),
            ),
          ),

          SizedBox(height: 10.h),
          Center(
            child: Text(
              'Safe & Secure Payments • 100% Buyer Protection',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.sp,
                color: const Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceLine(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.sp,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w800,
            color: isGreen ? const Color(0xFF047857) : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
