import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/theme.dart';
import '../core/dummy_data.dart';
import '../screens/product/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddToCart;

  const ProductCard({super.key, required this.product, this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final isFav = AppState.instance.isInWishlist(product.id);
        final isInCart = AppState.instance.cart.any(
          (item) => item.product.id == product.id,
        );

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(product: product),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppTheme.borderColor.withValues(alpha: 0.8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. IMAGE CONTAINER (3:4 Aspect Ratio with Badges)
                Expanded(
                  flex: 11,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: const Color(0xFFF5F2ED),
                          child: Hero(
                            tag: 'product_img_${product.id}',
                            child: Image.network(
                              product.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: const Color(0xFFF5F2ED),
                                    child: Center(
                                      child: Icon(
                                        LucideIcons.image,
                                        color: Colors.grey.shade400,
                                        size: 32.sp,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),

                      // Badge in Top-Left (e.g. BEST SELLER / TOP RATED)
                      if (product.badge.isNotEmpty)
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 7.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF171717,
                              ).withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              product.badge.toUpperCase(),
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 8.5.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),

                      // Wishlist Heart Button in Top-Right
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: GestureDetector(
                          onTap: () {
                            AppState.instance.toggleWishlist(product);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFav
                                      ? 'Removed from wishlist'
                                      : 'Added "${product.name}" to wishlist',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.sp,
                                  ),
                                ),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                size: 15.sp,
                                color: isFav
                                    ? AppTheme.accentPink
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Rating Pill in Bottom-Left: "4.9 ★ | 158"
                      Positioned(
                        bottom: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: AppTheme.borderColor.withValues(
                                alpha: 0.8,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                product.rating.toString(),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Icon(
                                Icons.star_rounded,
                                size: 12.sp,
                                color: AppTheme.accentAmber,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                '|',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                '${product.reviews}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9.5.sp,
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. CARD CONTENT
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Brand & Product Name
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              product.brand.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.textPrimary,
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.sp,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        // Price & Discount Row (FittedBox to prevent ANY overflow)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    '₹${product.price.toInt()}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  if (product.originalPrice >
                                      product.price) ...[
                                    SizedBox(width: 5.w),
                                    Text(
                                      '₹${product.originalPrice.toInt()}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.sp,
                                        color: AppTheme.textMuted,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                  if (product.discount > 0) ...[
                                    SizedBox(width: 4.w),
                                    Text(
                                      '(${product.discount}% OFF)',
                                      style: GoogleFonts.outfit(
                                        fontSize: 10.5.sp,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.accentPink,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (product.discount >= 40)
                              Padding(
                                padding: EdgeInsets.only(top: 2.h),
                                child: Text(
                                  'Only Few Left!',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.accentPink,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        // Add to Bag Button (Exact matching webapp)
                        GestureDetector(
                          onTap: () {
                            AppState.instance.addToCart(product);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added "${product.name}" to cart',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.sp,
                                  ),
                                ),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            );
                            onAddToCart?.call();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 6.5.h),
                            decoration: BoxDecoration(
                              color: isInCart
                                  ? const Color(0xFFECFDF5)
                                  : const Color(0xFF171717),
                              borderRadius: BorderRadius.circular(10.r),
                              border: isInCart
                                  ? Border.all(color: const Color(0xFF6EE7B7))
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isInCart
                                      ? Icons.check
                                      : LucideIcons.shoppingBag,
                                  size: 13.sp,
                                  color: isInCart
                                      ? const Color(0xFF047857)
                                      : Colors.white,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  isInCart ? 'Added' : 'Add to Bag',
                                  style: GoogleFonts.outfit(
                                    color: isInCart
                                        ? const Color(0xFF047857)
                                        : Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
}
