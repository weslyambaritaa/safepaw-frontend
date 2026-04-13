import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'auth_service.dart'; // Untuk mengambil token JWT

class BiddingService {
  // Menentukan HTTP API URL
  static String get apiUrl {
    if (kIsWeb) return 'http://localhost:8080/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:8080/api';
    return 'http://localhost:8080/api';
  }

  // Menentukan WebSocket URL
  static String get wsUrl {
    if (kIsWeb) return 'ws://localhost:8080/ws';
    if (Platform.isAndroid) return 'ws://10.0.2.2:8080/ws';
    return 'ws://localhost:8080/ws';
  }

  // Fungsi untuk mengirim penawaran harga
  static Future<bool> submitBid(int requestId, int sitterId, double amount) async {
    // 1. Ambil karcis token yang disimpan saat login
    String? token = await AuthService.getToken();
    if (token == null) return false; // Tolak jika tidak ada token

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/bids'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // 2. Sertakan token ke satpam Go
        },
        body: jsonEncode({
          'pet_request_id': requestId,
          'sitter_id': sitterId,
          'amount': amount,
        }),
      );

      // Jika server membalas Status 201 Created
      return response.statusCode == 201;
    } catch (e) {
      print("Error submit bid: $e");
      return false;
    }
  }
}