import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/theme.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isLoading;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
    this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: SizedBox(
          width: double.infinity,
          height: 56.h,
          child: widget.isOutlined
              ? OutlinedButton(
                  onPressed: widget.isLoading ? null : widget.onPressed,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: _buildChild(context),
                )
              : ElevatedButton(
                  onPressed: widget.isLoading ? null : widget.onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: _buildChild(context),
                ),
        ),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (widget.isLoading) {
      return SizedBox(
        height: 24.w,
        width: 24.w,
        child: CircularProgressIndicator(
          color: widget.isOutlined ? AppTheme.primaryColor : Colors.white,
          strokeWidth: 2.5,
        ),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, size: 20.sp, color: widget.isOutlined ? AppTheme.primaryColor : Colors.white),
          SizedBox(width: 8.w),
          Text(
            widget.text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: widget.isOutlined ? AppTheme.primaryColor : Colors.white,
            ),
          ),
        ],
      );
    }

    return Text(
      widget.text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: widget.isOutlined ? AppTheme.primaryColor : Colors.white,
      ),
    );
  }
}

