import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart'; // Import service untuk memanggil fungsi logout
import 'login_screen.dart'; // Import halaman login untuk tujuan navigasi

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('SafePaw Home', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.primary),
            onPressed: () async {
              await AuthService.logout(); // Hapus token dari memori

              // Pengecekan context.mounted wajib dilakukan di dalam fungsi async
              // sebelum melakukan aksi yang berkaitan dengan UI (seperti navigasi)
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false, // false berarti hapus semua tumpukan layar sebelumnya
                );
              }
            },
          )
        ],
      ),
      body: const Center(
        child: Text(
          'Selamat Datang di SafePaw! 🐶',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}