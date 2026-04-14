import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'active_order_screen.dart'; // Gunakan file dari jawaban saya sebelumnya

class SitterBidsScreen extends StatefulWidget {
  const SitterBidsScreen({super.key});

  @override
  State<SitterBidsScreen> createState() => _SitterBidsScreenState();
}

class _SitterBidsScreenState extends State<SitterBidsScreen> {
  // Dummy data: Ini seolah-olah data dari Sitter yang merespons lelang Anda
  final List<Map<String, dynamic>> _biddingSitters = [
    {'id': 1, 'name': 'Budi Santoso', 'distance': '0.5 km', 'rating': 4.8, 'price': 50000},
    {'id': 2, 'name': 'Siti Aminah', 'distance': '1.2 km', 'rating': 4.9, 'price': 45000},
    {'id': 3, 'name': 'Andi Wijaya', 'distance': '2.0 km', 'rating': 4.7, 'price': 40000},
  ];

  void _showDealConfirm(Map<String, dynamic> sitter) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Konfirmasi Penawaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('Apakah Anda setuju dengan harga Rp ${sitter['price']} dari ${sitter['name']}?'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tunggu Dulu'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Tutup bottom sheet
                        // Lanjut ke pesanan aktif
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ActiveOrderScreen(sitter: sitter)),
                        );
                      },
                      child: const Text('Deal!'),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tawaran Masuk', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Peta Dummy
          Container(
            color: Colors.blueGrey[50],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.radar, size: 80, color: AppColors.primary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text('Menunggu Sitter merespons...', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 200), // Ruang untuk list di bawah
                ],
              ),
            ),
          ),

          // List Tawaran Sitter
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 400, // Lebih tinggi sedikit agar list terlihat jelas
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 12),
                      width: 40, height: 5,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text('Sitter Terdekat (Harga Tawaran)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _biddingSitters.length,
                      itemBuilder: (context, index) {
                        final sitter = _biddingSitters[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white)),
                          title: Text(sitter['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${sitter['distance']} • ${sitter['rating']} ⭐'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Rp ${sitter['price']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                  onPressed: () => _showDealConfirm(sitter),
                                  child: const Text('Pilih', style: TextStyle(fontSize: 12)),
                                ),
                              )
                            ],
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