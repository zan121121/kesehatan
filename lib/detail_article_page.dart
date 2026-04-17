import 'package:flutter/material.dart';

class DetailArticlePage extends StatelessWidget {
  final String title;
  final String content;

  const DetailArticlePage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),

      appBar: AppBar(
        title: const Text("Artikel"),
        backgroundColor: const Color(0xFF6FBF8F),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 HEADER ARTIKEL
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFA8E6CF), Color(0xFF6FBF8F)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu_book, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 INTRO
            const Text(
              "Pendahuluan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 PEMBAHASAN
            const Text(
              "Pembahasan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Burnout adalah kondisi kelelahan fisik, emosional, dan mental akibat tekanan jangka panjang. "
              "Kondisi ini sering dialami oleh mahasiswa, pekerja, maupun individu yang menghadapi tekanan tinggi tanpa jeda.",
              style: TextStyle(fontSize: 14, height: 1.6),
            ),

            const SizedBox(height: 15),

            /// 🔥 POINT POINT
            buildPoint("Kelelahan ekstrem (fisik & mental)"),
            buildPoint("Penurunan motivasi dan produktivitas"),
            buildPoint("Sulit fokus dan mudah terdistraksi"),
            buildPoint("Gangguan tidur dan emosi tidak stabil"),

            const SizedBox(height: 20),

            /// 🔥 BOX TIPS (BIAR MENARIK)
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        "Tips Mengatasi Burnout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("• Istirahat cukup dan atur jadwal tidur"),
                  Text("• Kurangi beban tugas sementara"),
                  Text("• Lakukan aktivitas relaksasi (meditasi)"),
                  Text("• Berbicara dengan orang terpercaya"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 KESIMPULAN
            const Text(
              "Kesimpulan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Burnout bukanlah hal sepele dan perlu ditangani dengan serius. "
              "Dengan mengenali gejala sejak dini dan melakukan langkah pemulihan, "
              "kesehatan mental dapat kembali stabil secara bertahap.",
              style: TextStyle(fontSize: 14, height: 1.6),
            ),

            const SizedBox(height: 25),

            /// 🔥 BUTTON AKSI
           
          ],
        ),
      ),
    );
  }

  /// 🔥 WIDGET POINT BIAR RAPI
  Widget buildPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}