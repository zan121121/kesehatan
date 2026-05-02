import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'mood_calculator.dart';

class ReflectPage extends StatefulWidget {
  final String email;

  const ReflectPage({super.key, required this.email});

  @override
  State<ReflectPage> createState() => _ReflectPageState();
}

class _ReflectPageState extends State<ReflectPage> {
  final TextEditingController journalController = TextEditingController();

  final List<String> questions = [
    "Apa yang kamu rasakan hari ini?",
    "Apa yang membuat kamu stres?",
    "Apa hal baik yang terjadi hari ini?",
    "Apa yang kamu pelajari hari ini?"
  ];

  final Map<int, String> answers = {};
  List<Map<String, dynamic>> history = [];

  String journalInsight = "";
  int moodScore = 0;
  String mentalStatus = "";

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final data =
        await DatabaseHelper.instance.getReflectionHistory(widget.email);

    setState(() {
      history = data;
    });
  }

  bool alreadyFilledToday() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return history.any((item) {
      final rawDate = item["date"] as String;

      try {
        final parsed =
            DateFormat('dd MMM yyyy • HH:mm').parse(rawDate);
        final itemDate =
            DateFormat('yyyy-MM-dd').format(parsed);

        return itemDate == today;
      } catch (_) {
        return false;
      }
    });
  }

  // ================= STATUS SAMA DENGAN ALERT PAGE =================
  String getMentalStatus(int score) {
    if (score >= 80) return "Sangat Stabil";
    if (score >= 70) return "Stabil";
    if (score >= 50) return "Cukup Stabil";
    if (score >= 30) return "Perlu Perhatian";
    return "Risiko Tinggi";
  }

  String generateInsight(String text, String status) {
    final t = text.toLowerCase();

    if (t.contains("bunuh diri") || t.contains("mengakhiri hidup")) {
      return "Kondisi kamu sangat berat. Segera cari bantuan profesional atau orang terdekat.";
    }

    if (status == "Risiko Tinggi") {
      return "Kondisi mental kamu sedang tidak stabil. Disarankan istirahat dan berbicara dengan orang terpercaya.";
    }

    if (status == "Perlu Perhatian") {
      return "Kamu sedang dalam tekanan. Coba kurangi beban pikiran.";
    }

    return "Kondisi kamu stabil. Pertahankan kebiasaan positif.";
  }

  // ================= SAVE =================
  Future<void> saveReflection() async {
    final text = journalController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi dulu jurnalnya")),
      );
      return;
    }

    if (alreadyFilledToday()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jurnal sudah diisi hari ini")),
      );
      return;
    }

    final now = DateTime.now();
    final formattedDate =
        DateFormat('dd MMM yyyy • HH:mm').format(now);
    final todayKey =
        DateFormat('yyyy-MM-dd').format(now);

    // ================= KALKULASI SAMA DENGAN ALERT PAGE =================
    moodScore = MoodCalculator.journalToScore(text).round();
    mentalStatus = getMentalStatus(moodScore);
    final insight = generateInsight(text, mentalStatus);

    setState(() {
      journalInsight = insight;
    });

    final answerText = questions.asMap().entries.map((e) {
      final index = e.key;
      final question = e.value;
      final answer = answers[index] ?? "-";
      return "$question\n-> $answer";
    }).join("\n\n");

    await DatabaseHelper.instance.insertReflection(
      email: widget.email,
      date: formattedDate,
      journal: text,
      answers: answerText,
      mood: mentalStatus,
      insight: insight,
    );

    final alreadyGotCoin =
        await DatabaseHelper.instance.hasTodayPoint(widget.email, todayKey);

    if (!alreadyGotCoin) {
      await DatabaseHelper.instance.addPoint(
        widget.email,
        "reflect",
        todayKey,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Refleksi tersimpan +10 Mental Point 💚")),
    );

    journalController.clear();
    answers.clear();

    await loadHistory();
  }

  // ================= UI (TETAP) =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),

      appBar: AppBar(
        title: const Text("Jurnal Kesehatan Mental"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tulis isi pikiranmu",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: journalController,
                  maxLines: 5,
                  decoration: inputStyle("Cerita bebas di sini..."),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ...List.generate(questions.length, (index) {
            return buildCard(
              marginBottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questions[index],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (value) {
                      answers[index] = value;
                    },
                    decoration: inputStyle("Jawaban kamu"),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 15),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6FBF8F),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: saveReflection,
            child: const Text(
              "Simpan Jurnal",
              style: TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 15),

          if (journalInsight.isNotEmpty)
            buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hasil Analisis Mental",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text("Skor: $moodScore / 100"),
                  Text("Status: $mentalStatus"),
                  const SizedBox(height: 10),
                  Text(journalInsight),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildCard({required Widget child, double marginBottom = 0}) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8)
        ],
      ),
      child: child,
    );
  }

  InputDecoration inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xfff3f6f5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}