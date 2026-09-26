import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/dummy_data.dart';
import 'seller_dashboard_screen.dart';

class SellerLoginModal extends StatefulWidget {
  const SellerLoginModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SellerLoginModal(),
    );
  }

  @override
  State<SellerLoginModal> createState() => _SellerLoginModalState();
}

class _SellerLoginModalState extends State<SellerLoginModal> {
  int _selectedTabIndex = 0; // 0: Store Owner, 1: Shop Employee, 2: Register Shop
  bool _isLoading = false;
  String _category = 'Fashion & Footwear';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = 'seller@shopmate.in';
    _passwordController.text = '••••••••';
    _phoneController.text = '+91 98765 43210';
    _shopNameController.text = 'Urban Threads Co.';
    _ownerNameController.text = 'Rajesh Sharma';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _shopNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
      if (index == 0) {
        _emailController.text = 'rajesh.sharma@urbanthreads.in';
      } else if (index == 1) {
        _emailController.text = 'rahul.cashier@urbanthreads.in';
      } else {
        _emailController.text = 'seller@shopmate.in';
      }
    });
  }

  Future<void> _loginWithPersona(VendorPersona persona) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    AppState.instance.loginAsVendorPersona(persona);
    setState(() => _isLoading = false);

    Navigator.pop(context); // Close modal

    // Show toast
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle2, color: Color(0xFF34D399), size: 18),
            const SizedBox(width: 8),
            Text(
              'Welcome ${persona.name}! Logged in as ${persona.role}',
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
        duration: const Duration(milliseconds: 2500),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SellerDashboardScreen(),
      ),
    );
  }

  Future<void> _submitForm() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    VendorPersona targetPersona;
    if (_selectedTabIndex == 1) {
      targetPersona = DummyData.vendorPersonas[1]; // Cashier Staff
    } else {
      targetPersona = DummyData.vendorPersonas[0]; // Store Owner
    }

    AppState.instance.loginAsVendorPersona(targetPersona);
    setState(() => _isLoading = false);

    Navigator.pop(context);

    // Show toast
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle2, color: Color(0xFF34D399), size: 18),
            const SizedBox(width: 8),
            Text(
              _selectedTabIndex == 2
                  ? 'Shop "${_shopNameController.text.trim().isEmpty ? "Urban Threads" : _shopNameController.text.trim()}" Registered Successfully!'
                  : 'Welcome! Accessing ${targetPersona.role} Portal',
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
        duration: const Duration(milliseconds: 2500),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SellerDashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. TOP HEADER BANNER (Dark navy gradient with pink icon matching Screenshot 2)
              _buildHeaderBanner(),

              // 2. MODAL BODY
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1-Click Fast Demo Personas section
                    Text(
                      '1-CLICK FAST DEMO PERSONAS:',
                      style: GoogleFonts.outfit(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF94A3B8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // 3 Persona Cards matching Screenshot 2
                    _buildPersonaCard(
                      persona: DummyData.vendorPersonas[0],
                      subtitleColor: const Color(0xFF64748B),
                    ),
                    SizedBox(height: 8.h),
                    _buildPersonaCard(
                      persona: DummyData.vendorPersonas[1],
                      subtitleColor: const Color(0xFF059669),
                    ),
                    SizedBox(height: 8.h),
                    _buildPersonaCard(
                      persona: DummyData.vendorPersonas[2],
                      subtitleColor: const Color(0xFF6366F1),
                    ),

                    SizedBox(height: 20.h),

                    // Divider: "OR SIGN IN WITH EMAIL"
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            'OR SIGN IN WITH EMAIL',
                            style: GoogleFonts.outfit(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF94A3B8),
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
                        ),
                      ],
                    ),

                    SizedBox(height: 18.h),

                    // Registration extra fields if tab 2
                    if (_selectedTabIndex == 2) ...[
                      Text(
                        'Shop / Store Name',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF334155),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      _buildTextField(
                        controller: _shopNameController,
                        icon: LucideIcons.store,
                        hint: 'e.g. Zara Boutique',
                      ),
                      SizedBox(height: 12.h),

                      Text(
                        'Owner Name',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF334155),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      _buildTextField(
                        controller: _ownerNameController,
                        icon: LucideIcons.user,
                        hint: 'Full Name',
                      ),
                      SizedBox(height: 12.h),

                      Text(
                        'Phone',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF334155),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      _buildTextField(
                        controller: _phoneController,
                        icon: LucideIcons.phone,
                        hint: '+91 98765 43210',
                      ),
                      SizedBox(height: 12.h),

                      Text(
                        'Category',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF334155),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 44.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFCBD5E1),
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _category,
                            isExpanded: true,
                            icon: Icon(
                              LucideIcons.chevronDown,
                              size: 16.sp,
                              color: const Color(0xFF64748B),
                            ),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5.sp,
                              color: const Color(0xFF0F172A),
                              fontWeight: FontWeight.w600,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Fashion & Footwear',
                                child: Text('Fashion & Footwear'),
                              ),
                              DropdownMenuItem(
                                value: 'Electronics & Tech',
                                child: Text('Electronics & Tech'),
                              ),
                              DropdownMenuItem(
                                value: 'Home & Kitchen',
                                child: Text('Home & Kitchen'),
                              ),
                              DropdownMenuItem(
                                value: 'Sports & Gear',
                                child: Text('Sports & Gear'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _category = val);
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],

                    // Email Field
                    Text(
                      _selectedTabIndex == 1 ? 'Employee Email' : 'Vendor Email',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _buildTextField(
                      controller: _emailController,
                      icon: LucideIcons.mail,
                      hint: 'vendor@business.com',
                    ),

                    SizedBox(height: 12.h),

                    // Password Field
                    Text(
                      _selectedTabIndex == 1 ? 'PIN / Password (e.g. 1234)' : 'Password',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _buildTextField(
                      controller: _passwordController,
                      icon: LucideIcons.lock,
                      hint: '••••••••',
                      isObscure: true,
                    ),

                    SizedBox(height: 20.h),

                    // Pink CTA Button matching Screenshot 2
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE11D48), // Vibrant pink
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _selectedTabIndex == 0
                                        ? 'Access Owner Portal'
                                        : _selectedTabIndex == 1
                                            ? 'Sign In as Employee'
                                            : 'Register & Open Portal',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Icon(LucideIcons.arrowRight, size: 16.sp),
                                ],
                              ),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    // Footer security badge
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.shieldCheck,
                            size: 13.sp,
                            color: const Color(0xFF10B981),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Permission Protected Access • ShopMate 2.0',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    String title = 'Store Owner Login';
    String subtitle = 'Access your merchant dashboard, counter POS billing, inventory variants, and staff permissions.';

    if (_selectedTabIndex == 1) {
      title = 'Shop Employee Sign In';
      subtitle = 'Sign in as a staff member with your assigned permissions (POS, Inventory, Orders).';
    } else if (_selectedTabIndex == 2) {
      title = 'Register New Shop';
      subtitle = 'Launch your merchant store, counter POS billing, and start managing inventory variants.';
    }

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 16.w, 18.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F172A), // Dark slate
            Color(0xFF1E1B4B), // Deep indigo
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close button & Small badge row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.sparkles,
                      size: 11.sp,
                      color: const Color(0xFFFB7185),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'SHOPMATE SELLER PORTAL',
                      style: GoogleFonts.outfit(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFB7185),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      LucideIcons.x,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Pink Icon + Title Row
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFF43F5E), // Rose
                      Color(0xFFEC4899), // Pink
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF43F5E).withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.store,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 6.h),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5.sp,
              color: const Color(0xFFCBD5E1),
              height: 1.35,
            ),
          ),

          SizedBox(height: 14.h),

          // 3 TABS PILL BAR matching Screenshot 2: Store Owner | Shop Employee | Register Shop
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                _buildTabItem(0, 'Store Owner'),
                _buildTabItem(1, 'Shop Employee'),
                _buildTabItem(2, 'Register Shop'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final isSelected = _selectedTabIndex == index;
    // In webapp: employee active is pink (bg-pink-500 text-white), owner/register active is white (bg-white text-slate-900)
    final Color activeBg = index == 1 ? const Color(0xFFEC4899) : Colors.white;
    final Color activeText = index == 1 ? Colors.white : const Color(0xFF0F172A);

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(999.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11.5.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? activeText : const Color(0xFFCBD5E1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonaCard({
    required VendorPersona persona,
    required Color subtitleColor,
  }) {
    return GestureDetector(
      onTap: () => _loginWithPersona(persona),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: persona.iconColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  persona.icon,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    persona.role,
                    style: GoogleFonts.outfit(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    persona.subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 16.sp,
              color: const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isObscure = false,
  }) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFCBD5E1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Icon(
              icon,
              size: 16.sp,
              color: const Color(0xFF94A3B8),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isObscure,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5.sp,
                color: const Color(0xFF0F172A),
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5.sp,
                  color: const Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
