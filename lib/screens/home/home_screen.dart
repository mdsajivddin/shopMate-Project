import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../core/dummy_data.dart';
import '../../widgets/product_card.dart';
import '../../widgets/shopmate_header.dart';
import '../scanner/qr_scanner_screen.dart';
import '../wishlist/wishlist_screen.dart';
import 'category_products_screen.dart';
import 'all_products_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategoryFilter = 'All';
  int _activeBannerIndex = 0;
  final PageController _bannerController = PageController();
  final TextEditingController _newsletterController = TextEditingController();

  List<Product> get _displayedProducts {
    if (_selectedCategoryFilter == 'All') {
      return DummyData.products;
    }
    return DummyData.products
        .where(
          (p) => p.category.toLowerCase().contains(
            _selectedCategoryFilter.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _newsletterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar matching Screenshot 1 & 2
            ShopMateHeader(
              onCartTap: () => widget.onNavigateTab?.call(3),
              onWishlistTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WishlistScreen(),
                  ),
                );
              },
              onSearchSubmitted: (query) {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(1);
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
            ),

            // Scrollable Content matching the 13 exact sections from the live web app
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. HERO SECTION (Web App 1:1)
                    _buildHeroSection(),
                    SizedBox(height: 18.h),

                    // 2. VALUE PROPS (Free Shipping, Secure Payment, etc.)
                    _buildValueProps(),
                    SizedBox(height: 24.h),

                    // 3. PROMO BANNER CAROUSEL (STYLE-STACK, Puma, Nike)
                    _buildPromoBannerCarousel(),
                    SizedBox(height: 24.h),

                    // 4. NEWLY DROPPED COLLECTIONS
                    _buildNewlyDroppedCollections(),
                    SizedBox(height: 24.h),

                    // 5. CURATED DEPARTMENT STORE / SHOP BY CATEGORY
                    _buildCuratedDepartmentStore(),
                    SizedBox(height: 24.h),

                    // 6. SHOP BY CATEGORIES PILLS
                    _buildCategoriesSection(),
                    SizedBox(height: 24.h),

                    // 7. BENTO GRID COLLECTIONS
                    _buildBentoCollections(),
                    SizedBox(height: 24.h),

                    // 8. SUMMER COLLECTIONS
                    _buildSummerCollections(),
                    SizedBox(height: 24.h),

                    // 9. BEST SELLING PRODUCTS GRID WITH CATEGORY CHIPS
                    _buildBestSellingProductsSection(),
                    SizedBox(height: 24.h),

                    // 10. IN-STORE SCAN & GO EXPERIENCE BANNER
                    _buildInStoreQrBanner(),
                    SizedBox(height: 24.h),

                    // 11. SPECIAL PROMO BANNER (Up to 50% Off)
                    _buildSpecialPromoBanner(),
                    SizedBox(height: 24.h),

                    // 12. CUSTOMER TESTIMONIALS
                    _buildTestimonialsSection(),
                    SizedBox(height: 24.h),

                    // 13. FOOTER
                    _buildFooter(),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. HERO SECTION (Web App 1:1 Replica)
  // ==========================================
  Widget _buildHeroSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 20.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE6EEE7), // Soft mint/sage
            Color(0xFFDFEADE),
            Color(0xFFD5E2D5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFD1DDD0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A5D4E).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag: [ ✨ NEW ARRIVALS 2026 ] (white translucent pill)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(999.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.sparkles,
                  size: 13.sp,
                  color: const Color(0xFF3F5142),
                ),
                SizedBox(width: 5.w),
                Text(
                  'NEW ARRIVALS 2026',
                  style: GoogleFonts.outfit(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF3F5142),
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // Main Headline (Exact Web App Copy)
          Text(
            'Discover The Best Products for You',
            style: GoogleFonts.outfit(
              fontSize: 26.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF171717),
              height: 1.15,
              letterSpacing: -0.6,
            ),
          ),
          SizedBox(height: 8.h),

          // Subtitle
          Text(
            'Explore our wide range of high-quality products at affordable prices. Shop now and enjoy the best deals curated for your lifestyle!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5.sp,
              color: const Color(0xFF525252),
              height: 1.45,
            ),
          ),
          SizedBox(height: 16.h),

          // CTA Buttons Row
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AllProductsScreen(title: 'All Products'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A5D4E),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 22.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    elevation: 3,
                    shadowColor: const Color(0xFF4A5D4E).withValues(alpha: 0.3),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Shop Now',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        LucideIcons.arrowRight,
                        size: 15.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AllProductsScreen(title: 'Special Deals'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.85),
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 12.h,
                    ),
                    side: const BorderSide(
                      color: Color(0xFFCBD5E1),
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.flame,
                        size: 14.sp,
                        color: const Color(0xFFEA580C),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Explore Deals',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF171717),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),

          // Social Proof Stack & Star Rating (Exact Web App Copy)
          Row(
            children: [
              SizedBox(
                width: 68.w,
                height: 30.h,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: ClipOval(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=80&auto=format&fit=crop&q=80',
                          width: 26.w,
                          height: 26.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16.w,
                      child: ClipOval(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&auto=format&fit=crop&q=80',
                          width: 26.w,
                          height: 26.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 32.w,
                      child: ClipOval(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=80&auto=format&fit=crop&q=80',
                          width: 26.w,
                          height: 26.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5.sp,
                          color: const Color(0xFF171717),
                          fontWeight: FontWeight.w700,
                        ),
                        children: const [
                          TextSpan(text: 'Trusted by '),
                          TextSpan(
                            text: '10,000+ Happy Customers',
                            style: TextStyle(
                              color: Color(0xFF3F5142),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star_rounded,
                              size: 13.sp,
                              color: const Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '4.9/5 Average Rating',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),

          // Hero Image with 2 Floating Backdrop Badges (Web App 1:1)
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Product Image
                Image.network(
                  'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800&auto=format&fit=crop&q=80',
                  height: 180.h,
                  fit: BoxFit.contain,
                ),

                // Floating Badge 1 (Bottom Left): 100% Certified / Original Quality
                Positioned(
                  bottom: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 26.w,
                          height: 26.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            LucideIcons.shieldCheck,
                            size: 15.sp,
                            color: const Color(0xFF047857),
                          ),
                        ),
                        SizedBox(width: 7.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '100% Certified',
                              style: GoogleFonts.outfit(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF94A3B8),
                                letterSpacing: 0.4,
                              ),
                            ),
                            Text(
                              'Original Quality',
                              style: GoogleFonts.outfit(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Floating Badge 2 (Top Right): Limited Offer / Up to 50% Off
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 26.w,
                          height: 26.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            LucideIcons.flame,
                            size: 15.sp,
                            color: const Color(0xFFEA580C),
                          ),
                        ),
                        SizedBox(width: 7.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Limited Offer',
                              style: GoogleFonts.outfit(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF94A3B8),
                                letterSpacing: 0.4,
                              ),
                            ),
                            Text(
                              'Up to 50% Off',
                              style: GoogleFonts.outfit(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFFEA580C),
                              ),
                            ),
                          ],
                        ),
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
  }

  // ==========================================
  // 2. VALUE PROPS (Web App 1:1)
  // ==========================================
  Widget _buildValueProps() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: DummyData.valueProps.map((vp) {
          return Container(
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    vp.icon,
                    size: 16.sp,
                    color: const Color(0xFF4A5D4E),
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vp.title,
                      style: GoogleFonts.outfit(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF171717),
                      ),
                    ),
                    Text(
                      vp.desc,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.sp,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // 3. PROMO BANNER CAROUSEL (STYLE-STACK, Puma, Nike)
  // ==========================================
  Widget _buildPromoBannerCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 165.h,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (index) =>
                setState(() => _activeBannerIndex = index),
            itemCount: DummyData.heroBanners.length,
            itemBuilder: (context, index) {
              final banner = DummyData.heroBanners[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  image: DecorationImage(
                    image: NetworkImage(banner.image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.r),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withValues(alpha: 0.88),
                        Colors.black.withValues(alpha: 0.35),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 9.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF43F5E),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          banner.tag,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Text(
                        banner.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllProductsScreen(
                                title: 'Sneakers & Drops',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            banner.buttonText,
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF0F172A),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            DummyData.heroBanners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              width: _activeBannerIndex == index ? 20.w : 6.w,
              height: 4.5.h,
              decoration: BoxDecoration(
                color: _activeBannerIndex == index
                    ? const Color(0xFF4A5D4E)
                    : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 4. NEWLY DROPPED COLLECTIONS (Web App 1:1)
  // ==========================================
  Widget _buildNewlyDroppedCollections() {
    final droppedProducts = [
      {
        'id': 'DROP-001',
        'name': 'Gazelle Indoor Suede Shoes',
        'price': 4999,
        'tag': "Men's Sneakers",
        'image':
            'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=800&auto=format&fit=crop&q=80',
        'desc':
            'Classic indoor-ready gazelle with premium suede upper and signature contrast stripes.',
      },
      {
        'id': 'DROP-002',
        'name': 'Air Zoom Structure Prime',
        'price': 6499,
        'tag': "Men's Sneakers",
        'image':
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
        'desc':
            'Sleek running profile in neutral sand with breathable engineered mesh and gum outsole.',
      },
      {
        'id': 'DROP-003',
        'name': 'Chunky Street Runner Lows',
        'price': 5299,
        'tag': "Streetwear Kicks",
        'image':
            'https://images.unsplash.com/photo-1539185441755-769473a23570?w=800&auto=format&fit=crop&q=80',
        'desc':
            'Ultra-cushioned chunky platform silhouette engineered for daily urban walking.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Newly Dropped Collections',
                style: GoogleFonts.outfit(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF171717),
                  letterSpacing: -0.4,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'These sneakers cross to timeless classics, we bring you authentic kicks built for style and comfort and effortless everyday rotation.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.sp,
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 230.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: droppedProducts.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final item = droppedProducts[index];
              return Container(
                width: 190.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Container
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18.r),
                      ),
                      child: Image.network(
                        item['image'] as String,
                        height: 115.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              item['tag'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            item['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹${item['price']}',
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF4A5D4E),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Added ${item['name']} to Bag',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F172A),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    'Add to Bag',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 5. CURATED DEPARTMENT STORE / SHOP BY CATEGORY (Web App 1:1)
  // ==========================================
  Widget _buildCuratedDepartmentStore() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 22.h),
      color: const Color(0xFFFAF8F5),
      child: Column(
        children: [
          // Header Badge + Title + Center Accent Bar + Subtitle
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE6EEE7),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.sparkles,
                    size: 12.sp,
                    color: const Color(0xFF4A5D4E),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'CURATED DEPARTMENT STORE',
                    style: GoogleFonts.outfit(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF4A5D4E),
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'SHOP BY CATEGORY',
            style: GoogleFonts.outfit(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF171717),
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            width: 50.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: const Color(0xFF4A5D4E),
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Explore authentic handpicked collections across apparel, activewear, footwear, and luxury lifestyle accessories.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5.sp,
                color: const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 18.h),

          // Department Cards (Ethnic, Casual, Men's Active, Women's Active, etc.)
          SizedBox(
            height: 155.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: DummyData.curatedOffers.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final offer = DummyData.curatedOffers[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllProductsScreen(title: offer.title),
                      ),
                    );
                  },
                  child: Container(
                    width: 130.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      image: DecorationImage(
                        image: NetworkImage(offer.image),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.85),
                            Colors.black.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF10B981,
                              ).withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: const Color(
                                  0xFF10B981,
                                ).withValues(alpha: 0.5),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              offer.offer,
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF6EE7B7),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 6. SHOP BY CATEGORIES PILLS (Web App 1:1)
  // ==========================================
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shop by Categories',
                    style: GoogleFonts.outfit(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF171717),
                    ),
                  ),
                  Text(
                    'Browse curated handpicked categories',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AllProductsScreen(title: 'All Categories'),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.outfit(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF4A5D4E),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 110.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: DummyData.categories.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final cat = DummyData.categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryProductsScreen(category: cat),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      width: 66.w,
                      height: 66.w,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.network(cat.image, fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      cat.name,
                      style: GoogleFonts.outfit(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 7. BENTO GRID COLLECTIONS (Web App 1:1)
  // ==========================================
  Widget _buildBentoCollections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEFE9E1),
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: const Color(0xFFDFD5C5)),
            ),
            child: Text(
              'See More Collections',
              style: GoogleFonts.outfit(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF533D2D),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Center(
          child: Text(
            'Most Recommend Collections For You',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF171717),
              letterSpacing: -0.4,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'These sneakers cross to timeless classics, we bring you authentic kicks built for style and comfort.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.sp,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Bento Cards Stack
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              // Large Featured Bento Card
              Container(
                height: 180.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=800&auto=format&fit=crop&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.r),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vintage Court & Denim Series',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'View all sneakers →',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF34D399),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Two Small Bento Cards in a Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 140.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=800&auto=format&fit=crop&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.r),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Heritage Leather',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      height: 140.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1539185441755-769473a23570?w=800&auto=format&fit=crop&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.r),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chunky Street Runner',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 8. SUMMER COLLECTIONS (Web App 1:1)
  // ==========================================
  Widget _buildSummerCollections() {
    final summerItems = [
      {
        'id': 'SUM-001',
        'name': 'Summer Breeze Air Max Minimal',
        'price': 4799,
        'tag': 'Summer Sneakers',
        'image':
            'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&auto=format&fit=crop&q=80',
      },
      {
        'id': 'SUM-002',
        'name': 'Desert Sand Outdoor Trainer',
        'price': 5499,
        'tag': 'Summer Sneakers',
        'image':
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Summer Collections',
                style: GoogleFonts.outfit(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF171717),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'These sneakers cross to timeless classics, we bring you authentic kicks built for style and comfort and lightweight warm-weather wear.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.sp,
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 195.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: summerItems.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final item = summerItems[index];
              return Container(
                width: 175.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18.r),
                      ),
                      child: Image.network(
                        item['image'] as String,
                        height: 110.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '₹${item['price']}',
                            style: GoogleFonts.outfit(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF4A5D4E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 9. BEST SELLING PRODUCTS GRID WITH CATEGORY CHIPS
  // ==========================================
  Widget _buildBestSellingProductsSection() {
    final filterOptions = [
      'All',
      'Sports',
      'Electronics',
      'Fashion',
      'Home',
      'Accessories',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Best Selling Products',
                    style: GoogleFonts.outfit(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF171717),
                    ),
                  ),
                  Text(
                    'Loved by thousands for design and performance',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AllProductsScreen(title: 'All Products (20)'),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.outfit(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF4A5D4E),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),

        // Filter Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: filterOptions.map((f) {
              final isSelected = _selectedCategoryFilter == f;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: FilterChip(
                  label: Text(
                    f,
                    style: GoogleFonts.outfit(
                      fontSize: 11.5.sp,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF171717),
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      _selectedCategoryFilter = f;
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFF4A5D4E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999.r),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF4A5D4E)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  showCheckmark: false,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 14.h),

        // 2-Column Responsive Grid with zero overflow
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _displayedProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemBuilder: (context, index) {
              final product = _displayedProducts[index];
              return ProductCard(product: product, onAddToCart: () {});
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 10. IN-STORE SCAN & GO EXPERIENCE BANNER (Web App 1:1)
  // ==========================================
  Widget _buildInStoreQrBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F172A), // Dark slate
            Color(0xFF222E25), // Forest dark
            Color(0xFF0B1320),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.qrCode,
                  size: 12.sp,
                  color: const Color(0xFF34D399),
                ),
                SizedBox(width: 5.w),
                Text(
                  'IN-STORE SCAN & GO EXPERIENCE',
                  style: GoogleFonts.outfit(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF34D399),
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          Text(
            'Visiting Our Retail Stores? Scan & Self-Checkout!',
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Pick your nearest ShopMate branch (Downtown Galleria), scan shelf QR codes directly using your phone camera, see instant aisle location & price, and skip the checkout lines!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.sp,
              color: const Color(0xFFCBD5E1),
              height: 1.45,
            ),
          ),
          SizedBox(height: 16.h),

          // Launch QR Button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QrScannerScreen(),
                ),
              );
            },
            icon: const Icon(LucideIcons.qrCode, size: 16),
            label: Text(
              'Launch In-Store QR Scanner',
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: const Color(0xFF0F172A),
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 11.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
          ),
          SizedBox(height: 14.h),

          // Store status chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.mapPin,
                  size: 14.sp,
                  color: const Color(0xFF34D399),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'ShopMate Flagship - Downtown Galleria',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '● Open Now',
                  style: GoogleFonts.outfit(
                    fontSize: 10.5.sp,
                    color: const Color(0xFF34D399),
                    fontWeight: FontWeight.w800,
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
  // 11. SPECIAL PROMO BANNER (Web App 1:1)
  // ==========================================
  Widget _buildSpecialPromoBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5EEE6), Color(0xFFEFE5D8), Color(0xFFE5D7C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFFD4A373).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFD4A373),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.sparkles, size: 12.sp, color: Colors.white),
                SizedBox(width: 4.w),
                Text(
                  'SPECIAL OFFER',
                  style: GoogleFonts.outfit(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Up to 50% Off',
            style: GoogleFonts.outfit(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF171717),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Limited time offer on selected items. Hurry up and grab the best deals before stock runs out!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.sp,
              color: const Color(0xFF525252),
              height: 1.4,
            ),
          ),
          SizedBox(height: 14.h),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AllProductsScreen(title: 'Special Deals (50% Off)'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A5D4E),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
            child: Text(
              'Shop Deals Now →',
              style: GoogleFonts.outfit(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 12. CUSTOMER TESTIMONIALS (Web App 1:1)
  // ==========================================
  Widget _buildTestimonialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'What Our Customers Say',
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF171717),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Center(
          child: Text(
            'Real experiences and verified reviews from shoppers',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.sp,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 170.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: DummyData.testimonials.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final t = DummyData.testimonials[index];
              return Container(
                width: 250.w,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(
                            t.rating,
                            (i) => Icon(
                              Icons.star_rounded,
                              size: 14.sp,
                              color: const Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '"${t.comment}"',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5.sp,
                            color: const Color(0xFF334155),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            t.avatar,
                            width: 28.w,
                            height: 28.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.name,
                                style: GoogleFonts.outfit(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                t.role,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9.5.sp,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 13. FOOTER (Web App 1:1)
  // ==========================================
  Widget _buildFooter() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EFEA),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Row
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A5D4E),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.shoppingBag,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
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
            ],
          ),
          SizedBox(height: 10.h),

          Text(
            'Your curated online & in-store retail experience. Discover iconic sneakers, streetwear drops, and scan shelf products with instant self-checkout.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5.sp,
              color: const Color(0xFF64748B),
              height: 1.45,
            ),
          ),
          SizedBox(height: 16.h),

          // Newsletter subscribe
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newsletterController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 11.sp,
                        color: const Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_newsletterController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Subscribed to ShopMate Newsletter!'),
                        ),
                      );
                      _newsletterController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A5D4E),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  child: Text(
                    'Join',
                    style: GoogleFonts.outfit(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Copyright
          Center(
            child: Text(
              '© 2026 ShopMate Inc. All rights reserved.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5.sp,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
