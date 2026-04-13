import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Tambahkan ini untuk deteksi Web
import 'package:image_picker/image_picker.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedRole = 'owner';
  bool _isLoading = false;

  // UBAH: Gunakan XFile dari image_picker agar aman di Web
  XFile? _ktpFile;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _ktpFile = pickedFile; // Simpan sebagai XFile
      });
    }
  }

  Future<void> _handleRegister() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua kolom teks harus diisi!')));
      return;
    }

    if (_selectedRole == 'sitter' && _ktpFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sitter wajib mengunggah foto KTP untuk verifikasi.')));
      return;
    }

    setState(() => _isLoading = true);

    bool success = await AuthService.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
      _selectedRole,
      ktpFile: _ktpFile, // Kirim XFile
    );

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_selectedRole == 'sitter'
                ? 'Pendaftaran Berhasil! Menunggu verifikasi Admin.'
                : 'Pendaftaran Berhasil! Silakan Login.'),
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pendaftaran Gagal. Format salah atau Error Server.')));
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
              const Text('Buat Akun Baru', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text('Bergabunglah dengan komunitas SafePaw', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 32),

              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Nama Lengkap', filled: true, fillColor: AppColors.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20)),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Email', filled: true, fillColor: AppColors.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20)),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password', filled: true, fillColor: AppColors.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20)),
              ),
              const SizedBox(height: 24),

              const Text('Daftar sebagai:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
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
                      onChanged: (value) => setState(() => _selectedRole = value!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Pet Sitter', style: TextStyle(fontSize: 14)),
                      value: 'sitter',
                      groupValue: _selectedRole,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primary,
                      onChanged: (value) => setState(() => _selectedRole = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // AREA FORM KTP
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _selectedRole == 'sitter' ? 160 : 0,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Verifikasi Identitas (Wajib)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5, strokeAlign: BorderSide.strokeAlignInside),
                          ),
                          child: _ktpFile == null
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.badge_outlined, size: 40, color: AppColors.primary.withOpacity(0.6)),
                              const SizedBox(height: 8),
                              Text('Tap untuk unggah foto KTP', style: TextStyle(color: AppColors.primary.withOpacity(0.8), fontSize: 14)),
                            ],
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // UBAH: Logika tampilan Lintas Platform
                                kIsWeb
                                    ? Image.network(_ktpFile!.path, fit: BoxFit.cover)
                                    : Image.file(File(_ktpFile!.path), fit: BoxFit.cover),

                                Container(color: Colors.black26),
                                const Center(child: Text('Ganti Foto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Daftar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}