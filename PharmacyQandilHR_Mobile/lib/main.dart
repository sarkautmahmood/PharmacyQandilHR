import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'views/auth/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PharmacyQandilApp());
}

class PharmacyQandilApp extends StatelessWidget {
  const PharmacyQandilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'دەرمانخانەی قەندیل HR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // RTL Kurdish & Arabic compatibility
      locale: const Locale('ar', 'IQ'),
      supportedLocales: const [
        Locale('ar', 'IQ'),
        Locale('fa', 'IR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        return const Locale('ar', 'IQ');
      },
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // Right-to-Left for Kurdish
          child: child ?? const SizedBox(),
        );
      },
      home: const LoginScreen(),
    );
  }
}