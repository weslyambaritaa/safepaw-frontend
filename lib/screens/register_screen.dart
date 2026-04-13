import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart'; // Pastikan path ini sesuai dengan lokasi file AuthService Anda

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 1. Inisialisasi Controller untuk menangkap teks input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. Status pilihan role
  String _selectedRole = 'owner';

  // 3. Status loading untuk mencegah klik tombol berkali-kali
  bool _isLoading = false;

  // 4. Praktik Terbaik: Selalu bersihkan controller saat halaman dihancurkan
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk memproses pendaftaran
  Future<void> _handleRegister() async {
    // Validasi sederhana agar form tidak kosong
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom harus diisi!')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Nyalakan animasi loading
    });

    // Panggil API ke backend Golang
    bool success = await AuthService.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
      _selectedRole,
    );

    setState(() {
      _isLoading = false; // Matikan animasi loading
    });

    if (success) {
      // Jika server membalas 201 Created
      if (mounted) { // Pengecekan mounted wajib jika menggunakan context setelah await
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pendaftaran Berhasil! Silakan Login.')),
        );
        Navigator.pop(context); // Kembali ke halaman Login
      }
    } else {
      // Jika gagal (misal: email sudah dipakai)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pendaftaran Gagal. Email mungkin sudah ada atau format salah.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Buat Akun Baru',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bergabunglah dengan komunitas SafePaw',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),

              // TextField Nama Lengkap
              TextField(
                controller: _nameController, // Pasang controller di sini
                decoration: InputDecoration(
                  hintText: 'Nama Lengkap',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
              ),
              const SizedBox(height: 16),

              // TextField Email
              TextField(
                controller: _emailController, // Pasang controller di sini
                keyboardType: TextInputType.emailAddress, // Mengubah keyboard ke format email
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
              ),
              const SizedBox(height: 16),

              // TextField Password
              TextField(
                controller: _passwordController, // Pasang controller di sini
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
              ),
              const SizedBox(height: 24),

              // Pilihan Role (Owner / Sitter)
              const Text(
                'Daftar sebagai:',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Pemilik Hewan', style: TextStyle(fontSize: 14)),
                      value: 'owner',
                      groupValue: _selectedRole,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Pet Sitter', style: TextStyle(fontSize: 14)),
                      value: 'sitter',
                      groupValue: _selectedRole,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Tombol Daftar
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister, // Matikan tombol jika sedang loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                // Ubah tampilan tombol jika sedang loading
                child: _isLoading
                    ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                )
                    : const Text(
                  'Daftar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}