import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/dummy_data.dart';
import '../product/product_details_screen.dart';
import '../wishlist/wishlist_screen.dart';

class AllProductsScreen extends StatefulWidget {
  final String title;
  final String initialCategory;
  final String initialSearch;

  const AllProductsScreen({
    super.key,
    this.title = 'All Products',
    this.initialCategory = 'All',
    this.initialSearch = '',
  });

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  // Filters State (Web App 1:1 'Gy' Component)
  String _selectedGender =
      'all'; // 'all', 'Men', 'Women', 'Boys', 'Girls', 'Unisex'
  final List<String> _selectedCategories = [];
  final List<String> _selectedBrands = [];
  String _selectedPriceRange =
      'all'; // 'all', 'under-2000', '2000-4999', '5000-9999', '10000-above'
  String _selectedDiscount = 'all'; // 'all', '10', '20', '30', '40', '50'
  String _selectedRating = 'all'; // 'all', '4', '4.5'
  String _sortOption =
      'recommended'; // 'recommended', 'price-low', 'price-high', 'rating', 'discount', 'newest'

  // Search
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Internal Filter Modal Category & Brand Search
  String _categoryModalSearch = '';
  String _brandModalSearch = '';

  // Filter Price Ranges (Web App 1:1)
  final List<Map<String, dynamic>> _priceRanges = [
    {'id': 'all', 'label': 'All Prices', 'min': 0, 'max': 999999},
    {'id': 'under-2000', 'label': 'Under ₹2,000', 'min': 0, 'max': 2000},
    {'id': '2000-4999', 'label': '₹2,000 to ₹4,999', 'min': 2000, 'max': 4999},
    {'id': '5000-9999', 'label': '₹5,000 to ₹9,999', 'min': 5000, 'max': 9999},
    {
      'id': '10000-above',
      'label': '₹10,000 and Above',
      'min': 10000,
      'max': 999999,
    },
  ];

  // Filter Discounts (Web App 1:1)
  final List<Map<String, dynamic>> _discountOptions = [
    {'id': 'all', 'label': 'All Discounts', 'value': 0},
    {'id': '10', 'label': '10% and Above', 'value': 10},
    {'id': '20', 'label': '20% and Above', 'value': 20},
    {'id': '30', 'label': '30% and Above', 'value': 30},
    {'id': '40', 'label': '40% and Above', 'value': 40},
    {'id': '50', 'label': '50% and Above', 'value': 50},
  ];

  // Sort Options (Web App 1:1)
  final List<Map<String, String>> _sortOptions = [
    {'id': 'recommended', 'label': 'Recommended'},
    {'id': 'price-low', 'label': 'Price: Low to High'},
    {'id': 'price-high', 'label': 'Price: High to Low'},
    {'id': 'rating', 'label': 'Customer Rating'},
    {'id': 'discount', 'label': 'Better Discount'},
    {'id': 'newest', 'label': 'Newest Arrivals'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != 'All' && widget.initialCategory.isNotEmpty) {
      _selectedCategories.add(widget.initialCategory);
    }
    final initialQ = widget.initialSearch.isNotEmpty
        ? widget.initialSearch
        : AppState.instance.searchQuery;
    if (initialQ.isNotEmpty) {
      _searchQuery = initialQ;
      _searchController.text = initialQ;
    }
    AppState.instance.addListener(_onAppStateChanged);
  }

  void _onAppStateChanged() {
    if (mounted && _searchQuery != AppState.instance.searchQuery) {
      setState(() {
        _searchQuery = AppState.instance.searchQuery;
        _searchController.value = _searchController.value.copyWith(
          text: _searchQuery,
          selection: TextSelection.collapsed(offset: _searchQuery.length),
        );
      });
    }
  }

