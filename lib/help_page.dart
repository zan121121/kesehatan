import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget faqItem(String q, String a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            q,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(a),
        ],
      ),
    );
  }

  Widget contactCard(String name, String phone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xffe7f4ee),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$name\n$phone",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bantuan & FAQ"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= INFO APP =================
            sectionTitle("Tentang Aplikasi"),
            const Text(
              "Ruang Sadar adalah aplikasi kesehatan mental yang membantu pengguna "
              "melakukan tracking mood, meditasi, refleksi diri, challenge harian, "
              "dan konsultasi psikolog sederhana.",
            ),

            /// ================= FAQ =================
            sectionTitle("FAQ (Pertanyaan Umum)"),

            faqItem(
              "Bagaimana cara mendapatkan coin?",
              "Coin didapat dari aktivitas harian seperti check-in mood, meditasi, challenge, dan refleksi diri.",
            ),

            faqItem(
              "Untuk apa coin digunakan?",
              "Coin dapat ditukar dengan reward di menu Tukar Coin.",
            ),

            faqItem(
              "Apakah data saya aman?",
              "Ya. Data disimpan lokal menggunakan database aplikasi dan hanya digunakan untuk kebutuhan fitur aplikasi.",
            ),

            faqItem(
              "Bagaimana cara login ulang setelah keluar?",
              "Jika belum logout, aplikasi akan otomatis login kembali. Jika logout, silakan login ulang dengan email.",
            ),

            faqItem(
              "Apa itu fitur Daily Mood?",
              "Fitur untuk mencatat kondisi emosi harian agar kamu bisa memantau kesehatan mentalmu.",
            ),

            faqItem(
              "Apa itu Reflect?",
              "Fitur untuk menulis refleksi diri dan evaluasi perasaan harian.",
            ),

            faqItem(
              "Apa itu Meditation?",
              "Fitur latihan meditasi untuk menenangkan pikiran dan mengurangi stres.",
            ),

            faqItem(
              "Apa itu Check-in Harian?",
              "Fitur untuk tracking kebiasaan dan kondisi mental setiap hari.",
            ),

            faqItem(
              "Apa itu Mood Alert?",
              "Fitur peringatan jika pola mood kamu terdeteksi tidak stabil.",
            ),

            faqItem(
              "Apa itu Challenge?",
              "Tantangan harian untuk meningkatkan kesehatan mental secara bertahap.",  
            ),

            faqItem(
              "Apakah aplikasi ini butuh internet?",
              "Sebagian fitur offline, tapi beberapa fitur seperti menuju maps psikolog bisa membutuhkan internet.",
            ),

            /// ================= CONTACT =================
            sectionTitle("Kontak Tim Pengembang"),

            const Text(
              "Jika ada kendala atau bug, hubungi salah satu tim berikut:",
            ),

            const SizedBox(height: 10),

            contactCard("M FAUZAN RIVALDO PURNAMA", "0898 5675 586"),
            contactCard("FADLY HABIBI LUBIS", "0823 6943 6342"),
            contactCard("MUHAMAD YUSUF", "0812 6417 7933"),
            contactCard("DAUD ABDULRAHMAN", "0821 7260 9360"),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "💚 Ruang Sadar - Mental Health Companion App",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}