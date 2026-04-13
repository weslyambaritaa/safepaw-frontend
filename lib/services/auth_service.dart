import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart'; // Tambahkan ini untuk tipe XFile
import 'dart:io' show Platform;

class AuthService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8080/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:8080/api';
    return 'http://localhost:8080/api';
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  // UBAH: Menerima XFile, bukan File
  static Future<bool> register(String name, String email, String password, String role, {XFile? ktpFile}) async {
    try {
      var uri = Uri.parse('$baseUrl/register');
      var request = http.MultipartRequest('POST', uri);

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['role'] = role;

      if (role == 'sitter' && ktpFile != null) {
        http.MultipartFile multipartFile;

        // Pengecekan Lintas Platform untuk Upload File
        if (kIsWeb) {
          // Jika di WEB, baca file sebagai susunan byte
          var bytes = await ktpFile.readAsBytes();
          multipartFile = http.MultipartFile.fromBytes(
            'identity_card',
            bytes,
            filename: ktpFile.name,
          );
        } else {
          // Jika di ANDROID/iOS, gunakan path fisik
          multipartFile = await http.MultipartFile.fromPath(
            'identity_card',
            ktpFile.path,
          );
        }

        request.files.add(multipartFile);
      }

      var response = await request.send();
      return response.statusCode == 201;
    } catch (e) {
      print("Error saat register: $e");
      return false;
    }
  }

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
        String token = data['token'];
        await saveToken(token);
        return token;
      }
      return null;
    } catch (e) {
      print("Error saat login: $e");
      return null;
    }
  }
}