import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'services/notification_service.dart';

class AlertPage extends StatefulWidget {
  final String email;

  const AlertPage({super.key, required this.email});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  bool loading = true;

  int mentalScore = 0;
  String status = "";
  String desc = "";
  Color color = Colors.green;

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadAllData() async {
    final testAnswers =
        await DatabaseHelper.instance.getLastTestAnswers(widget.email);

    final reflections =
        await DatabaseHelper.instance.getReflectionHistory(widget.email);

    setState(() {
      mentalScore = calculateMentalScore(
        testAnswers: testAnswers,
        reflections: reflections,
      );

      analyze();
      loading = false;
    });
  }

  // ================= SCORE FIX (TEST 50% + JOURNAL 50% MOOD BASED) =================
  int calculateMentalScore({
    required List<int> testAnswers,
    required List<Map<String, dynamic>> reflections,
  }) {
    double testPercent = 0;
    double journalPercent = 0;

    // ================= TEST SCORE =================
    if (testAnswers.isNotEmpty) {
      double avg =
          testAnswers.reduce((a, b) => a + b) / testAnswers.length;

      testPercent = (avg / 50) * 100;
      testPercent = testPercent.clamp(0, 100);
    }

    // ================= JOURNAL SCORE (MOOD BASED) =================
    if (reflections.isNotEmpty) {
      double totalMood = 0;

      for (var r in reflections) {
        String mood = (r['mood'] ?? '').toString();

        // scoring mood
        double score = switch (mood) {
          "Bahagia" => 100,
          "Netral" => 75,
          "Lelah" => 60,
          "Cemas" => 45,
          "Sedih" => 30,
          "Marah" => 20,
          _ => 50
        };

        totalMood += score;
      }

      journalPercent = totalMood / reflections.length;
    } else {
      journalPercent = 0;
    }

    // ================= FINAL =================
    if (testAnswers.isEmpty && reflections.isEmpty) return 0;

    double finalScore =
        (testPercent * 0.5) + (journalPercent * 0.5);

    return finalScore.clamp(0, 100).round();
  }

  // ================= ANALISIS =================
  void analyze() {
    if (mentalScore == 0) {
      status = "Belum Ada Data";
      desc = "Isi tes dan jurnal terlebih dahulu.";
      color = Colors.grey;
    } else if (mentalScore == 100) {
      status = "Sangat Sehat";
      desc = "Kondisi mental sangat stabil.";
      color = Colors.green;
    } else if (mentalScore >= 80) {
      status = "Mental Sehat";
      desc = "Kondisi kamu baik.";
      color = Colors.green;
    } else if (mentalScore >= 60) {
      status = "Cukup Stabil";
      desc = "Ada sedikit tekanan.";
      color = Colors.orange;
    } else if (mentalScore >= 40) {
      status = "Perlu Perhatian";
      desc = "Kamu mulai tertekan.";
      color = Colors.amber;
    } else {
      status = "Risiko Tinggi";
      desc = "Butuh perhatian serius.";
      color = Colors.red;
    }
  }

  List<String> getAdvice() {
    if (mentalScore >= 80) {
      return ["Pertahankan kebiasaan baik", "Tetap konsisten"];
    } else if (mentalScore >= 60) {
      return ["Kurangi stres", "Istirahat cukup"];
    } else if (mentalScore >= 40) {
      return ["Jangan dipendam", "Cerita ke orang lain"];
    } else {
      return ["Cari bantuan", "Istirahat total"];
    }
  }

  Future<void> sendPsychologistNotification() async {
    await NotificationService.notifyPsychologistSuggestion();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notifikasi bantuan terkirim")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6FBF8F),
        title: const Text("Analisis Mental"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  // SCORE CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.8),
                          color.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "$mentalScore%",
                          style: const TextStyle(
                            fontSize: 42,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          desc,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Saran Pemulihan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...getAdvice().map((e) => Text("• $e")),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6FBF8F),
                      ),
                      onPressed: sendPsychologistNotification,
                      child: const Text(
                        "Kirim Bantuan",
                        style: TextStyle(color: Colors.white), // 🔥 FIX FONT PUTIH
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}