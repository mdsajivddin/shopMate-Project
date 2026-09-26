import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/dummy_data.dart';
import '../product/product_details_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  // Tabs: 'scanner' or 'stores' (Web App 1:1 'wy')
  String _activeTab = 'scanner';

  // Scanner State
  bool _isCameraActive = true;
  Product? _scannedProduct;
  bool _isAddedToExpressCart = false;
  final TextEditingController _manualInputController = TextEditingController();

  // Animation for scanner laser line
  late AnimationController _laserAnimationController;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    _laserAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.08, end: 0.92).animate(
      CurvedAnimation(
        parent: _laserAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Initial demo scan: first product (Nordic Olive Travel Backpack)
    _scannedProduct = DummyData.products.first;
  }

  @override
  void dispose() {
    _laserAnimationController.dispose();
    _manualInputController.dispose();
    super.dispose();
  }

  void _scanCode(String code) {
    final clean = code.trim().toUpperCase();
    if (clean.isEmpty) return;

    final found = DummyData.products.firstWhere(
      (p) => p.qrCode.toUpperCase() == clean || p.id.toUpperCase() == clean,
      orElse: () => DummyData.products.firstWhere(
        (p) => p.name.toUpperCase().contains(clean),
        orElse: () => DummyData.products.first,
      ),
    );

    setState(() {
      _scannedProduct = found;
      _isAddedToExpressCart = false;
      _activeTab = 'scanner';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.check, color: Colors.white, size: 16),
            SizedBox(width: 8.w),
            Expanded(child: Text('Scanned: ${found.name}')),
          ],
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF047857),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRootTab = Navigator.canPop(context) == false;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final currentStore = AppState.instance.selectedStore;

        return Scaffold(
          backgroundColor: const Color(0xFFFAF8F5),
          appBar: _buildAppBar(isRootTab),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. IN-STORE SMART SCANNER MODE HEADER CARD (Web App 1:1)
                  _buildHeaderCard(currentStore),
                  SizedBox(height: 14.h),

                  // 2. TAB CONTENT
                  if (_activeTab == 'stores') ...[
                    _buildStoresListTab(currentStore),
                  ] else ...[
                    _buildScannerTab(currentStore),
                  ],

                  SizedBox(height: 24.h),
                ],
              ),
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
              LucideIcons.qrCode,
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
              'IN-STORE',
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
        IconButton(
          icon: const Icon(LucideIcons.info, color: Color(0xFF64748B), size: 19),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                title: Text(
                  'About In-Store Scan & Go',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w900),
                ),
                content: Text(
                  'Scan any QR barcode tag placed next to garments or shelf displays in physical ShopMate retail stores to view instant aisle stock, live specs, and express checkout directly from your mobile device.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13.sp, height: 1.4),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      'Got It',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF4A5D4E),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================
  // 1. IN-STORE HEADER CARD (Web App 1:1 'wy')
  // ==========================================
  Widget _buildHeaderCard(StoreLocation currentStore) {
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
          // Mode Pill with pulsing dot
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'IN-STORE SMART SCANNER MODE',
                style: GoogleFonts.outfit(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF4A5D4E),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Active Store Title
          Text(
            currentStore.name,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 4.h),

          // Store address and timing
          Row(
            children: [
              Icon(LucideIcons.mapPin, size: 12.sp, color: const Color(0xFF64748B)),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  currentStore.address,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.sp,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Icon(LucideIcons.clock, size: 12.sp, color: const Color(0xFF64748B)),
              SizedBox(width: 4.w),
              Text(
                currentStore.timing,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.sp,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // 2-Tab Switcher (Web App 1:1)
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabPill(
                    title: 'QR Scanner',
                    icon: LucideIcons.qrCode,
                    isSelected: _activeTab == 'scanner',
                    onTap: () => setState(() => _activeTab = 'scanner'),
                  ),
                ),
                Expanded(
                  child: _buildTabPill(
                    title: 'Choose Branch (${DummyData.stores.length})',
                    icon: LucideIcons.store,
                    isSelected: _activeTab == 'stores',
                    onTap: () => setState(() => _activeTab = 'stores'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabPill({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(999.r),
          border: isSelected
              ? Border.all(color: const Color(0xFF4A5D4E).withValues(alpha: 0.3))
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 13.sp,
              color: isSelected ? const Color(0xFF4A5D4E) : const Color(0xFF64748B),
            ),
            SizedBox(width: 5.w),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 11.5.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF4A5D4E) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 2. SCANNER TAB (Web App 1:1)
  // ==========================================
  Widget _buildScannerTab(StoreLocation currentStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Viewfinder Card
        Container(
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
            children: [
              Text(
                'Live In-Store QR Scanner',
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 3.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.sp,
                    color: const Color(0xFF64748B),
                  ),
                  children: [
                    const TextSpan(text: 'Point your camera at any shelf QR tag in '),
                    TextSpan(
                      text: currentStore.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4A5D4E),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),

              // Viewfinder Display with animated laser line
              _buildViewfinderBox(),
              SizedBox(height: 14.h),

              // Camera Toggle Button
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => _isCameraActive = !_isCameraActive);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isCameraActive
                      ? const Color(0xFFF1F5F9)
                      : const Color(0xFF4A5D4E),
                  foregroundColor: _isCameraActive
                      ? const Color(0xFF0F172A)
                      : Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  elevation: 0,
                ),
                icon: Icon(
                  _isCameraActive ? LucideIcons.cameraOff : LucideIcons.camera,
                  size: 14.sp,
                ),
                label: Text(
                  _isCameraActive ? 'Pause Camera' : 'Start Camera',
                  style: GoogleFonts.outfit(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              SizedBox(height: 10.h),
              // Info Banner
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.info,
                      size: 13.sp,
                      color: const Color(0xFFD97706),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        'Point camera at shelf tag or click any quick shelf demo button below to test!',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.sp,
                          color: const Color(0xFF92400E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 14.h),
              const Divider(color: Color(0xFFE2E8F0)),
              SizedBox(height: 8.h),

              // Manual Code Input
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Or enter QR code / Barcode ID manually:',
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 36.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(999.r),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: TextField(
                        controller: _manualInputController,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5.sp,
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          hintText: 'e.g. QR-SNK-001 or QR-SM-001',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 11.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (val) => _scanCode(val),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () => _scanCode(_manualInputController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A5D4E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                    ),
                    child: Text(
                      'Scan',
                      style: GoogleFonts.outfit(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Quick Shelf Tags (Web App 1:1)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.tag,
                          size: 13.sp,
                          color: const Color(0xFF4A5D4E),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          'Quick Shelf Tags (Click to Test):',
                          style: GoogleFonts.outfit(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: DummyData.products.take(6).map((p) {
                        return GestureDetector(
                          onTap: () => _scanCode(p.qrCode),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999.r),
                              border: Border.all(color: const Color(0xFFCBD5E1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.qrCode,
                                  size: 10.sp,
                                  color: const Color(0xFF4A5D4E),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${p.name.split(" ")[0]} (${p.qrCode})',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF334155),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 14.h),

        // Scanned Product Card
        _scannedProduct != null
            ? _buildScannedProductCard(_scannedProduct!)
            : _buildEmptyScanPrompt(),
      ],
    );
  }

  // ==========================================
  // VIEWFINDER BOX WITH ANIMATED LASER
  // ==========================================
  Widget _buildViewfinderBox() {
    return Container(
      width: 230.w,
      height: 230.w,
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFF1E293B)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Center Icon / State
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.qrCode,
                  size: 48.sp,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                SizedBox(height: 8.h),
                Text(
                  _isCameraActive ? 'Scanner Active' : 'Camera Paused',
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

          // 4 Corner Brackets in Emerald
          // Top Left
          Positioned(
            top: 14.h,
            left: 14.w,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF34D399), width: 3.5),
                  left: BorderSide(color: Color(0xFF34D399), width: 3.5),
                ),
              ),
            ),
          ),
          // Top Right
          Positioned(
            top: 14.h,
            right: 14.w,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF34D399), width: 3.5),
                  right: BorderSide(color: Color(0xFF34D399), width: 3.5),
                ),
              ),
            ),
          ),
          // Bottom Left
          Positioned(
            bottom: 14.h,
            left: 14.w,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF34D399), width: 3.5),
                  left: BorderSide(color: Color(0xFF34D399), width: 3.5),
                ),
              ),
            ),
          ),
          // Bottom Right
          Positioned(
            bottom: 14.h,
            right: 14.w,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF34D399), width: 3.5),
                  right: BorderSide(color: Color(0xFF34D399), width: 3.5),
                ),
              ),
            ),
          ),

          // Animated Glowing Scan Laser Line
          if (_isCameraActive)
            AnimatedBuilder(
              animation: _laserAnimation,
              builder: (context, child) {
                return Positioned(
                  top: 230.w * _laserAnimation.value,
                  left: 16.w,
                  right: 16.w,
                  child: Container(
                    height: 2.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF34D399),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF34D399).withValues(alpha: 0.8),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ==========================================
  // SCANNED PRODUCT CARD (Web App 1:1)
  // ==========================================
  Widget _buildScannedProductCard(Product product) {
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
          // Header status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.check,
                      size: 12.sp,
                      color: const Color(0xFF047857),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Scanned Successfully!',
                      style: GoogleFonts.outfit(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF047857),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Tag: ${product.qrCode}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Product Image & Basic Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container in light sand #F4F0EB
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  width: 90.w,
                  height: 90.w,
                  color: const Color(0xFFF4F0EB),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF4A5D4E),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      product.name,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '₹${product.price.toInt()}',
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        if (product.originalPrice > product.price) ...[
                          SizedBox(width: 6.w),
                          Text(
                            '₹${product.originalPrice.toInt()}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.sp,
                              color: const Color(0xFF94A3B8),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'IN-STORE PRICE',
                            style: GoogleFonts.outfit(
                              fontSize: 8.5.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF047857),
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

          SizedBox(height: 10.h),

          // Aisle & Shelf Location Pill (Web App 1:1)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EEE7),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.mapPin,
                  size: 12.sp,
                  color: const Color(0xFF4A5D4E),
                ),
                SizedBox(width: 5.w),
                Text(
                  product.shelfLocation,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF4A5D4E),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h),
          Text(
            product.description,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5.sp,
              color: const Color(0xFF475569),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 14.h),

          // Action Buttons: Express Add to In-Store Cart & View Details
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    AppState.instance.addToCart(product);
                    setState(() => _isAddedToExpressCart = true);
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) {
                        setState(() => _isAddedToExpressCart = false);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAddedToExpressCart
                        ? const Color(0xFF047857)
                        : const Color(0xFF4A5D4E),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isAddedToExpressCart
                            ? LucideIcons.check
                            : LucideIcons.shoppingBag,
                        size: 15.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        _isAddedToExpressCart
                            ? 'Added to Express Cart!'
                            : 'Express Add to In-Store Cart',
                        style: GoogleFonts.outfit(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(product: product),
                    ),
                  );
                },
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9),
                  padding: EdgeInsets.all(12.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                icon: const Icon(
                  LucideIcons.externalLink,
                  color: Color(0xFF0F172A),
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // EMPTY SCAN PROMPT (Web App 1:1)
  // ==========================================
  Widget _buildEmptyScanPrompt() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFFCBD5E1),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                LucideIcons.qrCode,
                size: 24.sp,
                color: const Color(0xFF4A5D4E),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Ready to Scan Product',
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Scan any product's shelf barcode or click one of the quick test tags above to see instant aisle location & express self-checkout!",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.sp,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. CHOOSE BRANCH TAB (Web App 1:1 'wy')
  // ==========================================
  Widget _buildStoresListTab(StoreLocation activeStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Retail Store Locations',
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Select your physical retail branch to activate shelf navigation & express self-checkout',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5.sp,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),

        // List of Stores
        ...DummyData.stores.map((store) {
          final isSelected = activeStore.id == store.id;

          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF4A5D4E)
                    : const Color(0xFFE2E8F0),
                width: isSelected ? 1.8 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store Photo with Distance Badge
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
                      child: Image.network(
                        store.image,
                        height: 130.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Distance Badge (Top Right)
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(999.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          store.distance,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ),

                    // Active Store Badge (Bottom Left)
                    if (isSelected)
                      Positioned(
                        bottom: 10.h,
                        left: 10.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A5D4E),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.check, size: 11.sp, color: Colors.white),
                              SizedBox(width: 4.w),
                              Text(
                                'Active Store',
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

                // Content
                Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name,
                        style: GoogleFonts.outfit(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(LucideIcons.mapPin, size: 12.sp, color: const Color(0xFF4A5D4E)),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: Text(
                              store.address,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.sp,
                                color: const Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Icon(LucideIcons.clock, size: 12.sp, color: const Color(0xFF4A5D4E)),
                          SizedBox(width: 5.w),
                          Text(
                            store.timing,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.sp,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Select / Open Button
                      SizedBox(
                        width: double.infinity,
                        height: 36.h,
                        child: ElevatedButton(
                          onPressed: () {
                            AppState.instance.setSelectedStore(store);
                            setState(() => _activeTab = 'scanner');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? const Color(0xFF4A5D4E)
                                : const Color(0xFFF1F5F9),
                            foregroundColor: isSelected
                                ? Colors.white
                                : const Color(0xFF0F172A),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            isSelected ? 'Open QR Scanner' : 'Select Branch',
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
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
        }),
      ],
    );
  }
}
