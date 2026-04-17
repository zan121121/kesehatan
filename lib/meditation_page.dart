import 'package:flutter/material.dart';
import 'detail_meditation_page.dart';

class MeditationPage extends StatelessWidget {
  const MeditationPage({super.key});

  final List<Map<String, dynamic>> topics = const [
    {
      "title": "Sulit Tidur",
      "icon": Icons.nightlight_round,
      "desc":
          "Kesulitan tidur sering terjadi karena pikiran yang masih aktif.\n\n"
          "🔹 Coba teknik ini:\n"
          "• Matikan layar 30 menit sebelum tidur\n"
          "• Tarik napas 4 detik, buang 6–8 detik\n"
          "• Fokus ke sensasi tubuh (body scanning)\n\n"
          "💡 Bayangkan kamu berada di tempat aman seperti pantai atau hutan."
    },
    {
      "title": "Cemas / Anxiety",
      "icon": Icons.psychology,
      "desc":
          "Cemas adalah respon alami tubuh terhadap ancaman yang belum tentu nyata.\n\n"
          "🔹 Latihan:\n"
          "• Grounding 5-4-3-2-1\n"
          "• Fokus napas\n"
          "• 'Saya aman saat ini'"
    },
    {
      "title": "Panik",
      "icon": Icons.warning_amber_rounded,
      "desc":
          "Serangan panik terasa intens tapi tidak berbahaya.\n\n"
          "🔹 Langkah:\n"
          "• Tarik napas 3 detik\n"
          "• Buang 6–8 detik"
    },
    {
      "title": "Overthinking",
      "icon": Icons.lightbulb,
      "desc":
          "Overthinking terjadi saat otak terlalu aktif.\n\n"
          "🔹 Solusi:\n"
          "• Tulis pikiran\n"
          "• Fokus 1 hal"
    },
    {
      "title": "Stres Berat",
      "icon": Icons.self_improvement,
      "desc":
          "Stres adalah tanda tubuh butuh istirahat.\n\n"
          "🔹 Relaksasi:\n"
          "• Pejamkan mata\n"
          "• Dengar suara alam"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6FBF8F),
        title: const Text("Meditasi"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final item = topics[index];

          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => PreviewSheet(data: item),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),
              child: Row(
                children: [
                  /// ICON
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xffe7f4ee),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(item["icon"],
                        size: 28, color: const Color(0xFF6FBF8F)),
                  ),

                  const SizedBox(width: 15),

                  /// TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["title"],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item["desc"].toString().split("\n")[0],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const Icon(Icons.arrow_forward_ios, size: 16)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ================= PREVIEW MODAL =================
class PreviewSheet extends StatefulWidget {
  final Map data;

  const PreviewSheet({super.key, required this.data});

  @override
  State<PreviewSheet> createState() => _PreviewSheetState();
}

class _PreviewSheetState extends State<PreviewSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    scale = Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return AnimatedBuilder(
      animation: scale,
      builder: (_, child) {
        return Transform.scale(
          scale: scale.value,
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 80),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xfff3f6f5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Icon(
              data["icon"],
              size: 70,
              color: const Color(0xFF6FBF8F),
            ),

            const SizedBox(height: 10),

            Text(
              data["title"],
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              data["desc"].toString().split("\n")[0],
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF6FBF8F),
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  onPressed: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailMeditationPage(data: data),
      ),
    );
  },
  child: const Text(
    "Baca Selengkapnya",
    style: TextStyle(color: Colors.white),
  ),
),
          ],
        ),
      ),
    );
  }
}