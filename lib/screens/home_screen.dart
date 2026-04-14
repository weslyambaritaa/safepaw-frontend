import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'bidding_room_screen.dart';
import 'find_sitter_screen.dart'; // Import layar pencarian sitter baru
import 'create_request_screen.dart'; // Tambahkan baris ini

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
              await AuthService.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
              }
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                  'Selamat Datang di SafePaw! 🐶',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)
              ),
              const SizedBox(height: 32),

              // Tombol Bidding (Alur Lama)
              ElevatedButton.icon(
                icon: const Icon(Icons.gavel),
                label: const Text('Masuk Ruang Lelang (Pesanan #1)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BiddingRoomScreen(petRequestId: 1)),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Tombol Cari Sitter (Alur Baru)
              // Ganti bagian tombol di home_screen.dart menjadi ini:
              ElevatedButton.icon(
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Buat Pesanan Penitipan Baru'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateRequestScreen()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}