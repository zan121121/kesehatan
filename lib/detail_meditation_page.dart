import 'package:flutter/material.dart';

class DetailMeditationPage extends StatelessWidget {
  final Map data;

  const DetailMeditationPage({super.key, required this.data});

  String titleType() {
    final t = data["title"].toString().toLowerCase();

    if (t.contains("stres")) return "stres";
    if (t.contains("cemas")) return "cemas";
    if (t.contains("panik")) return "panik";
    if (t.contains("overthinking")) return "overthinking";

    return "umum";
  }

  List<Map<String, dynamic>> getSteps(String type) {
    switch (type) {
      case "stres":
        return [
          {
            "t": "Kenali Pemicu Stres",
            "d": "Sadari apa yang membuat pikiranmu penuh. Jangan langsung melawan, cukup amati dulu.",
          },
          {
            "t": "Atur Napas Perlahan",
            "d": "Tarik napas 4 detik, tahan 4 detik, buang 6–8 detik secara perlahan.",
          },
          {
            "t": "Lepaskan Ketegangan Tubuh",
            "d": "Relaksasikan bahu, rahang, dan tangan yang biasanya tegang saat stres.",
          },
          {
            "t": "Alihkan Fokus Positif",
            "d": "Dengarkan suara tenang atau lakukan aktivitas ringan seperti jalan santai.",
          },
        ];

      case "cemas":
        return [
          {
            "t": "Sadari Kecemasan",
            "d": "Jangan lawan rasa cemas, cukup akui bahwa kamu sedang merasa tidak nyaman.",
          },
          {
            "t": "Latihan Grounding",
            "d": "Fokus pada 5 benda yang kamu lihat, 4 yang kamu sentuh, 3 suara, 2 aroma, 1 rasa.",
          },
          {
            "t": "Ulangi Kalimat Tenang",
            "d": "Katakan: ‘Aku aman sekarang, semuanya akan baik-baik saja.’",
          },
          {
            "t": "Kembali ke Saat Ini",
            "d": "Fokus pada napas dan apa yang terjadi sekarang, bukan masa depan.",
          },
        ];

      case "panik":
        return [
          {
            "t": "Hentikan Aktivitas Sekejap",
            "d": "Berhenti dulu dari semua hal yang sedang dilakukan.",
          },
          {
            "t": "Atur Napas Lambat",
            "d": "Tarik napas 4 detik, buang 8 detik sampai detak jantung menurun.",
          },
          {
            "t": "Sentuh Benda Sekitar",
            "d": "Rasakan benda di sekitarmu untuk mengembalikan kesadaran tubuh.",
          },
          {
            "t": "Yakinkan Diri",
            "d": "Ingatkan diri bahwa ini hanya reaksi sementara dan akan berlalu.",
          },
        ];

      case "overthinking":
        return [
          {
            "t": "Sadari Pikiran Berlebihan",
            "d": "Kamu tidak harus percaya semua pikiran yang muncul.",
          },
          {
            "t": "Tulis Semua Pikiran",
            "d": "Keluarkan isi pikiran tanpa filter ke catatan.",
          },
          {
            "t": "Batasi Pikiran",
            "d": "Tentukan waktu khusus untuk berpikir, jangan sepanjang hari.",
          },
          {
            "t": "Alihkan Aktivitas",
            "d": "Lakukan hal sederhana seperti minum air atau berjalan.",
          },
        ];

      default:
        return [
          {
            "t": "Tenangkan Diri",
            "d": "Duduk nyaman dan fokus pada napas secara perlahan.",
          },
          {
            "t": "Rilekskan Tubuh",
            "d": "Lepaskan semua ketegangan di tubuh secara perlahan.",
          },
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = titleType();
    final steps = getSteps(type);

    const Color mainColor = Color(0xFF6FBF8F); // 🔥 DIKUNCI TIDAK DIUBAH

    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),

      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(data["title"]),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                "Panduan $type",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// DESKRIPSI
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "Panduan ini membantu kamu mengelola kondisi $type secara perlahan, sadar, dan lebih tenang tanpa tekanan.",
                style: const TextStyle(height: 1.6),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Langkah-Langkah",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            /// STEP KIRI KANAN
            Column(
              children: List.generate(steps.length, (index) {
                final e = steps[index];
                final isLeft = index % 2 == 0;

                return Row(
                  children: [

                    if (!isLeft) const Spacer(),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: mainColor.withOpacity(0.3)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e["t"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mainColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            e["d"],
                            style: const TextStyle(height: 1.5),
                          ),
                        ],
                      ),
                    ),

                    if (isLeft) const Spacer(),
                  ],
                );
              }),
            ),

            const SizedBox(height: 20),

            /// PENUTUP
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "💚 Lakukan latihan ini dengan santai. Tidak perlu sempurna, cukup konsisten dan pelan-pelan.",
                style: TextStyle(height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}