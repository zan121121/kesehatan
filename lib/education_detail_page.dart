import 'package:flutter/material.dart';

class EducationDetailPage extends StatelessWidget {
  final Map data;

  const EducationDetailPage({super.key, required this.data});

  /// ================= ISI KONTEN =================
  List<Map<String, dynamic>> getContent(String title) {
  switch (title) {

    case "Pengantar Psikologi":
      return [
        {
          "judul": "Definisi Psikologi",
          "isi":
              "Psikologi adalah ilmu yang mempelajari perilaku manusia serta proses mental yang terjadi di dalam pikiran, seperti cara berpikir, merasakan emosi, mengingat, dan mengambil keputusan. Psikologi tidak hanya membahas apa yang terlihat dari luar, tetapi juga memahami alasan di balik perilaku manusia.\n\nIlmu ini digunakan dalam berbagai bidang seperti pendidikan, kesehatan, organisasi, dan kehidupan sehari-hari untuk membantu manusia memahami dirinya sendiri dan orang lain dengan lebih baik.",
        },
        {
          "judul": "Tujuan Psikologi",
          "isi":
              "Tujuan utama psikologi adalah untuk memahami, menjelaskan, memprediksi, dan mengubah perilaku manusia secara ilmiah. Dengan memahami psikologi, kita dapat mengetahui mengapa seseorang bertindak tertentu dalam situasi tertentu.\n\nSelain itu, psikologi juga membantu dalam pengembangan diri, kesehatan mental, dan peningkatan kualitas hidup manusia.",
        },
        {
          "judul": "Cabang Psikologi",
          "isi":
              "Psikologi memiliki banyak cabang seperti psikologi klinis (gangguan mental), psikologi kognitif (cara berpikir), psikologi sosial (interaksi manusia), psikologi perkembangan (pertumbuhan manusia), dan psikologi industri (lingkungan kerja).",
        },
      ];

    case "Gangguan Kecemasan (Anxiety)":
      return [
        {
          "judul": "Pengertian Anxiety",
          "isi":
              "Gangguan kecemasan (anxiety disorder) adalah kondisi psikologis ketika seseorang mengalami rasa takut, khawatir, atau gelisah secara berlebihan dan terus-menerus, bahkan tanpa adanya ancaman yang jelas.\n\nKecemasan ini dapat mengganggu aktivitas sehari-hari, pekerjaan, hubungan sosial, dan kualitas hidup seseorang.",
        },
        {
          "judul": "Gejala Anxiety",
          "isi":
              "Gejala anxiety tidak hanya muncul secara mental, tetapi juga fisik. Secara mental, seseorang bisa merasa takut berlebihan, sulit fokus, dan selalu berpikir hal buruk akan terjadi.\n\nSecara fisik, gejala bisa berupa jantung berdebar cepat, napas pendek, berkeringat, otot tegang, dan sulit tidur.",
        },
        {
          "judul": "Penyebab",
          "isi":
              "Anxiety dapat disebabkan oleh berbagai faktor seperti pengalaman traumatis, tekanan hidup yang berat, faktor genetik, atau ketidakseimbangan kimia di otak. Lingkungan yang penuh tekanan juga dapat memperburuk kondisi ini.",
        },
      ];

    case "Depresi & Mood Disorder":
      return [
        {
          "judul": "Apa itu Depresi",
          "isi":
              "Depresi adalah gangguan suasana hati (mood disorder) yang ditandai dengan perasaan sedih yang mendalam, kehilangan minat, dan menurunnya energi dalam jangka waktu lama.\n\nDepresi bukan sekadar sedih biasa, tetapi kondisi medis yang dapat mempengaruhi cara seseorang berpikir, merasa, dan berperilaku.",
        },
        {
          "judul": "Gejala Depresi",
          "isi":
              "Gejala depresi meliputi perasaan kosong, putus asa, kehilangan motivasi, gangguan tidur, perubahan nafsu makan, serta kesulitan berkonsentrasi. Dalam kasus berat, seseorang bisa memiliki pikiran negatif tentang dirinya sendiri.",
        },
        {
          "judul": "Penanganan",
          "isi":
              "Depresi dapat ditangani melalui terapi psikologis seperti CBT, dukungan sosial, perubahan gaya hidup, dan dalam beberapa kasus penggunaan obat dari profesional kesehatan mental.",
        },
      ];

    case "Stres & Respon Psikologis":
      return [
        {
          "judul": "Apa itu Stres",
          "isi":
              "Stres adalah respon alami tubuh ketika menghadapi tekanan atau tuntutan. Stres sebenarnya normal dan bisa membantu seseorang tetap fokus dalam situasi tertentu.\n\nNamun, stres yang berlebihan dan berkepanjangan dapat berdampak negatif pada kesehatan mental dan fisik.",
        },
        {
          "judul": "Dampak Stres",
          "isi":
              "Stres dapat mempengaruhi emosi (mudah marah, cemas), tubuh (sakit kepala, lelah), dan perilaku (menarik diri, sulit konsentrasi).",
        },
        {
          "judul": "Manajemen Stres",
          "isi":
              "Manajemen stres melibatkan pengaturan waktu, istirahat yang cukup, aktivitas fisik, serta kemampuan mengelola pikiran agar tidak terlalu terbebani.",
        },
      ];

    case "Terapi Kognitif (CBT Dasar)":
      return [
        {
          "judul": "Apa itu CBT",
          "isi":
              "Cognitive Behavioral Therapy (CBT) adalah metode terapi psikologi yang berfokus pada hubungan antara pikiran, perasaan, dan perilaku. CBT membantu seseorang mengenali pola pikir negatif yang tidak realistis.",
        },
        {
          "judul": "Cara Kerja CBT",
          "isi":
              "CBT bekerja dengan mengidentifikasi pikiran negatif, mengevaluasinya, lalu menggantinya dengan pola pikir yang lebih realistis dan sehat.",
        },
        {
          "judul": "Contoh",
          "isi":
              "Contoh sederhana: mengubah pikiran 'Saya selalu gagal' menjadi 'Saya pernah gagal, tetapi saya juga pernah berhasil'.",
        },
      ];

    case "Distorsi Kognitif":
      return [
        {
          "judul": "Pengertian",
          "isi":
              "Distorsi kognitif adalah pola pikir yang tidak akurat dan cenderung negatif, yang membuat seseorang salah menafsirkan situasi.",
        },
        {
          "judul": "Jenis Distorsi",
          "isi":
              "Contohnya termasuk overgeneralization (menyamaratakan satu kejadian), catastrophizing (membesar-besarkan masalah), dan black-and-white thinking (berpikir hitam-putih).",
        },
        {
          "judul": "Dampak",
          "isi":
              "Distorsi kognitif dapat memperburuk kecemasan, stres, dan depresi jika tidak disadari dan diperbaiki.",
        },
      ];

    case "Regulasi Emosi (Emotional Regulation)":
      return [
        {
          "judul": "Apa itu Regulasi Emosi",
          "isi":
              "Regulasi emosi adalah kemampuan seseorang untuk mengelola dan merespons emosi dengan cara yang sehat dan sesuai situasi.",
        },
        {
          "judul": "Pentingnya Regulasi Emosi",
          "isi":
              "Kemampuan ini penting agar seseorang tidak dikuasai oleh emosi negatif seperti marah atau sedih yang berlebihan.",
        },
        {
          "judul": "Cara Melatih",
          "isi":
              "Melatih kesadaran emosi, berpikir sebelum bereaksi, dan menggunakan teknik coping yang sehat seperti menulis atau berbicara dengan orang lain.",
        },
      ];

    default:
      return [
        {
          "judul": "Materi",
          "isi":
              "Materi belum tersedia untuk topik ini. Silakan pilih topik lain.",
        }
      ];
  }
}
  @override
  Widget build(BuildContext context) {
    final content = getContent(data["title"]);

    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),

      appBar: AppBar(
        title: Text(data["title"]),
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// HEADER
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF6FBF8F),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Column(
              children: [
                Text(
                  "📘 Materi Psikologi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Pelajari secara perlahan. Semua materi ini berbasis konsep psikologi ilmiah.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// CHAT STYLE CONTENT
          ...content.asMap().entries.map((entry) {
            final index = entry.key;
            final e = entry.value;

            final isLeft = index % 2 == 0;

            return Align(
              alignment:
                  isLeft ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  color: isLeft
                      ? Colors.white
                      : const Color(0xFF6FBF8F).withOpacity(0.15),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft:
                        Radius.circular(isLeft ? 0 : 16),
                    bottomRight:
                        Radius.circular(isLeft ? 16 : 0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e["judul"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isLeft
                            ? Colors.black
                            : Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      e["isi"],
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          /// FOOTER
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              "Belajar psikologi itu proses. Tidak harus cepat, yang penting konsisten memahami diri sendiri.",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}