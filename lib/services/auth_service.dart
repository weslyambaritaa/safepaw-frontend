import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Untuk mengecek apakah jalan di Web
import 'dart:io' show Platform; // Untuk mengecek apakah jalan di Android/iOS

class AuthService {
  // Menentukan Base URL secara dinamis berdasarkan platform
  static String get baseUrl {
    if (kIsWeb) {
      // Jika berjalan di Web Browser (Chrome/Edge)
      return 'http://localhost:8080/api';
    } else if (Platform.isAndroid) {
      // Jika berjalan di Android Emulator
      return 'http://10.0.2.2:8080/api';
    } else {
      // Jika berjalan di iOS Simulator atau platform lain
      return 'http://localhost:8080/api';
    }
  }

  // ==========================================
  // MANAJEMEN TOKEN LOKAL (SHARED PREFERENCES)
  // ==========================================

  // Menyimpan Token ke memori HP
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // Mengambil Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Hapus Token (Logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  // ==========================================
  // API REQUESTS
  // ==========================================

  // Fungsi Register
  static Future<bool> register(String name, String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );
      return response.statusCode == 201; // Mengembalikan true jika berhasil
    } catch (e) {
      // Menangkap error jika server mati atau tidak bisa dihubungi
      print("Error saat register: $e");
      return false;
    }
  }

  // Fungsi Login
  static Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token']; // Token JWT dari Go

        // Langsung simpan token ke memori lokal saat login berhasil
        await saveToken(token);

        return token;
      }
      return null; // Mengembalikan null jika gagal login (password salah, dll)
    } catch (e) {
      // Menangkap error jaringan / CORS
      print("Error saat login: $e");
      return null;
    }
  }
}