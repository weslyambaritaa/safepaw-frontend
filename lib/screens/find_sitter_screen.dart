import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'active_order_screen.dart';

class FindSitterScreen extends StatefulWidget {
  const FindSitterScreen({super.key});

  @override
  State<FindSitterScreen> createState() => _FindSitterScreenState();
}

class _FindSitterScreenState extends State<FindSitterScreen> {
  // Dummy data sitter di sekitar
  final List<Map<String, dynamic>> _nearbySitters = [
    {'id': 1, 'name': 'Budi Santoso', 'distance': '0.5 km', 'rating': 4.8, 'price': 50000},
    {'id': 2, 'name': 'Siti Aminah', 'distance': '1.2 km', 'rating': 4.9, 'price': 45000},
    {'id': 3, 'name': 'Andi Wijaya', 'distance': '2.0 km', 'rating': 4.7, 'price': 40000},
  ];

  void _showDealDialog(Map<String, dynamic> sitter) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Deal dengan ${sitter['name']}?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jarak: ${sitter['distance']}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              Text('Harga Penawaran: Rp ${sitter['price']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 16),
              const Text('Apakah Anda setuju dengan harga ini untuk menjaga anabul Anda?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                // Pindah ke layar pesanan aktif (Deal!)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ActiveOrderScreen(sitter: sitter)),
                );
              },
              child: const Text('Deal!'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mencari Sitter...', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Simulasi Map (Background)
          Container(
            color: Colors.grey[200], // Anggap ini adalah Google Maps
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, size: 100, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Peta Lokasi Dummy', style: TextStyle(color: Colors.grey[500], fontSize: 18)),
                  const SizedBox(height: 200), // Memberi ruang untuk bottom sheet
                ],
              ),
            ),
          ),

          // Daftar Sitter (Bottom Sheet style)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 350,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 12),
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text('Sitter di Sekitar Anda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _nearbySitters.length,
                      itemBuilder: (context, index) {
                        final sitter = _nearbySitters[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(sitter['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text('${sitter['rating']} • ${sitter['distance']}'),
                            ],
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () => _showDealDialog(sitter),
                            child: const Text('Pilih'),
                          ),
                        );
                      },
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