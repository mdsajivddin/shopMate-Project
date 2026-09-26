import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            SizedBox(height: 16.h),
            _buildListTile(
              title: 'Change Password', 
              icon: LucideIcons.lock,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen())),
            ),
            _buildListTile(title: 'Language', icon: LucideIcons.globe, trailingText: 'English (US)'),
            _buildListTile(title: 'Currency', icon: LucideIcons.dollarSign, trailingText: 'USD (\$)'),
            
            SizedBox(height: 32.h),
            Text('Preferences', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            SizedBox(height: 16.h),
            _buildSwitchTile(
              title: 'Push Notifications',
              icon: LucideIcons.bell,
              value: _pushNotifications,
              onChanged: (val) => setState(() => _pushNotifications = val),
            ),
            _buildSwitchTile(
              title: 'Email Notifications',
              icon: LucideIcons.mail,
              value: _emailNotifications,
              onChanged: (val) => setState(() => _emailNotifications = val),
            ),
            _buildSwitchTile(
              title: 'Dark Mode',
              icon: LucideIcons.moon,
              value: _darkMode,
              onChanged: (val) => setState(() => _darkMode = val),
            ),

            SizedBox(height: 32.h),
            Text('Legal', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            SizedBox(height: 16.h),
            _buildListTile(title: 'Privacy Policy', icon: LucideIcons.shield),
            _buildListTile(title: 'Terms of Service', icon: LucideIcons.fileText),
            _buildListTile(title: 'About Us', icon: LucideIcons.info),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({required String title, required IconData icon, String? trailingText, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
        child: Icon(icon, color: AppTheme.textSecondary, size: 20.sp),
      ),
      title: Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Text(trailingText, style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary)),
            SizedBox(width: 8.w),
          ],
          Icon(LucideIcons.chevronRight, size: 20.sp, color: Colors.grey),
        ],
      ),
      onTap: onTap ?? () {},
    );
  }

  Widget _buildSwitchTile({required String title, required IconData icon, required bool value, required Function(bool) onChanged}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
        child: Icon(icon, color: AppTheme.textSecondary, size: 20.sp),
      ),
      title: Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }
}
