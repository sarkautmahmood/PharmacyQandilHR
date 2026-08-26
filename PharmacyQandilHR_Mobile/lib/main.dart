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
      
      // Multilingual & RTL Configuration
      locale: const Locale('ckb', 'IQ'), // Kurdish Sorani
      supportedLocales: const [
        Locale('ckb', 'IQ'), // Kurdish
        Locale('ar', 'IQ'),  // Arabic
        Locale('en', 'US'),  // English
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // Right-to-Left for Kurdish
          child: child!,
        );
      },
      home: const LoginScreen(),
    );
  }
}
