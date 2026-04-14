import 'package:flutter/material.dart';
import 'sitter_bids_screen.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  // Nilai awal (default) untuk dropdown sesuai gambar
  String _selectedHewan = 'Dog';
  String _selectedTanggal = 'April 10-12';
  String _selectedLokasi = 'Tarutung';

  void _mulaiLelang() {
    // Navigasi ke layar daftar Sitter (Peta Sitter)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SitterBidsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER AREA (Background Oranye & Avatar)
            SizedBox(
              height: 250, // Total tinggi area header + overlap avatar
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Latar Belakang Oranye Melengkung
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFCC80), // Warna oranye muda/peach sesuai desain
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                    ),
                    child: const SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Selamat Datang, Budi!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Avatar & Nama Hewan (Milo) yang Overlapping
                  Positioned(
                    top: 120, // Mengatur agar posisinya menimpa batas garis lengkung
                    child: Column(
                      children: [
                        // Lingkaran Avatar
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: const CircleAvatar(
                            radius: 35,
                            backgroundColor: Color(0xFF81C784), // Hijau muda
                            // Untuk MVP, pakai icon dummy. Nanti bisa diganti NetworkImage
                            child: Icon(Icons.face, size: 40, color: Colors.brown),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Badge Nama Hewan (Milo)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Milo',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. FORM INPUT AREA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownItem(
                    label: 'Jenis Hewan',
                    value: _selectedHewan,
                    items: ['Dog', 'Cat', 'Bird', 'Rabbit'],
                    onChanged: (val) => setState(() => _selectedHewan = val!),
                  ),
                  const SizedBox(height: 24),

                  _buildDropdownItem(
                    label: 'Tanggal penitipan',
                    value: _selectedTanggal,
                    items: ['April 10-12', 'April 13-15', 'April 16-18'],
                    onChanged: (val) => setState(() => _selectedTanggal = val!),
                  ),
                  const SizedBox(height: 24),

                  _buildDropdownItem(
                    label: 'Lokasi/Jemput',
                    value: _selectedLokasi,
                    items: ['Tarutung', 'Balige', 'Laguboti', 'Medan'],
                    onChanged: (val) => setState(() => _selectedLokasi = val!),
                  ),

                  const SizedBox(height: 48),

                  // 3. TOMBOL MULAI LELANG
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _mulaiLelang,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B), // Warna oranye gelap sesuai desain
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Mulai Lelang Sitter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget bantuan (Helper) untuk membuat Dropdown agar kode lebih bersih
  Widget _buildDropdownItem({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF59E0B)), // Oranye saat fokus
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.black54)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}