import 'package:flutter/material.dart';
import 'maps_page.dart';

class PsychologistPage extends StatelessWidget {
  const PsychologistPage({super.key});

  final List<Map<String, String>> places = const [
    {
      "name": "Discoverme | Biro Psikologi",
      "address":
          "Gedung Prudential, Jl. Taruma No.17-A-B Lantai 3, Medan Petisah",
      "phone": "+6281212651287",
    },
    {
      "name": "Biro Psikologi Marsha Puntadewa",
      "address": "Jl. Sultan Hasanuddin No.18, Medan Baru",
      "phone": "+628116403037",
    },
    {
      "name": "Biro Konsultasi Psikologi Riski Ananda",
      "address":
          "Komplek Taman Impian Indah, Jl. Banteng No.9, Medan Helvetia",
      "phone": "+6281361034299",
    },
    {
      "name": "Psikoplus Consulting",
      "address":
          "Komplek Setia Budi Business Point BB No.2, Medan Sunggal",
      "phone": "+6285105507177",
    },
    {
      "name": "YPPI Cabang Medan",
      "address": "Jl. Iskandar Muda No.127, Medan Petisah",
      "phone": "+6287887184585",
    },
    {
      "name": "Tes Bakat Indonesia",
      "address": "Cohive Clapham, Gg. Buntu, Medan Timur",
      "phone": "+6281239002200",
    },
    {
      "name": "Lembaga Psikologi Kognisia",
      "address": "Jl. Rajawali No.30, Medan Sunggal",
      "phone": "+6283800255833",
    },
    {
      "name": "Cosmo Integritas Indonesia",
      "address": "Jl. Kutilang No.16A, Medan Sunggal",
      "phone": "+6282172997282",
    },
    {
      "name": "Citra Kencana Konseling",
      "address": "Jl. Tenis No.15, Medan Kota",
      "phone": "+6281260365659",
    },
    {
      "name": "Psikotes Indonesia Medan",
      "address": "Jl. Sederhana, Percut Sei Tuan",
      "phone": "+6283853132533",
    },
    {
      "name": "Psychology Consultation Bureau UMA",
      "address": "Jl. Kolam No.1, Deli Serdang",
      "phone": "+62617366878",
    },
    {
      "name": "Biro Psikologi MDF",
      "address": "Medan Tuntungan",
      "phone": "",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6FBF8F),
        title: const Text("Psikolog Medan"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// HEADER (TIDAK DIUBAH)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6FBF8F), Color(0xFF4FA87A)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Temukan Psikolog Terdekat",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Konsultasi kesehatan mental di Medan",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          /// LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: places.length,
              itemBuilder: (context, i) {
                final item = places[i];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["name"] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 18, color: Colors.red),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                item["address"] ?? "",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6FBF8F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),

                            /// 🔥 FIX UTAMA: kirim destination ke MapsPage
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MapsPage(
                                    email: "user",
                                    destination: item["address"], // penting
                                  ),
                                ),
                              );
                            },

                            icon: const Icon(Icons.map),
                            label: const Text(
                              "Lihat Maps",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}