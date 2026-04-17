import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'onboarding_screen.dart';
import 'login_page.dart';
import 'services/notification_service.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);
  tz.initializeTimeZones();

  runApp(const MyApp());

  Future.microtask(() async {
    await NotificationService.init();
    await NotificationService.setupDailyReminders();
  });
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Map<String, dynamic>> checkStart() async {
    final prefs = await SharedPreferences.getInstance();

    final firstOpen = prefs.getBool("first_open") ?? true;
    final userEmail = prefs.getString("user_email");

    return {
      "firstOpen": firstOpen,
      "userEmail": userEmail,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: FutureBuilder<Map<String, dynamic>>(
        future: checkStart(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final data = snapshot.data!;
          final firstOpen = data["firstOpen"];
          final userEmail = data["userEmail"];

          // 🔥 1. FIRST OPEN → onboarding
          if (firstOpen) {
            return const OnboardingScreen();
          }

          // 🔥 2. SUDAH LOGIN → langsung masuk HOME
          if (userEmail != null) {
            return HomePage(email: userEmail);
          }

          // 🔥 3. BELUM LOGIN → login page
          return const LoginPage();
        },
      ),
    );
  }
}