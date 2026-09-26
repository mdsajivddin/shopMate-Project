import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme.dart';
import 'screens/main_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set design size based on standard mobile dimensions (e.g., iPhone 13 Pro 390x844)
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'ShopMate — Discover The Best Products For You',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const MainWrapper(),
        );
      },
    );
  }
}
