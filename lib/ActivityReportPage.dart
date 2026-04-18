import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'database_helper.dart';

class ActivityReportPage extends StatefulWidget {
  final String email;

  const ActivityReportPage({super.key, required this.email});

  @override
  State<ActivityReportPage> createState() => _ActivityReportPageState();
}

class _ActivityReportPageState extends State<ActivityReportPage> {
  List<Map<String, dynamic>> reflections = [];
  bool loading = true;

  int mentalScore = 0;

  final List<String> questionList = [
    "Ceritakan perasaanmu hari ini",
    "Apa yang membuat kamu stres?",
    "Apa hal baik yang terjadi hari ini?",
    "Apa yang kamu pelajari hari ini?",
  ];

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  String getUsername() => widget.email.split('@')[0];

  int calculateMentalScore({
    required List<int> testAnswers,
    required List<Map<String, dynamic>> reflections,
  }) {
    double testPercent = 0;
    double journalPercent = 0;

    if (testAnswers.isNotEmpty) {
      double avg =
          testAnswers.reduce((a, b) => a + b) / testAnswers.length;

      testPercent = (avg / 50) * 100;
      testPercent = testPercent.clamp(0, 100);
    }

    if (reflections.isNotEmpty) {
      double totalMood = 0;

      for (var r in reflections) {
        String mood = (r['mood'] ?? '').toString();

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
    }

    if (testAnswers.isEmpty && reflections.isEmpty) return 0;

    double finalScore =
        (testPercent * 0.5) + (journalPercent * 0.5);

    return finalScore.clamp(0, 100).round();
  }

  Future<void> loadAll() async {
    final db = DatabaseHelper.instance;

    final testAnswers =
        await db.getLastTestAnswers(widget.email);

    final data = await db.getReflectionHistory(widget.email);

    data.sort((a, b) => (b['date'] ?? '').compareTo(a['date'] ?? ''));

    reflections = data.where((e) {
      try {
        final parsed = DateTime.parse(e['date']);
        return DateTime.now().difference(parsed).inDays <= 7;
      } catch (_) {
        return true;
      }
    }).toList();

    if (!mounted) return;

    setState(() {
      mentalScore = calculateMentalScore(
        testAnswers: testAnswers,
        reflections: reflections,
      );
      loading = false;
    });
  }

  List<String> parseAnswers(dynamic raw) {
    final text = (raw ?? '').toString();

    if (text.isEmpty) {
      return List.filled(questionList.length, "-");
    }

    final blocks = text.split("\n\n");

    return List.generate(questionList.length, (i) {
      if (i >= blocks.length) return "-";

      final parts = blocks[i].split("->");
      return parts.length > 1 ? parts[1].trim() : "-";
    });
  }

  /// ================= FIXED PDF EXPORT (FULL DATA) =================
  Future<void> exportPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            "Laporan Refleksi Jurnal",
            style: pw.TextStyle(fontSize: 18),
          ),
          pw.SizedBox(height: 10),

          pw.Text("Nama: ${getUsername()}"),
          pw.Text("Email: ${widget.email}"),
          pw.Text("Mental Score: $mentalScore%"),
          pw.Divider(),

          ...reflections.map((r) {
            final answers = parseAnswers(r['answers']);

            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 15),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 0.5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [

                  pw.Text("Tanggal: ${r['date'] ?? '-'}"),
                  pw.Text("Mood: ${r['mood'] ?? '-'}"),

                  pw.SizedBox(height: 8),

                  pw.Text(
                    "Jurnal:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(r['journal']?.toString() ?? '-'),

                  pw.SizedBox(height: 8),

                  pw.Text(
                    "Jawaban:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),

                  ...List.generate(questionList.length, (i) {
                    final answer =
                        (i < answers.length) ? answers[i] : "-";

                    return pw.Text(
                      "${questionList[i]}\n-> $answer\n",
                    );
                  }),

                  pw.SizedBox(height: 8),

                  pw.Text(
                    "Insight:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(r['insight']?.toString() ?? '-'),

                  pw.SizedBox(height: 8),

                  pw.Text("Score: $mentalScore%"),
                ],
              ),
            );
          }),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Widget buildCard(Map<String, dynamic> r) {
    final answers = parseAnswers(r['answers']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r['date'] ?? '-',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$mentalScore%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text("Mood: ${r['mood'] ?? '-'}"),
          Text("Jurnal: ${r['journal'] ?? '-'}"),

          const SizedBox(height: 10),

          const Text("Jawaban:"),

          ...List.generate(questionList.length, (i) {
            return Text(
              "${questionList[i]}\n-> ${answers[i]}\n",
            );
          }),

          const SizedBox(height: 8),

          Text("Insight: ${r['insight'] ?? '-'}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),

      appBar: AppBar(
        title: const Text("Laporan Jurnal"),
        backgroundColor: const Color(0xFF6FBF8F),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: exportPDF,
          )
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6FBF8F), Color(0xFFB7F0DC)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Riwayat - ${getUsername()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ...reflections.map((r) => buildCard(r)),
              ],
            ),
    );
  }
}
