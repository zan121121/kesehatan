import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'mood_calculator.dart';

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
  String trend = "";

  String recommendation = "";
  String meditationSuggestion = "";
  String recoverySuggestion = "";

  List<Map<String, dynamic>> reflections = [];
  List<Map<String, dynamic>> weeklyData = [];

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  // ================= LOAD =================
  Future<void> loadAllData() async {
    final journal =
        await DatabaseHelper.instance.getReflectionHistory(widget.email);

    reflections = journal;

    mentalScore = mentalScoreEngine(reflections);
    status = mentalStatus(mentalScore);
    trend = trendAnalysis(reflections);

    recommendation = getRecommendation(mentalScore);
    meditationSuggestion = getMeditationSuggestion(mentalScore);
    recoverySuggestion = getRecoverySuggestion(mentalScore);

    buildWeeklyBar();

    setState(() => loading = false);
  }

  // ================= DATE =================
  DateTime? parseDate(String raw) {
    if (raw.isEmpty) return null;

    try {
      return DateFormat('dd MMM yyyy • HH:mm', 'id_ID').parseStrict(raw);
    } catch (_) {}

    try {
      return DateFormat('dd MMM yyyy • HH:mm').parseStrict(raw);
    } catch (_) {}

    try {
      if (raw.contains('T')) {
        return DateTime.parse(raw);
      }
    } catch (_) {}

    try {
      return DateFormat('yyyy-MM-dd').parse(raw);
    } catch (_) {}

    return null;
  }

  // ================= SCORE =================
  int mentalScoreEngine(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0;

    double total = 0;

    for (var r in data) {
      total += MoodCalculator.journalToScore(
        (r['journal'] ?? '').toString(),
      );
    }

    return (total / data.length).round();
  }

  // ================= 7 HARI =================
  void buildWeeklyBar() {
    weeklyData = [];

    final now = DateTime.now();
    Map<String, List<double>> grouped = {};

    for (var r in reflections) {
      final rawDate = r['date'] ?? "";
      final journal = (r['journal'] ?? "").toString();

      DateTime? date = parseDate(rawDate);
      if (date == null) continue;

      DateTime normalized = DateTime.utc(
        date.year,
        date.month,
        date.day,
      );

      String key = DateFormat('yyyy-MM-dd').format(normalized);

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(
        MoodCalculator.journalToScore(journal),
      );
    }

    for (int i = 6; i >= 0; i--) {
      DateTime day = now.subtract(Duration(days: i));

      DateTime normalized = DateTime.utc(
        day.year,
        day.month,
        day.day,
      );

      String key = DateFormat('yyyy-MM-dd').format(normalized);

      List<double> values = grouped[key] ?? [];

      double avg = values.isEmpty
          ? 0
          : values.reduce((a, b) => a + b) / values.length;

      weeklyData.add({
        "day": DateFormat('E', 'id_ID').format(day),
        "score": avg.round(),
      });
    }
  }

  // ================= STATUS =================
  String mentalStatus(int score) {
    if (score >= 80) return "Sangat Stabil";
    if (score >= 70) return "Stabil";
    if (score >= 50) return "Cukup Stabil";
    if (score >= 30) return "Perlu Perhatian";
    return "Risiko Tinggi";
  }

  // ================= REKOMENDASI =================
  String getRecommendation(int score) {
    if (score >= 80) {
      return "🔥 Kondisi mental kamu sangat baik.\n\n"
          "Pertahankan kebiasaan positif seperti journaling dan self-awareness.";
    }

    if (score >= 60) {
      return "🙂 Kondisi cukup stabil.\n\n"
          "Tetap jaga keseimbangan aktivitas dan istirahat.";
    }

    if (score >= 40) {
      return "⚠️ Mulai ada tekanan.\n\n"
          "Kurangi beban pikiran dan lakukan relaksasi.";
    }

    return "🧘 Kondisi rendah.\n\n"
        "Fokus pemulihan dan jangan memaksakan diri.";
  }

  // ================= MEDITASI =================
  String getMeditationSuggestion(int score) {
    if (score >= 80) {
      return "Meditasi menenangkan diri / ringan.\n"
          "Untuk menjaga kestabilan.";
    }

    if (score >= 60) {
      return "Meditasi cemas / overthinking.\n"
          "Untuk menenangkan pikiran.";
    }

    if (score >= 40) {
      return "Meditasi anxiety / panik.\n"
          "Untuk menurunkan emosi.";
    }

    return "Meditasi stres berat / sulit tidur.\n"
        "Untuk pemulihan mental.";
  }

  // ================= PEMULIHAN =================
  String getRecoverySuggestion(int score) {
    if (score >= 80) {
      return "Menenangkan diri + suara alam.\n"
          "Menjaga kestabilan.";
    }

    if (score >= 60) {
      return "Latihan napas + suara hujan.\n"
          "Mengurangi stres ringan.";
    }

    if (score >= 40) {
      return "Body scan + menenangkan diri.\n"
          "Menstabilkan emosi.";
    }

    return "Melepas pikiran + napas dalam + suara alam.\n"
        "Pemulihan dari stres berat.";
  }

  // ================= TREND =================
  String trendAnalysis(List<Map<String, dynamic>> data) {
    if (data.length < 2) return "Stabil";

    List<int> scores = data.map((e) {
      return MoodCalculator.journalToScore(
        (e['journal'] ?? '').toString(),
      ).toInt();
    }).toList();

    if (scores.last > scores[scores.length - 2]) return "Membaik";
    if (scores.last < scores[scores.length - 2]) return "Menurun";
    return "Stabil";
  }

  // ================= BAR =================
  Widget buildBar(String day, int value) {
    int bars = (value / 10).round();
    String bar = "█" * bars + "░" * (10 - bars);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(day)),
          Expanded(
            child: Text(
              bar,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ),
          Text("$value"),
        ],
      ),
    );
  }

  // ================= UI =================
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  // SCORE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "$mentalScore / 100",
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(status,
                            style: const TextStyle(color: Colors.white)),
                        Text("Trend: $trend",
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CHART
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Mood 7 Hari (Journal Only)"),
                        const SizedBox(height: 10),
                        ...weeklyData.map((e) =>
                            buildBar(e['day'], e['score'])),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // REKOMENDASI
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
                        const Text("Rekomendasi"),
                        const SizedBox(height: 10),
                        Text(recommendation),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // MEDITASI
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xffe7f4ee),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Meditasi",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(meditationSuggestion),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // PEMULIHAN
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xffeef7f2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pemulihan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(recoverySuggestion),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}