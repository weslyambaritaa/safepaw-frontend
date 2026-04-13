import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'utils/app_colors.dart';

void main() async {
  // Wajib ditambahkan jika main() bersifat async
  WidgetsFlutterBinding.ensureInitialized();

  // Cek apakah user sudah punya token
  String? token = await AuthService.getToken();

  runApp(SafePawApp(isLoggedIn: token != null));
}

class SafePawApp extends StatelessWidget {
  final bool isLoggedIn;
  const SafePawApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafePaw',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      // Tentukan halaman awal berdasarkan status login
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}