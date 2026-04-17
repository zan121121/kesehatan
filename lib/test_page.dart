import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class TestPage extends StatefulWidget {
  final String email;

  const TestPage({super.key, required this.email});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int currentSection = 0;
  int currentQuestion = 0;

  bool isAllowed = true;
  bool isLoading = true;

  late List<int?> answers;

  @override
  void initState() {
    super.initState();
    answers = List.generate(45, (_) => null);
    checkAccess();
  }

  Future<void> checkAccess() async {
    bool allowed = await DatabaseHelper.instance.canTakeTest(widget.email);

    setState(() {
      isAllowed = allowed;
      isLoading = false;
    });
  }

  /// ================= DATA =================

  final List<String> mentalQuestions = const [
    "Dalam 2 minggu terakhir, apakah kamu sering merasa cemas tanpa alasan yang jelas?",
    "Apakah kamu kehilangan minat pada hal yang biasanya kamu sukai?",
    "Apakah kamu sering merasa lelah secara emosional walaupun tidak melakukan aktivitas berat?",
    "Apakah kamu sulit fokus saat belajar atau bekerja?",
    "Apakah kamu sering merasa tidak berharga atau menyalahkan diri sendiri?",
    "Apakah tidur kamu akhir-akhir ini tidak teratur?",
    "Apakah kamu mudah tersinggung atau marah tanpa sebab jelas?",
    "Apakah kamu merasa tertekan dalam aktivitas sehari-hari?",
    "Apakah kamu sering overthinking sebelum tidur?",
    "Apakah kamu merasa tidak punya energi untuk menjalani hari?",
    "Apakah kamu merasa sendirian meskipun ada orang di sekitar?",
    "Apakah kamu sering merasa gelisah tanpa sebab?",
    "Apakah kamu sulit menikmati hal kecil dalam hidup?",
    "Apakah kamu merasa masa depan terlihat tidak jelas?",
    "Apakah kamu merasa perlu bantuan tetapi tidak tahu harus mulai dari mana?",
  ];

  final List<String> personalityQuestions = const [
    "Saya lebih nyaman menyelesaikan masalah sendiri daripada meminta bantuan orang lain.",
    "Saya mudah beradaptasi di lingkungan baru.",
    "Saya cenderung memikirkan sesuatu terlalu dalam sebelum bertindak.",
    "Saya lebih suka berada di lingkungan tenang daripada ramai.",
    "Saya mudah memahami perasaan orang lain.",
    "Saya sering ragu dalam mengambil keputusan.",
    "Saya merasa percaya diri dalam situasi sosial.",
    "Saya membutuhkan waktu sendiri untuk mengisi energi.",
    "Saya mudah terpengaruh oleh opini orang lain.",
    "Saya lebih fokus pada perasaan daripada logika.",
    "Saya bisa tetap tenang dalam tekanan.",
    "Saya suka merencanakan sesuatu dengan detail.",
    "Saya sering memikirkan kemungkinan terburuk.",
    "Saya lebih suka mendengarkan daripada berbicara.",
    "Saya nyaman menjadi pusat perhatian.",
    "Saya mudah merasa bersalah atas kesalahan kecil.",
    "Saya bisa mengontrol emosi dengan baik.",
    "Saya lebih suka rutinitas yang stabil.",
    "Saya sering introspeksi diri.",
    "Saya bisa memahami diri sendiri dengan baik.",
  ];

  final List<String> reflectionQuestions = const [
    "Seberapa sering kamu meluangkan waktu untuk mengevaluasi diri sendiri?",
    "Apakah kamu memahami apa yang membuatmu stres?",
    "Apakah kamu tahu cara menenangkan diri saat emosi tinggi?",
    "Apakah kamu merasa hidupmu berjalan sesuai tujuan?",
    "Apakah kamu pernah menuliskan isi pikiranmu?",
    "Apakah kamu bisa mengenali batas kemampuanmu?",
    "Apakah kamu tahu apa yang benar-benar kamu butuhkan saat ini?",
    "Apakah kamu sering memikirkan masa depanmu?",
    "Apakah kamu merasa sudah cukup peduli pada diri sendiri?",
    "Apakah kamu bisa menerima kegagalan dengan tenang?",
  ];

  /// ================= LOGIC =================

  int getStartIndex() {
    if (currentSection == 0) return 0;
    if (currentSection == 1) return 15;
    return 35;
  }

  List<String> getCurrentQuestions() {
    if (currentSection == 0) return mentalQuestions;
    if (currentSection == 1) return personalityQuestions;
    return reflectionQuestions;
  }

  int getIndex() => getStartIndex() + currentQuestion;

  void selectAnswer(int value) {
    setState(() {
      answers[getIndex()] = value;
    });
  }

  void nextQuestion() {
    final questions = getCurrentQuestions();

    if (answers[getIndex()] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih jawaban dulu")),
      );
      return;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() => currentQuestion++);
    } else {
      nextSection();
    }
  }

  void nextSection() async {
    bool completed = answers
        .sublist(getStartIndex(), getStartIndex() + getCurrentQuestions().length)
        .every((e) => e != null);

    if (!completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jawab semua pertanyaan dulu")),
      );
      return;
    }

    if (currentSection < 2) {
      setState(() {
        currentSection++;
        currentQuestion = 0;
      });
    } else {
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// 🔥 HITUNG SCORE
  int score = calculateTestScore();

  /// 🔥 SIMPAN KE MOOD
  await DatabaseHelper.instance.insertMood(
    widget.email,
    today + "_test",
    score,
    "Hasil test mental",
  );

  /// 🔥 TAMBAH POINT
  await DatabaseHelper.instance.addPoint(widget.email, "test", today);

  if (context.mounted) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tes Selesai"),
        content: Text("Skor mental kamu: $score% 💚 + 50 🪙 "),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.popUntil(context, (route) => route.isFirst);
    });
  }
}
  }

  int calculateTestScore() {
  double total = 0;

  for (int i = 0; i < answers.length; i++) {
    int val = answers[i] ?? 0;

    /// ================= MENTAL (dibalik) =================
    if (i < 15) {
      if (val == 0) total += 100; // Tidak Pernah (bagus)
      if (val == 1) total += 50;  // Terkadang
      if (val == 2) total += 0;   // Selalu (buruk)
    }

    /// ================= PERSONALITY =================
    else if (i < 35) {
      total += val * 25; // 0 - 100
    }

    /// ================= REFLECTION =================
    else {
      total += val * 50; // 0 - 100
    }
  }

  return (total / answers.length).round();
}

  /// ================= UI =================

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!isAllowed) {
  return Scaffold(
    backgroundColor: const Color(0xfff3f6f5),
    appBar: AppBar(
      backgroundColor: const Color(0xFF6FBF8F),

      /// tombol kembali kiri atas
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      title: const Text("Tes Kesehatan Mental"),
    ),
    body: Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10)
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_clock, size: 60, color: Colors.orange),
            SizedBox(height: 15),
            Text(
              "Tes Sudah Dikerjakan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Kamu bisa mengerjakan lagi setelah 3 hari ya 😊",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

    final questions = getCurrentQuestions();
    final question = questions[currentQuestion];

    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF6FBF8F),
        elevation: 0,
        title: const Text("Tes Kesehatan Mental"),
      ),

      body: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF6FBF8F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (i) {
                return CircleAvatar(
                  backgroundColor: currentSection == i
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                  child: Text(
                    "${i + 1}",
                    style: TextStyle(
                      color: currentSection == i
                          ? Colors.green
                          : Colors.white,
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10)
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Soal ${currentQuestion + 1} / ${questions.length}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: (currentQuestion + 1) / questions.length,
                      color: const Color(0xFF6FBF8F),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      question,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    Expanded(child: buildAnswerUI()),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6FBF8F),
                        ),
                        onPressed: nextQuestion,
                        child: Text(
                          currentQuestion == questions.length - 1
                              ? (currentSection == 2
                                  ? "Kirim Jawaban"
                                  : "Lanjut Bagian")
                              : "Lanjut",
                              style: const TextStyle(
    color: Colors.white,
                        ),
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// ================= UI PER SECTION =================

  Widget buildAnswerUI() {
    if (currentSection == 0) return checklistUI();
    if (currentSection == 1) return emojiUI();
    return cardChoiceUI();
  }

  Widget checklistUI() {
    final options = ["Tidak Pernah","Terkadang","Selalu"];

    return Column(
      children: List.generate(options.length, (i) {
        return RadioListTile<int>(
          value: i,
          groupValue: answers[getIndex()],
          activeColor: const Color(0xFF6FBF8F),
          onChanged: (v) => selectAnswer(v!),
          title: Text(options[i]),
        );
      }),
    );
  }

  Widget emojiUI() {
    final emojis = ["😡", "😟", "😐", "🙂", "😍"];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 15,
      runSpacing: 15,
      children: List.generate(emojis.length, (i) {
        return GestureDetector(
          onTap: () => selectAnswer(i),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: answers[getIndex()] == i
                  ? const Color(0xFF6FBF8F)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              emojis[i],
              style: const TextStyle(fontSize: 26),
            ),
          ),
        );
      }),
    );
  }

  Widget cardChoiceUI() {
    final options = ["Tidak Pernah","Jarang", "Selalu"];

    return Column(
      children: List.generate(options.length, (i) {
        return GestureDetector(
          onTap: () => selectAnswer(i),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: answers[getIndex()] == i
                  ? const Color(0xFF6FBF8F)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.favorite,
                    color: answers[getIndex()] == i
                        ? Colors.white
                        : Colors.grey),
                const SizedBox(width: 10),
                Text(
                  options[i],
                  style: TextStyle(
                    color: answers[getIndex()] == i
                        ? Colors.white
                        : Colors.black,
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}