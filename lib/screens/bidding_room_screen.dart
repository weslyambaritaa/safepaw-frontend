import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../utils/app_colors.dart';
import '../services/bidding_service.dart';

class BiddingRoomScreen extends StatefulWidget {
  final int petRequestId; // ID Pesanan Lelang

  const BiddingRoomScreen({super.key, required this.petRequestId});

  @override
  State<BiddingRoomScreen> createState() => _BiddingRoomScreenState();
}

class _BiddingRoomScreenState extends State<BiddingRoomScreen> {
  // Saluran komunikasi real-time
  late WebSocketChannel _channel;

  // Daftar harga yang masuk
  final List<Map<String, dynamic>> _bids = [];

  // Controller untuk input harga
  final TextEditingController _amountController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Buka koneksi WebSocket ke server Go
    _channel = WebSocketChannel.connect(Uri.parse(BiddingService.wsUrl));

    // Dengarkan setiap pesan yang masuk
    _channel.stream.listen((message) {
      final data = jsonDecode(message);

      // Jika itu adalah pesan bid baru dari backend
      if (data['type'] == 'NEW_BID' && data['pet_request_id'] == widget.petRequestId) {
        setState(() {
          _bids.add(data); // Tambahkan ke layar UI
        });
      }
    });
  }

  @override
  void dispose() {
    _channel.sink.close(); // Putus koneksi saat layar ditutup
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _sendBid() async {
    if (_amountController.text.isEmpty) return;

    setState(() => _isSubmitting = true);

    double amount = double.tryParse(_amountController.text) ?? 0.0;

    // (MVP: Anggap Sitter ID adalah 1 untuk simulasi pengujian)
    bool success = await BiddingService.submitBid(widget.petRequestId, 1, amount);

    setState(() => _isSubmitting = false);

    if (success) {
      _amountController.clear(); // Bersihkan kolom ketik
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim tawaran harga')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ruang Lelang (Live)', style: TextStyle(color: AppColors.textPrimary, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          // Bagian Daftar Harga (Katalog Live)
          Expanded(
            child: _bids.isEmpty
                ? const Center(child: Text("Belum ada tawaran masuk. Jadilah yang pertama!", style: TextStyle(color: AppColors.textSecondary)))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _bids.length,
              itemBuilder: (context, index) {
                final bid = _bids[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white)),
                          const SizedBox(width: 12),
                          Text('Sitter #${bid['sitter_id']}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        ],
                      ),
                      Text(
                        'Rp ${bid['amount'].toInt()}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bagian Input Harga
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Masukkan harga tawaran...',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      icon: _isSubmitting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.send, color: Colors.white),
                      onPressed: _isSubmitting ? null : _sendBid,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}