  @override
  void dispose() {
    AppState.instance.removeListener(_onAppStateChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Count products by Category
  Map<String, int> get _categoryCounts {
    final map = <String, int>{};
    for (final p in DummyData.products) {
      map[p.category] = (map[p.category] ?? 0) + 1;
      if (p.subcategory.isNotEmpty) {
        map[p.subcategory] = (map[p.subcategory] ?? 0) + 1;
      }
    }
    return map;
  }

  // Count products by Brand
  Map<String, int> get _brandCounts {
    final map = <String, int>{};
    for (final p in DummyData.products) {
      final b = p.brand.toUpperCase();
      map[b] = (map[b] ?? 0) + 1;
    }
    return map;
  }

  bool get _hasActiveFilters {
    return _selectedGender != 'all' ||
        _selectedCategories.isNotEmpty ||
        _selectedBrands.isNotEmpty ||
        _selectedPriceRange != 'all' ||
        _selectedDiscount != 'all' ||
        _selectedRating != 'all' ||
        _searchQuery.trim().isNotEmpty;
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedGender != 'all') count++;
    count += _selectedCategories.length;
    count += _selectedBrands.length;
    if (_selectedPriceRange != 'all') count++;
    if (_selectedDiscount != 'all') count++;
    if (_selectedRating != 'all') count++;
    if (_searchQuery.trim().isNotEmpty) count++;
    return count;
  }

  void _clearAllFilters() {
    setState(() {
      _selectedGender = 'all';
      _selectedCategories.clear();
      _selectedBrands.clear();
      _selectedPriceRange = 'all';
      _selectedDiscount = 'all';
      _selectedRating = 'all';
      _searchQuery = '';
      _searchController.clear();
    });
    AppState.instance.clearSearchQuery();
  }

  List<Product> get _filteredProducts {
    return DummyData.products.where((p) {
      // 1. Search Query
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final nameMatch = p.name.toLowerCase().contains(q);
        final brandMatch = p.brand.toLowerCase().contains(q);
        final catMatch = p.category.toLowerCase().contains(q);
        final subMatch = p.subcategory.toLowerCase().contains(q);
        if (!nameMatch && !brandMatch && !catMatch && !subMatch) {
          return false;
        }
      }

      // 2. Gender Filter (Web App 1:1)
      if (_selectedGender != 'all') {
        final combined = '${p.gender} ${p.name} ${p.subcategory} ${p.category}'
            .toLowerCase();
        final g = _selectedGender.toLowerCase();
        if (g == 'men' &&
            !combined.contains('men') &&
            !combined.contains('male') &&
            !combined.contains('unisex')) {
          return false;
        }
        if (g == 'women' &&
            !combined.contains('women') &&
            !combined.contains('female') &&
            !combined.contains('unisex')) {
          return false;
        }
        if (g == 'boys' &&
            !combined.contains('boy') &&
            !combined.contains('kids')) {
          return false;
        }
        if (g == 'girls' &&
            !combined.contains('girl') &&
            !combined.contains('kids')) {
          return false;
        }
        if (g == 'unisex' && !combined.contains('unisex')) {
          return false;
        }
      }

      // 3. Category Filter
      if (_selectedCategories.isNotEmpty) {
        final matchesCat =
            _selectedCategories.contains(p.category) ||
            _selectedCategories.contains(p.subcategory);
        if (!matchesCat) return false;
      }

      // 4. Brand Filter
      if (_selectedBrands.isNotEmpty) {
        if (!_selectedBrands.contains(p.brand.toUpperCase())) {
          return false;
        }
      }

      // 5. Price Filter
      if (_selectedPriceRange != 'all') {
        final range = _priceRanges.firstWhere(
          (r) => r['id'] == _selectedPriceRange,
          orElse: () => _priceRanges[0],
        );
        final min = range['min'] as int;
        final max = range['max'] as int;
        if (p.price < min || p.price > max) {
          return false;
        }
      }

      // 6. Discount Filter
      if (_selectedDiscount != 'all') {
        final minDiscount = int.tryParse(_selectedDiscount) ?? 0;
        if (p.discount < minDiscount) {
          return false;
        }
      }

      // 7. Rating Filter
      if (_selectedRating != 'all') {
        final minRating = double.tryParse(_selectedRating) ?? 0.0;
        if (p.rating < minRating) {
          return false;
        }
      }

      return true;
    }).toList()..sort((a, b) {
      switch (_sortOption) {
        case 'price-low':
          return a.price.compareTo(b.price);
        case 'price-high':
          return b.price.compareTo(a.price);
        case 'rating':
          return b.rating.compareTo(a.rating);
        case 'discount':
          return b.discount.compareTo(a.discount);
        case 'newest':
          return b.id.compareTo(a.id);
        case 'recommended':
        default:
          return 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;
    final isRootTab = Navigator.canPop(context) == false;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAF8F5),
          appBar: _buildTopAppBar(isRootTab),
          body: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Search Bar
                _buildSearchBar(),

                // Breadcrumb & Title Section
                _buildBreadcrumbAndHeader(filtered.length),

                // Active Filters & Sort Row
                _buildFilterAndSortBar(),

                // Active Filter Chips Horizontal Strip
                if (_hasActiveFilters) _buildActiveFilterChips(),

                SizedBox(height: 6.h),

                // Products Grid or Empty State
                Expanded(
                  child: filtered.isEmpty
                      ? _buildEmptyState()
                      : _buildProductsGrid(filtered),
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
  PreferredSizeWidget _buildTopAppBar(bool isRootTab) {
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
              'CATALOG',
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
        // Wishlist quick shortcut
        IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                LucideIcons.heart,
                size: 20.sp,
                color: const Color(0xFF171717),
              ),
              if (AppState.instance.wishlist.isNotEmpty)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: EdgeInsets.all(3.5.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3F6C),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${AppState.instance.wishlist.length}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WishlistScreen()),
            );
          },
        ),
        SizedBox(width: 6.w),
      ],
    );
  }

  // ==========================================
  // SEARCH BAR
  // ==========================================
  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) {
            setState(() => _searchQuery = val);
            AppState.instance.setSearchQuery(val);
          },
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5.sp,
            color: const Color(0xFF171717),
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8.h),
            prefixIcon: Icon(
              LucideIcons.search,
              size: 15.sp,
              color: const Color(0xFF64748B),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      AppState.instance.clearSearchQuery();
                      setState(() => _searchQuery = '');
                    },
                    child: Icon(
                      LucideIcons.x,
                      size: 14.sp,
                      color: const Color(0xFF64748B),
                    ),
                  )
                : null,
            hintText: 'Search products, kicks...',
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 12.sp,
              color: const Color(0xFF94A3B8),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // BREADCRUMB & HEADING
  // ==========================================
  Widget _buildBreadcrumbAndHeader(int itemCount) {
    final titleText = _selectedCategories.length == 1
        ? _selectedCategories.first
        : widget.title;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumbs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Home',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  LucideIcons.chevronRight,
                  size: 10.sp,
                  color: const Color(0xFF94A3B8),
                ),
                SizedBox(width: 4.w),
                Text(
                  'Clothing & Footwear',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  LucideIcons.chevronRight,
                  size: 10.sp,
                  color: const Color(0xFF94A3B8),
                ),
                SizedBox(width: 4.w),
                Text(
                  _selectedCategories.isNotEmpty
                      ? _selectedCategories.join(', ')
                      : 'All Products',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),

          // Main Header & Item count
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                titleText,
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '- $itemCount ${itemCount == 1 ? 'item' : 'items'}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FILTER & SORT BAR
  // ==========================================
  Widget _buildFilterAndSortBar() {
    final currentSort = _sortOptions.firstWhere(
      (s) => s['id'] == _sortOption,
      orElse: () => _sortOptions[0],
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Mobile Filters Button
          GestureDetector(
            onTap: _showFilterModal,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999.r),
                border: Border.all(
                  color: _hasActiveFilters
                      ? const Color(0xFFFF3F6C)
                      : const Color(0xFFCBD5E1),
                  width: _hasActiveFilters ? 1.4 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.slidersHorizontal,
                    size: 13.sp,
                    color: const Color(0xFFFF3F6C),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    _hasActiveFilters
                        ? 'Filters ($_activeFilterCount)'
                        : 'Filters',
                    style: GoogleFonts.outfit(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sort Dropdown Pill
          GestureDetector(
            onTap: _showSortBottomSheet,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.5.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFCBD5E1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sort by: ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    currentSort['label']!,
                    style: GoogleFonts.outfit(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    LucideIcons.chevronDown,
                    size: 13.sp,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ACTIVE FILTER CHIPS
  // ==========================================
  Widget _buildActiveFilterChips() {
    return Container(
      height: 32.h,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          // Gender Chip
          if (_selectedGender != 'all')
            _buildActiveChip(
              'Gender: $_selectedGender',
              () => setState(() => _selectedGender = 'all'),
            ),

          // Category Chips
          ..._selectedCategories.map(
            (cat) => _buildActiveChip(
              cat,
              () => setState(() => _selectedCategories.remove(cat)),
            ),
          ),

          // Brand Chips
          ..._selectedBrands.map(
            (brand) => _buildActiveChip(
              brand.toUpperCase(),
              () => setState(() => _selectedBrands.remove(brand)),
            ),
          ),

          // Price Chip
          if (_selectedPriceRange != 'all')
            _buildActiveChip(
              _priceRanges.firstWhere(
                    (r) => r['id'] == _selectedPriceRange,
                  )['label']
                  as String,
              () => setState(() => _selectedPriceRange = 'all'),
            ),

          // Discount Chip
          if (_selectedDiscount != 'all')
            _buildActiveChip(
              '$_selectedDiscount% And Above',
              () => setState(() => _selectedDiscount = 'all'),
            ),

          // Rating Chip
          if (_selectedRating != 'all')
            _buildActiveChip(
              '$_selectedRating★ & Above',
              () => setState(() => _selectedRating = 'all'),
            ),

          // Query Chip
          if (_searchQuery.trim().isNotEmpty)
            _buildActiveChip('Query: "$_searchQuery"', () {
              _searchController.clear();
              setState(() => _searchQuery = '');
            }, isBrandPill: true),

          // Clear All Button
          GestureDetector(
            onTap: _clearAllFilters,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
              child: Text(
                'Clear All',
                style: GoogleFonts.outfit(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFFF3F6C),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveChip(
    String label,
    VoidCallback onRemove, {
    bool isBrandPill = false,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 6.w),
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isBrandPill ? const Color(0xFFE6EEE7) : Colors.white,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: isBrandPill
              ? const Color(0xFF4A5D4E)
              : const Color(0xFFCBD5E1),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: isBrandPill
                  ? const Color(0xFF4A5D4E)
                  : const Color(0xFF0F172A),
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              LucideIcons.x,
              size: 12.sp,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PRODUCTS GRID (Web App 1:1)
  // ==========================================
  Widget _buildProductsGrid(List<Product> products) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.53,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    final isWishlisted = AppState.instance.isInWishlist(product.id);
    final isInCart = AppState.instance.cart.any(
      (c) => c.product.id == product.id,
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
            // Image Stack (Aspect 3/4)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: Container(
                    color: const Color(0xFFF5F2ED),
                    child: AspectRatio(
                      aspectRatio: 3 / 3.4,
                      child: Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFE2E8F0),
                          child: const Center(
                            child: Icon(LucideIcons.image, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Top Right: Wishlist Heart
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: () {
                      AppState.instance.toggleWishlist(product);
                    },
                    child: Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          isWishlisted ? Icons.favorite : LucideIcons.heart,
                          size: 14.sp,
                          color: isWishlisted
                              ? const Color(0xFFFF3F6C)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ),

                // Top Left: Badge (e.g. Best Seller)
                if (product.badge.isNotEmpty)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        product.badge.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                // Bottom Left: Rating Pill (Web App 1:1)
                Positioned(
                  bottom: 6.h,
                  left: 6.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.rating.toString(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.star_rounded,
                          size: 11.sp,
                          color: const Color(0xFFF59E0B),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          '|',
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: const Color(0xFFCBD5E1),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          '${product.reviews}+',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Product Details
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand Name (Uppercase)
                  Text(
                    product.brand.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),

                  // Product Name
                  Text(
                    product.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.h),

                  // Pricing Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${product.price.toInt()}',
                        style: GoogleFonts.outfit(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      if (product.originalPrice > product.price) ...[
                        SizedBox(width: 4.w),
                        Text(
                          '₹${product.originalPrice.toInt()}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5.sp,
                            color: const Color(0xFF94A3B8),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(${product.discount}% OFF)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFFF3F6C),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // "Only Few Left!" badge if discount >= 40% (Web App 1:1)
                  if (product.discount >= 40) ...[
                    SizedBox(height: 2.h),
                    Text(
                      'Only Few Left!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFF3F6C),
                      ),
                    ),
                  ],

                  SizedBox(height: 8.h),

                  // Add to Bag Button
                  SizedBox(
                    width: double.infinity,
                    height: 32.h,
                    child: ElevatedButton(
                      onPressed: () {
                        AppState.instance.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added ${product.name} to Bag'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: const Color(0xFF0F172A),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInCart
                            ? const Color(0xFFECFDF5)
                            : const Color(0xFF0F172A),
                        foregroundColor: isInCart
                            ? const Color(0xFF047857)
                            : Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        side: isInCart
                            ? const BorderSide(
                                color: Color(0xFF6EE7B7),
                                width: 1,
                              )
                            : BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isInCart
                                ? LucideIcons.check
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
          ],
        ),
      ),
    );
  }

  // ==========================================
  // EMPTY STATE (Web App 1:1)
  // ==========================================
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Container(
          padding: EdgeInsets.all(28.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
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
                width: 60.w,
                height: 60.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.slidersHorizontal,
                    size: 26.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'No matches found',
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "We couldn't find any products that match all your applied filters. Try clearing some filters or searching for something else.",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.sp,
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton.icon(
                onPressed: _clearAllFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3F6C),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
                icon: const Icon(LucideIcons.rotateCcw, size: 14),
                label: Text(
                  'Reset All Filters',
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
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
  // SORT BOTTOM SHEET (Web App 1:1)
  // ==========================================
  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sort By',
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Divider(color: const Color(0xFFE2E8F0), height: 16.h),
            ..._sortOptions.map((opt) {
              final isSelected = _sortOption == opt['id'];
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  opt['label']!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFFFF3F6C)
                        : const Color(0xFF0F172A),
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        LucideIcons.check,
                        color: Color(0xFFFF3F6C),
                        size: 18,
                      )
                    : null,
                onTap: () {
                  setState(() => _sortOption = opt['id']!);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // FULL FILTER MODAL / DRAWER (Web App 1:1)
  // ==========================================
  void _showFilterModal() {
    // Temporary variables for modal state
    String tempGender = _selectedGender;
    final List<String> tempCategories = List.from(_selectedCategories);
    final List<String> tempBrands = List.from(_selectedBrands);
    String tempPrice = _selectedPriceRange;
    String tempDiscount = _selectedDiscount;
    String tempRating = _selectedRating;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Count matching products inside modal dynamically
            final count = DummyData.products.where((p) {
              if (tempGender != 'all') {
                final combined =
                    '${p.gender} ${p.name} ${p.subcategory} ${p.category}'
                        .toLowerCase();
                final g = tempGender.toLowerCase();
                if (g == 'men' &&
                    !combined.contains('men') &&
                    !combined.contains('male') &&
                    !combined.contains('unisex')) {
                  return false;
                }
                if (g == 'women' &&
                    !combined.contains('women') &&
                    !combined.contains('female') &&
                    !combined.contains('unisex')) {
                  return false;
                }
                if (g == 'boys' &&
                    !combined.contains('boy') &&
                    !combined.contains('kids')) {
                  return false;
                }
                if (g == 'girls' &&
                    !combined.contains('girl') &&
                    !combined.contains('kids')) {
                  return false;
                }
                if (g == 'unisex' && !combined.contains('unisex')) {
                  return false;
                }
              }
              if (tempCategories.isNotEmpty) {
                if (!tempCategories.contains(p.category) &&
                    !tempCategories.contains(p.subcategory)) {
                  return false;
                }
              }
              if (tempBrands.isNotEmpty) {
                if (!tempBrands.contains(p.brand.toUpperCase())) {
                  return false;
                }
              }
              if (tempPrice != 'all') {
                final r = _priceRanges.firstWhere(
                  (pr) => pr['id'] == tempPrice,
                );
                if (p.price < r['min'] || p.price > r['max']) {
                  return false;
                }
              }
              if (tempDiscount != 'all') {
                final d = int.tryParse(tempDiscount) ?? 0;
                if (p.discount < d) return false;
              }
              if (tempRating != 'all') {
                final rt = double.tryParse(tempRating) ?? 0.0;
                if (p.rating < rt) return false;
              }
              return true;
            }).length;

            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  // Modal Header
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.w, 14.h, 14.w, 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'FILTERS',
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF0F172A),
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  tempGender = 'all';
                                  tempCategories.clear();
                                  tempBrands.clear();
                                  tempPrice = 'all';
                                  tempDiscount = 'all';
                                  tempRating = 'all';
                                });
                              },
                              child: Text(
                                'Clear All',
                                style: GoogleFonts.outfit(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFFFF3F6C),
                                ),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.x, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),

                  // Filter Content List
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(16.w),
                      children: [
                        // 1. GENDER
                        _buildFilterSectionTitle('Gender'),
                        ...[
                          'all',
                          'Men',
                          'Women',
                          'Boys',
                          'Girls',
                          'Unisex',
                        ].map((g) {
                          final isChecked = tempGender == g;
                          return _buildRadioRow(
                            label: g == 'all' ? 'All' : g,
                            isSelected: isChecked,
                            onTap: () => setModalState(() => tempGender = g),
                          );
                        }),
                        const Divider(color: Color(0xFFE2E8F0), height: 24),

                        // 2. CATEGORIES (with search & count)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildFilterSectionTitle('Categories'),
                            Container(
                              width: 140.w,
                              height: 28.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: TextField(
                                onChanged: (v) => setModalState(
                                  () => _categoryModalSearch = v,
                                ),
                                style: TextStyle(fontSize: 10.5.sp),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 6.h,
                                  ),
                                  prefixIcon: Icon(
                                    LucideIcons.search,
                                    size: 12.sp,
                                    color: Colors.grey,
                                  ),
                                  hintText: 'Search Category',
                                  hintStyle: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        ..._categoryCounts.entries
                            .filterCat(_categoryModalSearch)
                            .map((entry) {
                              final isChecked = tempCategories.contains(
                                entry.key,
                              );
                              return _buildCheckboxRow(
                                label: entry.key,
                                count: entry.value,
                                isChecked: isChecked,
                                onTap: () {
                                  setModalState(() {
                                    if (isChecked) {
                                      tempCategories.remove(entry.key);
                                    } else {
                                      tempCategories.add(entry.key);
                                    }
                                  });
                                },
                              );
                            }),
                        const Divider(color: Color(0xFFE2E8F0), height: 24),

                        // 3. BRANDS (with search & count)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildFilterSectionTitle('Brand'),
                            Container(
                              width: 140.w,
                              height: 28.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: TextField(
                                onChanged: (v) =>
                                    setModalState(() => _brandModalSearch = v),
                                style: TextStyle(fontSize: 10.5.sp),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 6.h,
                                  ),
                                  prefixIcon: Icon(
                                    LucideIcons.search,
                                    size: 12.sp,
                                    color: Colors.grey,
                                  ),
                                  hintText: 'Search Brand',
                                  hintStyle: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        ..._brandCounts.entries
                            .filterBrand(_brandModalSearch)
                            .map((entry) {
                              final isChecked = tempBrands.contains(entry.key);
                              return _buildCheckboxRow(
                                label: entry.key,
                                count: entry.value,
                                isChecked: isChecked,
                                onTap: () {
                                  setModalState(() {
                                    if (isChecked) {
                                      tempBrands.remove(entry.key);
                                    } else {
                                      tempBrands.add(entry.key);
                                    }
                                  });
                                },
                              );
                            }),
                        const Divider(color: Color(0xFFE2E8F0), height: 24),

                        // 4. PRICE
                        _buildFilterSectionTitle('Price'),
                        ..._priceRanges.map((pr) {
                          final isChecked = tempPrice == pr['id'];
                          return _buildRadioRow(
                            label: pr['label'] as String,
                            isSelected: isChecked,
                            onTap: () => setModalState(
                              () => tempPrice = pr['id'] as String,
                            ),
                          );
                        }),
                        const Divider(color: Color(0xFFE2E8F0), height: 24),

                        // 5. DISCOUNT RANGE
                        _buildFilterSectionTitle('Discount Range'),
                        ..._discountOptions.map((dc) {
                          final isChecked = tempDiscount == dc['id'];
                          return _buildRadioRow(
                            label: dc['label'] as String,
                            isSelected: isChecked,
                            onTap: () => setModalState(
                              () => tempDiscount = dc['id'] as String,
                            ),
                          );
                        }),
                        const Divider(color: Color(0xFFE2E8F0), height: 24),

                        // 6. CUSTOMER RATING
                        _buildFilterSectionTitle('Customer Rating'),
                        ...[
                          {'id': 'all', 'label': 'All Ratings'},
                          {'id': '4', 'label': '4★ & Above'},
                          {'id': '4.5', 'label': '4.5★ & Above'},
                        ].map((rt) {
                          final isChecked = tempRating == rt['id'];
                          return _buildRadioRow(
                            label: rt['label']!,
                            isSelected: isChecked,
                            onTap: () =>
                                setModalState(() => tempRating = rt['id']!),
                          );
                        }),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),

                  // Modal Bottom Actions
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                tempGender = 'all';
                                tempCategories.clear();
                                tempBrands.clear();
                                tempPrice = 'all';
                                tempDiscount = 'all';
                                tempRating = 'all';
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            child: Text(
                              'Clear All',
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF475569),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedGender = tempGender;
                                _selectedCategories
                                  ..clear()
                                  ..addAll(tempCategories);
                                _selectedBrands
                                  ..clear()
                                  ..addAll(tempBrands);
                                _selectedPriceRange = tempPrice;
                                _selectedDiscount = tempDiscount;
                                _selectedRating = tempRating;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF3F6C),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              elevation: 2,
                            ),
                            child: Text(
                              'Apply ($count)',
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                              ),
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
      },
    );
  }

  Widget _buildFilterSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 11.sp,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF0F172A),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildRadioRow({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF3F6C)
                      : const Color(0xFFCBD5E1),
                  width: isSelected ? 4.5 : 1.5,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF0F172A)
                    : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxRow({
    required String label,
    required int count,
    required bool isChecked,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: isChecked ? const Color(0xFFFF3F6C) : Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: isChecked
                          ? const Color(0xFFFF3F6C)
                          : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  child: isChecked
                      ? Icon(
                          LucideIcons.check,
                          size: 11.sp,
                          color: Colors.white,
                        )
                      : null,
                ),
                SizedBox(width: 10.w),
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.sp,
                    fontWeight: isChecked ? FontWeight.w800 : FontWeight.w500,
                    color: isChecked
                        ? const Color(0xFF0F172A)
                        : const Color(0xFF475569),
                  ),
                ),
              ],
            ),
            Text(
              '($count)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.sp,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helpers for filtering category and brand maps in modal
extension _MapFilterExtension on Iterable<MapEntry<String, int>> {
  Iterable<MapEntry<String, int>> filterCat(String query) {
    if (query.trim().isEmpty) return this;
    return where((e) => e.key.toLowerCase().contains(query.toLowerCase()));
  }

  Iterable<MapEntry<String, int>> filterBrand(String query) {
    if (query.trim().isEmpty) return this;
    return where((e) => e.key.toLowerCase().contains(query.toLowerCase()));
  }
}
