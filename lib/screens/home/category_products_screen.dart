import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../core/dummy_data.dart';
import '../../widgets/product_card.dart';

class CategoryProductsScreen extends StatefulWidget {
  final Category category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Popular',
    'Price: Low to High',
    'Price: High to Low',
    'Top Rated',
  ];

  List<Product> _getFilteredProducts() {
    List<Product> categoryProducts = DummyData.products
        .where((p) =>
            p.category.toLowerCase().contains(widget.category.name.toLowerCase()) ||
            widget.category.name.toLowerCase().contains(p.category.toLowerCase()))
        .toList();

    if (_selectedFilter == 'Popular') {
      categoryProducts.sort((a, b) => b.reviews.compareTo(a.reviews));
    } else if (_selectedFilter == 'Price: Low to High') {
      categoryProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedFilter == 'Price: High to Low') {
      categoryProducts.sort((a, b) => b.price.compareTo(a.price));
    } else if (_selectedFilter == 'Top Rated') {
      categoryProducts.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return categoryProducts;
  }

  @override
  Widget build(BuildContext context) {
    final products = _getFilteredProducts();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.category.name,
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Category Banner Header
          Container(
            margin: EdgeInsets.all(16.w),
            height: 120.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              image: DecorationImage(
                image: NetworkImage(widget.category.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.category.icon, color: Colors.white, size: 24.sp),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.name,
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.category.subcategories.join(' • '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.sp,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filters row
          SizedBox(
            height: 36.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;

                return ChoiceChip(
                  label: Text(
                    filter,
                    style: GoogleFonts.outfit(
                      fontSize: 11.sp,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    }
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
                );
              },
            ),
          ),
          SizedBox(height: 14.h),

          // Product Grid
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.packageOpen, size: 48.sp, color: Colors.grey.shade400),
                        SizedBox(height: 12.h),
                        Text(
                          'No products found in this category',
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 14.h,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
