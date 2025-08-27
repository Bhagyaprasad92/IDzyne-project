import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:idzyne/AttendanceOverviewScreen.dart';
import 'package:idzyne/home_screen.dart';
import 'package:idzyne/statistics.dart';
import 'package:idzyne/studentID.dart';
import 'package:idzyne/widgets/bug_report_dialog.dart';
import 'dart:convert';
import 'services/student_data.dart';
import 'login_signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idzyne/widgets/custom_bottom_navbar.dart';

Future<void> saveLoginState(String userId, String username) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
  await prefs.setString('username', username);
  await prefs.setBool('isLoggedIn', true);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String? username = prefs.getString('username');
  final String? loginUserId = prefs.getString('userId');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          isLoggedIn && username != null && loginUserId != null
              ? HomeScreen(userName: username, userId: loginUserId)
              : const LoginScreen(),
    ),
  );
}

