import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

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

  /// ================= MOOD DETECTION (NO EMOJI OUTPUT) =================
  String detectMood(String text) {
    text = text.toLowerCase();

    if (text.contains("capek") || text.contains("lelah")) return "Lelah";
    if (text.contains("sedih") || text.contains("hancur")) return "Sedih";
    if (text.contains("marah") || text.contains("kesal")) return "Marah";
    if (text.contains("cemas") || text.contains("takut")) return "Cemas";
    if (text.contains("senang") || text.contains("bahagia")) return "Bahagia";

    return "Netral";
  }

  /// ================= SISTEM PAKAR DIPERLUAS =================
  String generatePsychologistInsight(String text) {
    final t = text.toLowerCase();

    // RISIKO BERAT
    if (t.contains("bunuh diri") ||
        t.contains("mengakhiri hidup") ||
        t.contains("mati saja")) {
      return "Kamu sedang berada dalam tekanan sangat berat. Kamu tidak perlu menghadapi ini sendirian. Cobalah segera berbicara dengan orang terpercaya atau bantuan profesional.";
    }

    if (t.contains("hampa") ||
        t.contains("kosong") ||
        t.contains("tidak ada arti")) {
      return "Perasaan kosong bisa muncul saat mental terlalu lelah. Ini tanda kamu perlu istirahat, bukan menyerah.";
    }

    if (t.contains("overthinking") ||
        t.contains("kepikiran terus") ||
        t.contains("tidak bisa tidur")) {
      return "Pikiranmu sedang terlalu penuh. Coba tulis semua hal yang kamu pikirkan, lalu fokus pada satu hal kecil yang bisa kamu kontrol.";
    }

    // KELUARGA
    if (t.contains("keluarga") ||
        t.contains("orang tua") ||
        t.contains("rumah")) {
      return "Masalah keluarga bisa terasa berat. Kamu tidak harus menanggung semuanya sendiri. Komunikasi kecil bisa membantu.";
    }

    // SOSIAL
    if (t.contains("teman") ||
        t.contains("dikhianati") ||
        t.contains("dibohongi")) {
      return "Hubungan sosial tidak selalu mudah. Pilih lingkungan yang membuatmu merasa aman dan dihargai.";
    }

    // KESENDIRIAN
    if (t.contains("sendiri") || t.contains("sepi") || t.contains("ditinggalkan")) {
      return "Kesepian adalah perasaan yang valid. Itu tidak berarti kamu benar-benar sendirian.";
    }

    // STRES
    if (t.contains("stress") ||
        t.contains("tertekan") ||
        t.contains("tekanan")) {
      return "Kamu sedang berada dalam tekanan mental. Istirahat bukan kemunduran, tapi kebutuhan.";
    }

    // CEMAS
    if (t.contains("cemas") ||
        t.contains("takut") ||
        t.contains("khawatir")) {
      return "Kecemasan sering muncul dari hal yang belum terjadi. Fokus pada hal yang bisa kamu kendalikan sekarang.";
    }

    // MARAH
    if (t.contains("marah") || t.contains("emosi") || t.contains("kesal")) {
      return "Emosi yang tinggi adalah sinyal penting. Ambil jeda sebelum bereaksi.";
    }

    // KEGAGALAN
    if (t.contains("gagal") || t.contains("bodoh") || t.contains("tidak bisa")) {
      return "Kegagalan bukan identitas diri. Itu bagian dari proses belajar.";
    }

    // POSITIF
    if (t.contains("senang") ||
        t.contains("bahagia") ||
        t.contains("bersyukur")) {
      return "Pengalaman positif hari ini penting untuk disadari. Pertahankan hal-hal yang membuatmu stabil.";
    }

    return "Menulis seperti ini membantu kamu memahami diri sendiri lebih dalam.";
  }

  /// ================= SAVE =================
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

    final mood = detectMood(text);
    final insight = generatePsychologistInsight(text);

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
      mood: mood,
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
      const SnackBar(content: Text("Refleksi tersimpan +10 🪙")),
    );

    journalController.clear();
    answers.clear();

    await loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),

      appBar: AppBar(
        title: const Text("Jurnal"),
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
            child: const Text("Simpan Jurnal",    
             style: TextStyle(color: Colors.white), // ✅ FIX FONT PUTIH
),
            
          ),

          const SizedBox(height: 15),

          if (journalInsight.isNotEmpty)
            buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Insight Psikologis",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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