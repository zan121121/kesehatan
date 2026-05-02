import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GroundingPage extends StatefulWidget {
  const GroundingPage({super.key});

  @override
  State<GroundingPage> createState() => _GroundingPageState();
}

class _GroundingPageState extends State<GroundingPage>
    with TickerProviderStateMixin {

  int step = 0;

  final steps = [
    "Sekarang, sebutkan 5 hal yang kamu lihat di sekitarmu.",
    "Sekarang, sebutkan 4 hal yang bisa kamu sentuh.",
    "Sekarang, dengarkan... sebutkan 3 suara yang bisa kamu dengar.",
    "Tarik napas perlahan... sebutkan 2 aroma yang bisa kamu rasakan.",
    "Terakhir, sebutkan 1 hal yang kamu syukuri hari ini."
  ];

  final String closingText =
      "Latihan menenangkan diri telah selesai. "
      "Kamu telah berhasil membawa pikiranmu kembali ke saat ini. "
      "Ingat, kamu aman, kamu cukup, dan kamu kuat 🌿";

  final FlutterTts tts = FlutterTts();

  late AnimationController scaleController;
  late Animation<double> scaleAnim;

  late AnimationController fadeController;
  late Animation<double> fadeAnim;

  @override
  void initState() {
    super.initState();

    /// 🔊 TTS SETUP
    tts.setLanguage("id-ID");
    tts.setSpeechRate(0.42);
    tts.setPitch(1.0);

    /// 🔥 AUTO NEXT
    tts.setCompletionHandler(() {
      nextStepAuto();
    });

    /// 🔥 ANIMASI NAFAS
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    scaleAnim = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: scaleController, curve: Curves.easeInOut),
    );

    /// 🔥 ANIMASI FADE TEXT
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    fadeAnim = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeIn,
    );

    fadeController.forward();

    /// 🔥 START
    speak(steps[step]);
  }

  Future speak(String text) async {
    await tts.stop();
    await tts.speak(text);
  }

  void nextStepAuto() async {
    if (step < steps.length - 1) {

      await fadeController.reverse();

      setState(() {
        step++;
      });

      fadeController.forward();

      speak(steps[step]);

    } else {

      /// 🔥 STEP TERAKHIR → LANJUT KE CLOSING AI
      await Future.delayed(const Duration(seconds: 1));

      speak(closingText);

      /// 🔥 TUNGGU SUARA SELESAI → POPUP
      tts.setCompletionHandler(() {
        showFinishDialog();
      });
    }
  }

  void showFinishDialog() {
    tts.stop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("✨ Grounding Selesai"),
        content: const Text(
          "Kamu sudah menyelesaikan latihan grounding.\n\n"
          "Pikiranmu sekarang lebih tenang dan fokus 🌿",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6FBF8F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Selesai",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    scaleController.dispose();
    fadeController.dispose();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double progress = (step + 1) / steps.length;

    return Scaffold(
      backgroundColor: const Color(0xffeef6f2),

      appBar: AppBar(
        title: const Text("Latihan Menenangkan Diri"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8F5F0),
              Color(0xFFD6F0E3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// 🔥 ANIMASI ICON (NAFAS)
                AnimatedBuilder(
                  animation: scaleAnim,
                  builder: (_, child) {
                    return Transform.scale(
                      scale: scaleAnim.value,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.spa,
                          size: 60,
                          color: Color(0xFF6FBF8F),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                /// TITLE
                const Text(
                  "Latihan Fokus Pikiran",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// PROGRESS
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor: Colors.grey.shade300,
                  color: const Color(0xFF6FBF8F),
                ),

                const SizedBox(height: 30),

                /// 🔥 TEXT
                FadeTransition(
                  opacity: fadeAnim,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                        )
                      ],
                    ),
                    child: Text(
                      steps[step],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// HINT
                const Text(
                  "Fokuskan dirimu pada momen saat ini...",
                  style: TextStyle(
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}