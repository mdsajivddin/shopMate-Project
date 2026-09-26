import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../core/dummy_data.dart';
import '../cart/cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;
  String _selectedColor = '';
  String _selectedSize = '';
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    if (widget.product.colors.isNotEmpty) {
      _selectedColor = widget.product.colors.first;
    }
    if (widget.product.sizes.isNotEmpty) {
      _selectedSize = widget.product.sizes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final isFav = AppState.instance.isInWishlist(widget.product.id);
        final cartCount = AppState.instance.cartCount;

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? AppTheme.accentPink : AppTheme.textPrimary,
                ),
                onPressed: () {
                  AppState.instance.toggleWishlist(widget.product);
                },
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.shoppingBag, color: AppTheme.textPrimary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartScreen()),
                      );
                    },
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 6.w,
                      top: 6.h,
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
              SizedBox(width: 8.w),
            ],
          ),
          body: Column(
            children: [
              // Scrollable Details
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Gallery Carousel
                      _buildImageCarousel(),
                      SizedBox(height: 16.h),

                      // Product Details Card
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                          border: Border.all(color: AppTheme.borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 20,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Brand, SKU & Category Tag
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryLight,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    widget.product.brand.toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.primaryColor,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),
                                Text(
                                  'SKU: ${widget.product.qrCode}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.sp,
                                    color: AppTheme.textMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),

                            // Product Name
                            Text(
                              widget.product.name,
                              style: GoogleFonts.outfit(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                                height: 1.25,
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // Ratings & Reviews
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade50,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(color: Colors.amber.shade200),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star_rounded, size: 16.sp, color: AppTheme.accentAmber),
                                      SizedBox(width: 4.w),
                                      Text(
                                        widget.product.rating.toString(),
                                        style: GoogleFonts.outfit(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  '${widget.product.reviews} verified reviews',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.sp,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    'In Stock',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.successColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),

                            // Price Block
                            Container(
                              padding: EdgeInsets.all(14.w),
                              decoration: BoxDecoration(
                                color: AppTheme.backgroundColor,
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(color: AppTheme.borderColor),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '₹${widget.product.price.toInt()}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  if (widget.product.originalPrice > widget.product.price) ...[
                                    Text(
                                      '₹${widget.product.originalPrice.toInt()}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14.sp,
                                        color: AppTheme.textMuted,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentPink,
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Text(
                                        '${widget.product.discount}% OFF',
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Colors Selection
                            if (widget.product.colors.isNotEmpty) ...[
                              Text(
                                'Select Color: $_selectedColor',
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Wrap(
                                spacing: 8.w,
                                children: widget.product.colors.map((c) {
                                  final isSelected = _selectedColor == c;
                                  return ChoiceChip(
                                    label: Text(
                                      c,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12.sp,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                                      ),
                                    ),
                                    selected: isSelected,
                                    onSelected: (val) {
                                      setState(() => _selectedColor = c);
                                    },
                                    selectedColor: AppTheme.primaryColor,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(999.r),
                                      side: BorderSide(
                                        color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                                      ),
                                    ),
                                    showCheckmark: false,
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 18.h),
                            ],

                            // Sizes Selection
                            if (widget.product.sizes.isNotEmpty) ...[
                              Text(
                                'Select Size / Variant: $_selectedSize',
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Wrap(
                                spacing: 8.w,
                                children: widget.product.sizes.map((s) {
                                  final isSelected = _selectedSize == s;
                                  return ChoiceChip(
                                    label: Text(
                                      s,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12.sp,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                                      ),
                                    ),
                                    selected: isSelected,
                                    onSelected: (val) {
                                      setState(() => _selectedSize = s);
                                    },
                                    selectedColor: AppTheme.primaryColor,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(999.r),
                                      side: BorderSide(
                                        color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                                      ),
                                    ),
                                    showCheckmark: false,
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 18.h),
                            ],

                            // Quantity Stepper
                            Row(
                              children: [
                                Text(
                                  'Quantity:',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.backgroundColor,
                                    borderRadius: BorderRadius.circular(999.r),
                                    border: Border.all(color: AppTheme.borderColor),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, size: 16),
                                        onPressed: () {
                                          if (_quantity > 1) {
                                            setState(() => _quantity--);
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                                        child: Text(
                                          '$_quantity',
                                          style: GoogleFonts.outfit(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w800,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add, size: 16),
                                        onPressed: () {
                                          setState(() => _quantity++);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),

                            // Description
                            Text(
                              'Product Description',
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              widget.product.description,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.sp,
                                color: AppTheme.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Key Features Bullets
                            if (widget.product.features.isNotEmpty) ...[
                              Text(
                                'Key Highlights',
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              ...widget.product.features.map(
                                (f) => Padding(
                                  padding: EdgeInsets.only(bottom: 6.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        LucideIcons.checkCircle2,
                                        size: 16.sp,
                                        color: AppTheme.primaryColor,
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          f,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12.sp,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sticky Bottom Bar: Add to Cart & Buy Now
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppTheme.borderColor)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Add to Cart
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          AppState.instance.addToCart(
                            widget.product,
                            color: _selectedColor,
                            size: _selectedSize,
                            quantity: _quantity,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added $_quantity "${widget.product.name}" to cart'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999.r)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.shoppingBag, size: 16.sp, color: AppTheme.primaryColor),
                            SizedBox(width: 6.w),
                            Text(
                              'Add to Cart',
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Buy Now
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          AppState.instance.addToCart(
                            widget.product,
                            color: _selectedColor,
                            size: _selectedSize,
                            quantity: _quantity,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999.r)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Buy Now',
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(LucideIcons.arrowRight, size: 16.sp, color: Colors.white),
                          ],
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

  Widget _buildImageCarousel() {
    final images = widget.product.images.isNotEmpty ? widget.product.images : [widget.product.image];

    return Column(
      children: [
        SizedBox(
          height: 280.h,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) => setState(() => _currentImageIndex = index),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.network(
                    images[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        if (images.length > 1) ...[
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: _currentImageIndex == index ? 18.w : 6.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: _currentImageIndex == index ? AppTheme.primaryColor : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
