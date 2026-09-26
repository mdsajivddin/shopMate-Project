import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../core/dummy_data.dart';

class CustomerAuthModal extends StatefulWidget {
  const CustomerAuthModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CustomerAuthModal(),
    );
  }

  @override
  State<CustomerAuthModal> createState() => _CustomerAuthModalState();
}

class _CustomerAuthModalState extends State<CustomerAuthModal> {
  bool _isSignIn = true; // true: Sign In, false: Register
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController.text = 'vicky@example.com';
    _passwordController.text = '••••••••';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _autoFillDemo() {
    setState(() {
      _nameController.text = 'Vicky Sharma';
      _emailController.text = 'vicky.user@gmail.com';
      _phoneController.text = '+91 98765 43210';
      _passwordController.text = 'secret123';
      _errorMessage = null;
    });
  }

  void _handleSubmit() {
    setState(() => _errorMessage = null);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all required fields');
      return;
    }

    if (!_isSignIn && _nameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please enter your full name');
      return;
    }

    final profile = CustomerProfile(
      id: 'USR-${1000 + (DateTime.now().millisecondsSinceEpoch % 9000)}',
      name: _isSignIn ? 'Vicky Sharma' : _nameController.text.trim(),
      email: email,
      phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : '+91 98765 43210',
      avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=120&auto=format&fit=crop&q=80',
      badge: 'Verified Shopper',
    );

    AppState.instance.loginCustomer(profile);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Welcome back, ${profile.name}!',
          style: GoogleFonts.plusJakartaSans(fontSize: 12.sp),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 24.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar with Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 32),
                  // Center Icon
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.user,
                        color: AppTheme.primaryColor,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          LucideIcons.x,
                          size: 16.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Title & Subtitle (Exact Web App Copy)
              Center(
                child: Text(
                  _isSignIn ? 'Welcome Back' : 'Create an Account',
                  style: GoogleFonts.outfit(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF171717),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Center(
                child: Text(
                  _isSignIn
                      ? 'Sign in to access your orders and saved wishlist'
                      : 'Join ShopMate for exclusive deals & instant in-store checkout',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // 2-Tab Switcher: Sign In | Register
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isSignIn = true;
                          _errorMessage = null;
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: EdgeInsets.symmetric(vertical: 7.h),
                          decoration: BoxDecoration(
                            color: _isSignIn ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(999.r),
                            boxShadow: _isSignIn
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                                color: _isSignIn ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isSignIn = false;
                          _errorMessage = null;
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: EdgeInsets.symmetric(vertical: 7.h),
                          decoration: BoxDecoration(
                            color: !_isSignIn ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(999.r),
                            boxShadow: !_isSignIn
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Register',
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                                color: !_isSignIn ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Full Name (if Register)
              if (!_isSignIn) ...[
                Text(
                  'Full Name',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF334155),
                  ),
                ),
                SizedBox(height: 5.h),
                _buildField(
                  controller: _nameController,
                  icon: LucideIcons.user,
                  hint: 'John Doe',
                ),
                SizedBox(height: 12.h),
              ],

              // Email Address
              Text(
                'Email Address',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF334155),
                ),
              ),
              SizedBox(height: 5.h),
              _buildField(
                controller: _emailController,
                icon: LucideIcons.mail,
                hint: 'vicky@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12.h),

              // Mobile Phone (if Register)
              if (!_isSignIn) ...[
                Text(
                  'Mobile Phone (Optional)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF334155),
                  ),
                ),
                SizedBox(height: 5.h),
                _buildField(
                  controller: _phoneController,
                  icon: LucideIcons.phone,
                  hint: '+91 98765 43210',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 12.h),
              ],

              // Password
              Text(
                'Password',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF334155),
                ),
              ),
              SizedBox(height: 5.h),
              _buildField(
                controller: _passwordController,
                icon: LucideIcons.lock,
                hint: '••••••••',
                isPassword: true,
              ),

              if (_errorMessage != null) ...[
                SizedBox(height: 10.h),
                Text(
                  _errorMessage!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5.sp,
                    color: const Color(0xFFEF4444),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              SizedBox(height: 18.h),

              // Submit Button
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isSignIn ? 'Sign In' : 'Create Account',
                      style: GoogleFonts.outfit(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(LucideIcons.arrowRight, size: 15.sp),
                  ],
                ),
              ),

              SizedBox(height: 14.h),

              // "Auto-fill Demo Credentials" Button (Exact Web App Feature)
              Center(
                child: TextButton.icon(
                  onPressed: _autoFillDemo,
                  icon: Icon(
                    LucideIcons.wandSparkles,
                    size: 13.sp,
                    color: AppTheme.primaryColor,
                  ),
                  label: Text(
                    'Auto-fill Demo Credentials',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12.5.sp,
          color: const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
          prefixIcon: Icon(icon, size: 16.sp, color: const Color(0xFF94A3B8)),
          hintText: hint,
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12.sp,
            color: const Color(0xFF94A3B8),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
