import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/dummy_data.dart';
import '../main_wrapper.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Step: 1 = Shipping, 2 = Payment, 3 = Processing, 4 = Success (Web App 1:1)
  int _currentStep = 1;

  // Step 1: Shipping Form (Pre-filled with Vicky Sharma)
  final TextEditingController _fullNameController =
      TextEditingController(text: 'Vicky Sharma');
  final TextEditingController _phoneController =
      TextEditingController(text: '+91 98765 43210');
  final TextEditingController _emailController =
      TextEditingController(text: 'vicky@example.com');
  final TextEditingController _addressController =
      TextEditingController(text: '450 Grand Avenue, Level 2, Suite 210');
  final TextEditingController _cityController =
      TextEditingController(text: 'Downtown Center');
  final TextEditingController _pincodeController =
      TextEditingController(text: '110001');

  String _deliveryType = 'standard'; // 'standard' or 'express'

  // Step 2: Payment Method ('upi', 'card', 'netbanking', 'cod')
  String _paymentMethod = 'upi';

  // Card Form
  final TextEditingController _cardNumberController =
      TextEditingController(text: '4532 •••• •••• 8921');
  final TextEditingController _cardHolderController =
      TextEditingController(text: 'Vicky Sharma');
  final TextEditingController _cardExpiryController =
      TextEditingController(text: '08/29');
  final TextEditingController _cardCvvController =
      TextEditingController(text: '821');

  // NetBanking Selected Bank
  String _selectedBank = 'HDFC Bank';

  // Copy indicator for UPI ID
  bool _isUpiCopied = false;

  // Placed Order Info for Step 4
  CustomerOrder? _placedOrder;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();

    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }

  // Calculate Payable Amount
  double _calculateTotalAmount() {
    final subtotal = AppState.instance.subtotal;
    final discount = AppState.instance.discountAmount;

    // Delivery Fee
    double deliveryFee = 0.0;
    if (_deliveryType == 'express') {
      deliveryFee = 199.0;
    } else {
      deliveryFee = (subtotal >= 999 || (AppState.instance.appliedCoupon?.isFreeShipping ?? false))
          ? 0.0
          : 99.0;
    }

    return (subtotal - discount + deliveryFee).clamp(0.0, double.infinity);
  }

  void _processPayment() {
    setState(() => _currentStep = 3);

    // Simulate 1.8s payment processing (Web App 1:1)
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;

      final total = _calculateTotalAmount();
      final orderId = 'ORD-${10000 + Random().nextInt(89999)}';

      String paymentLabel = 'UPI (Instant Scan)';
      if (_paymentMethod == 'card') {
        paymentLabel = 'Card Ending in •••• 8921';
      } else if (_paymentMethod == 'netbanking') {
        paymentLabel = 'NetBanking ($_selectedBank)';
      } else if (_paymentMethod == 'cod') {
        paymentLabel = 'Cash on Delivery';
      }

      final items = AppState.instance.cart.map((c) {
        return CustomerOrderItem(
          id: c.product.id,
          name: c.product.name,
          image: c.product.image,
          price: c.product.price,
          quantity: c.quantity,
        );
      }).toList();

      final newOrder = CustomerOrder(
        orderId: orderId,
        date: 'Just now',
        totalAmount: total,
        paymentMethod: paymentLabel,
        status: 'Delivered',
        city: _cityController.text.trim().isNotEmpty
            ? _cityController.text.trim()
            : 'Downtown Center',
        items: items,
      );

      // Save to order history & clear cart
      AppState.instance.addCustomerOrder(newOrder);
      AppState.instance.clearCart();

      setState(() {
        _placedOrder = newOrder;
        _currentStep = 4;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _calculateTotalAmount();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Column(
            children: [
              // Main Interactive Card
              Container(
                width: double.infinity,
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
                child: _buildCurrentStepContent(totalAmount),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: _currentStep == 3 || _currentStep == 4
          ? null
          : IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF171717)),
              onPressed: () {
                if (_currentStep == 2) {
                  setState(() => _currentStep = 1);
                } else {
                  Navigator.pop(context);
                }
              },
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
              LucideIcons.creditCard,
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
              'CHECKOUT',
              style: GoogleFonts.outfit(
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF4A5D4E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent(double totalAmount) {
    switch (_currentStep) {
      case 1:
        return _buildStep1Shipping(totalAmount);
      case 2:
        return _buildStep2Payment(totalAmount);
      case 3:
        return _buildStep3Processing();
      case 4:
        return _buildStep4Success();
      default:
        return const SizedBox.shrink();
    }
  }

  // ==========================================
  // STEP 1: SHIPPING & DELIVERY DETAILS (Web App 1:1)
  // ==========================================
  Widget _buildStep1Shipping(double totalAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step Indicator Pill
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE6EEE7),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            'STEP 1 OF 2',
            style: GoogleFonts.outfit(
              fontSize: 10.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF4A5D4E),
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Shipping & Delivery Details',
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Where should we deliver your order?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.sp,
            color: const Color(0xFF64748B),
          ),
        ),
        const Divider(color: Color(0xFFF1F5F9), height: 24),

        // Full Name & Phone
        _buildTextField('Full Name', _fullNameController, 'e.g. Vicky Sharma'),
        SizedBox(height: 12.h),
        _buildTextField('Mobile Phone', _phoneController, '+91 98765 43210', keyboardType: TextInputType.phone),
        SizedBox(height: 12.h),
        _buildTextField('Email Address', _emailController, 'vicky@example.com', keyboardType: TextInputType.emailAddress),
        SizedBox(height: 12.h),
        _buildTextField('Street Address', _addressController, 'Apartment, building, street, area'),
        SizedBox(height: 12.h),

        // City & Pin Code (2 Columns)
        Row(
          children: [
            Expanded(
              child: _buildTextField('City / Region', _cityController, 'City'),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildTextField('Pin Code / Zip', _pincodeController, '110001', keyboardType: TextInputType.number),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Delivery Speed Selector
        Text(
          'DELIVERY SPEED',
          style: GoogleFonts.outfit(
            fontSize: 11.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8.h),

        Row(
          children: [
            // Standard
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _deliveryType = 'standard'),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: _deliveryType == 'standard'
                        ? const Color(0xFFE6EEE7).withValues(alpha: 0.5)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: _deliveryType == 'standard'
                          ? const Color(0xFF4A5D4E)
                          : const Color(0xFFE2E8F0),
                      width: _deliveryType == 'standard' ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Standard Shipping',
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '2 - 4 Business Days',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        AppState.instance.subtotal >= 999 ? 'FREE' : '₹99',
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF047857),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),

            // Express Priority
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _deliveryType = 'express'),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: _deliveryType == 'express'
                        ? const Color(0xFFE6EEE7).withValues(alpha: 0.5)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: _deliveryType == 'express'
                          ? const Color(0xFF4A5D4E)
                          : const Color(0xFFE2E8F0),
                      width: _deliveryType == 'express' ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Express Priority ⚡',
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Same / Next Day',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '₹199',
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF4A5D4E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 22.h),

        // Continue to Payment Button
        SizedBox(
          width: double.infinity,
          height: 44.h,
          child: ElevatedButton(
            onPressed: () {
              if (_fullNameController.text.trim().isEmpty ||
                  _phoneController.text.trim().isEmpty ||
                  _addressController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please complete all shipping fields')),
                );
                return;
              }
              setState(() => _currentStep = 2);
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
                  'Continue to Payment (₹${totalAmount.toInt()})',
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(LucideIcons.arrowRight, size: 15.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // STEP 2: CHOOSE PAYMENT METHOD (Web App 1:1)
  // ==========================================
  Widget _buildStep2Payment(double totalAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back link
        GestureDetector(
          onTap: () => setState(() => _currentStep = 1),
          child: Row(
            children: [
              Icon(LucideIcons.arrowLeft, size: 13.sp, color: const Color(0xFF4A5D4E)),
              SizedBox(width: 4.w),
              Text(
                'Back to Shipping',
                style: GoogleFonts.outfit(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF4A5D4E),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),

        Text(
          'Choose Payment Method',
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 2.h),
        RichText(
          text: TextSpan(
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.sp,
              color: const Color(0xFF64748B),
            ),
            children: [
              const TextSpan(text: 'Total payable amount: '),
              TextSpan(
                text: '₹${totalAmount.toInt()}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),

        const Divider(color: Color(0xFFF1F5F9), height: 22),

        // 4 Payment Tabs Grid (Web App 1:1)
        Row(
          children: [
            Expanded(child: _buildPaymentTabPill('upi', 'UPI / QR', LucideIcons.qrCode)),
            SizedBox(width: 6.w),
            Expanded(child: _buildPaymentTabPill('card', 'Card', LucideIcons.creditCard)),
            SizedBox(width: 6.w),
            Expanded(child: _buildPaymentTabPill('netbanking', 'NetBanking', LucideIcons.landmark)),
            SizedBox(width: 6.w),
            Expanded(child: _buildPaymentTabPill('cod', 'COD', LucideIcons.banknote)),
          ],
        ),

        SizedBox(height: 16.h),

        // Payment Tab Details
        if (_paymentMethod == 'upi') ...[
          _buildUpiPaymentContent(totalAmount),
        ] else if (_paymentMethod == 'card') ...[
          _buildCardPaymentContent(),
        ] else if (_paymentMethod == 'netbanking') ...[
          _buildNetBankingContent(),
        ] else ...[
          _buildCodContent(),
        ],

        SizedBox(height: 20.h),

        // Pay & Complete Order Button
        SizedBox(
          width: double.infinity,
          height: 44.h,
          child: ElevatedButton(
            onPressed: _processPayment,
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
                Icon(LucideIcons.shieldCheck, size: 16.sp),
                SizedBox(width: 8.w),
                Text(
                  'Pay ₹${totalAmount.toInt()} & Complete Order',
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTabPill(String id, String label, IconData icon) {
    final isSelected = _paymentMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = id),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE6EEE7)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4A5D4E)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? const Color(0xFF4A5D4E) : const Color(0xFF64748B),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10.5.sp,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color: isSelected ? const Color(0xFF4A5D4E) : const Color(0xFF475569),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpiPaymentContent(double totalAmount) {
    final qrUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=upi://pay?pa=shopmate@upi&pn=ShopMate&am=${totalAmount.toStringAsFixed(2)}';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(
            'Scan UPI QR Code to Pay',
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Google Pay • PhonePe • Paytm • BHIM',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5.sp,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 12.h),

          // Live QR Image
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFCBD5E1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Image.network(
              qrUrl,
              width: 140.w,
              height: 140.w,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                width: 140.w,
                height: 140.w,
                color: const Color(0xFFF1F5F9),
                child: const Center(
                  child: Icon(LucideIcons.qrCode, color: Colors.grey, size: 40),
                ),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // UPI ID copy pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'shopmate@upi',
                  style: GoogleFonts.robotoMono(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(const ClipboardData(text: 'shopmate@upi'));
                    setState(() => _isUpiCopied = true);
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) setState(() => _isUpiCopied = false);
                    });
                  },
                  child: Icon(
                    _isUpiCopied ? LucideIcons.check : LucideIcons.copy,
                    size: 13.sp,
                    color: _isUpiCopied ? const Color(0xFF047857) : const Color(0xFF4A5D4E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardPaymentContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('Card Number', _cardNumberController, '•••• •••• •••• ••••'),
          SizedBox(height: 10.h),
          _buildTextField('Cardholder Name', _cardHolderController, 'Full Name on Card'),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _buildTextField('Expiry Date', _cardExpiryController, 'MM/YY'),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildTextField('CVV', _cardCvvController, '•••', obscureText: true),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(LucideIcons.lock, size: 12.sp, color: const Color(0xFF047857)),
              SizedBox(width: 6.w),
              Text(
                '256-Bit SSL Encrypted & Bank-Grade Security',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5.sp,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetBankingContent() {
    final banks = [
      'HDFC Bank',
      'State Bank of India (SBI)',
      'ICICI Bank',
      'Axis Bank',
      'Kotak Mahindra Bank',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SELECT YOUR BANK',
            style: GoogleFonts.outfit(
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedBank,
                items: banks.map((b) {
                  return DropdownMenuItem<String>(
                    value: b,
                    child: Text(
                      b,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedBank = val);
                },
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'You will be redirected to your bank\'s secure authorization portal.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5.sp,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              LucideIcons.banknote,
              size: 22.sp,
              color: const Color(0xFFB45309),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash on Delivery Available',
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Pay via cash or UPI QR directly to the delivery executive at your doorstep upon receiving the package.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.sp,
                    color: const Color(0xFF64748B),
                    height: 1.4,
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
  // STEP 3: VERIFYING & PROCESSING STATE (Web App 1:1)
  // ==========================================
  Widget _buildStep3Processing() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 12.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 52.w,
            height: 52.w,
            child: const CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A5D4E)),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Verifying & Processing Payment...',
            style: GoogleFonts.outfit(
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Text(
            'Please do not refresh or press back.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.sp,
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STEP 4: ORDER PLACED SUCCESSFULLY 🎉 (Web App 1:1)
  // ==========================================
  Widget _buildStep4Success() {
    final order = _placedOrder;
    if (order == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Green Checkmark Icon
        Container(
          width: 64.w,
          height: 64.w,
          decoration: const BoxDecoration(
            color: Color(0xFFECFDF5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              LucideIcons.check,
              size: 34.sp,
              color: const Color(0xFF047857),
            ),
          ),
        ),
        SizedBox(height: 14.h),

        Text(
          'Order Placed Successfully! 🎉',
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          'Receipt and tracking updates sent to ${_emailController.text.trim()}.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5.sp,
            color: const Color(0xFF64748B),
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 16.h),

        // Receipt Summary Box (Web App 1:1)
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              _buildReceiptLine('Order Reference', order.orderId, isMono: true),
              const Divider(color: Color(0xFFE2E8F0), height: 16),
              _buildReceiptLine('Payment Method', order.paymentMethod),
              SizedBox(height: 6.h),
              _buildReceiptLine('Deliver To', order.city),
              const Divider(color: Color(0xFFE2E8F0), height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Paid',
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '₹${order.totalAmount.toInt()}',
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF4A5D4E),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 20.h),

        // Continue Shopping Button
        SizedBox(
          width: double.infinity,
          height: 44.h,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainWrapper()),
                (route) => false,
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
            child: Text(
              'Continue Shopping',
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptLine(String label, String value, {bool isMono = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.sp,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: isMono
              ? GoogleFonts.robotoMono(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                )
              : GoogleFonts.plusJakartaSans(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF475569),
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          height: 38.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8.h),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 11.sp,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
