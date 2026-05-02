import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'database_helper.dart';
import 'mood_calculator.dart';

class ActivityReportPage extends StatefulWidget {
  final String email;

  const ActivityReportPage({super.key, required this.email});

  @override
  State<ActivityReportPage> createState() => _ActivityReportPageState();
}

class _ActivityReportPageState extends State<ActivityReportPage> {
  List<Map<String, dynamic>> reflections = [];
  List<Map<String, dynamic>> questionnaires = [];
  bool loading = true;

  int mentalScore = 0;
  String username = "";

  Set<int> expandedIndex = {};

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

  Future<String> getUsernameFromDB() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [widget.email],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['username'].toString();
    }
    return widget.email;
  }

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
      double total = 0;

      for (var r in reflections) {
        final journal = (r['journal'] ?? '').toString();
        total += MoodCalculator.journalToScore(journal);
      }

      journalPercent = total / reflections.length;
    }

    if (testAnswers.isEmpty && reflections.isEmpty) return 0;

    double finalScore =
        (testPercent * 0.5) + (journalPercent * 0.5);

    return finalScore.clamp(0, 100).round();
  }

  Future<void> loadAll() async {
    final db = DatabaseHelper.instance;

    final user = await getUsernameFromDB();
    final testAnswers =
        await db.getLastTestAnswers(widget.email);

    final reflectionData =
        await db.getReflectionHistory(widget.email);

    final history =
        await db.getQuestionnaireHistory(widget.email);

    List<Map<String, dynamic>> fullData = [];

    for (var item in history) {
      final cleanDate =
          item['date'].toString().replaceAll('_questionnaire', '');

      final detail =
          await db.getQuestionnaireDetail(widget.email, cleanDate);

      if (detail.isNotEmpty) {
        fullData.add(detail.first);
      }
    }

    if (!mounted) return;

    setState(() {
      username = user;
      questionnaires = fullData;
      reflections = reflectionData;
      mentalScore = calculateMentalScore(
        testAnswers: testAnswers,
        reflections: reflectionData,
      );
      loading = false;
    });
  }

  List<Map<String, dynamic>> parseDetail(String raw) {
    try {
      final decoded = jsonDecode(raw);

      if (decoded is List) {
        return decoded.map<Map<String, dynamic>>((e) {
          return {
            "question": e["question"],
            "answer": e["answer"],
            "point": e["point"],
          };
        }).toList();
      }
    } catch (_) {}

    return [];
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

  Widget buildQuestionItem(Map<String, dynamic> d) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3FBF7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(d['question'],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Jawaban: ${d['answer']}"),
          Text(
            "Score: ${d['point']}",
            style: const TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildQuestionnaireCard(Map<String, dynamic> q, int index) {
    final details = parseDetail(q['detail']);
    final r = index < reflections.length ? reflections[index] : null;
    final answers = r != null ? parseAnswers(r['answers']) : [];

    final isExpanded = expandedIndex.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tanggal: ${q['date']}"),
              IconButton(
                icon: const Icon(
                  Icons.picture_as_pdf,
                  color: Color(0xFF7ED6A5),
                ),
                onPressed: exportPDF,
              )
            ],
          ),

          /// 🔥 SUB JUDUL KUESIONER (FIX DI SINI)
          const Text(
            "Riwayat Kuesioner",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          /// SCORE
          Text(
            "Total Score: ${q['score']}%",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          if (!isExpanded) ...[
            if (details.isNotEmpty) buildQuestionItem(details.first),
            if (r != null)
              Text(
                "Jurnal: ${r['journal'] ?? '-'}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],

          if (isExpanded) ...[
            ...details.map(buildQuestionItem),

            if (r != null) ...[
              const SizedBox(height: 10),
              const Text(
                "Riwayat Jurnal",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Mood: ${r['mood'] ?? '-'}"),
              Text("Jurnal: ${r['journal'] ?? '-'}"),

              const SizedBox(height: 10),

              ...List.generate(questionList.length, (i) {
                return Text(
                  "${questionList[i]}\n-> ${answers[i]}\n",
                );
              }),

              Text("Insight: ${r['insight'] ?? '-'}"),
            ]
          ],

          const SizedBox(height: 8),

          GestureDetector(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedIndex.remove(index);
                } else {
                  expandedIndex.add(index);
                }
              });
            },
            child: Text(
              isExpanded ? "Tutup" : "Baca Selengkapnya",
              style: const TextStyle(
                color: Color(0xFF7ED6A5),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> exportPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text("Laporan Kesehatan Mental"),
          pw.Text("Nama: $username"),
          pw.Text("Score: $mentalScore%"),
          pw.Divider(),

          pw.Text("Riwayat Kuesioner"),
          ...questionnaires.map((q) {
            final details = parseDetail(q['detail']);
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Tanggal: ${q['date']}"),
                pw.Text("Score: ${q['score']}%"),
                ...details.map((d) => pw.Text(
                    "${d['question']} - ${d['answer']} (${d['point']})")),
                pw.Divider()
              ],
            );
          }),

          pw.Text("Riwayat Jurnal"),
          ...reflections.map((r) =>
              pw.Text(r['journal'] ?? '-')),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (f) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5FBF8),
      appBar: AppBar(
        title: const Text("Laporan Data"),
        backgroundColor: const Color(0xFF7ED6A5),
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
                      colors: [
                        Color(0xFF7ED6A5),
                        Color(0xFFCFF5E7)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Riwayat - $username",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18),
                  ),
                ),

                const SizedBox(height: 20),

                ...List.generate(
                  questionnaires.length,
                  (i) => buildQuestionnaireCard(
                      questionnaires[i], i),
                ),
              ],
            ),
    );
  }
}