import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BodyScanPage extends StatefulWidget {
  const BodyScanPage({super.key});

  @override
  State<BodyScanPage> createState() => _BodyScanPageState();
}

class _BodyScanPageState extends State<BodyScanPage>
    with TickerProviderStateMixin {

  int step = 0;
  bool isClosing = false;

  final steps = [
    "Pejamkan mata sejenak dan tarik napas perlahan. Rasakan tubuhmu mulai tenang.",
    "Fokuskan perhatian pada kepala dan wajahmu. Lepaskan ketegangan yang ada.",
    "Sekarang rasakan bahu dan lehermu. Biarkan semuanya terasa lebih ringan.",
    "Perhatikan dada dan pernapasanmu. Rasakan udara masuk dan keluar dengan lembut.",
    "Rasakan perut dan punggungmu menjadi lebih rileks.",
    "Sekarang arahkan perhatian ke kaki dan telapak kakimu.",
    "Rasakan seluruh tubuhmu sekarang lebih tenang dan rileks."
  ];

  /// 🔥 AI PENUTUP
  final String closingText =
      "Sekarang perlahan sadari kembali tubuhmu secara utuh. "
      "Tarik napas dalam... dan hembuskan perlahan. "
      "Kamu telah meluangkan waktu untuk dirimu sendiri. "
      "Semoga ketenangan ini tetap bersamamu sepanjang hari.";

  final FlutterTts tts = FlutterTts();

  late AnimationController scaleController;
  late Animation<double> scaleAnim;

  late AnimationController fadeController;
  late Animation<double> fadeAnim;

  @override
  void initState() {
    super.initState();

    tts.setLanguage("id-ID");
    tts.setSpeechRate(0.45);
    tts.setPitch(1.0);

    /// 🔥 AUTO NEXT
    tts.setCompletionHandler(() {
      if (!isClosing) {
        nextStepAuto();
      } else {
        showFinishDialog();
      }
    });

    /// 🔥 ANIMASI NAFAS
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    scaleAnim = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: scaleController, curve: Curves.easeInOut),
    );

    /// 🔥 FADE TEXT
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    fadeAnim = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeIn,
    );

    fadeController.forward();

    /// START
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
      /// 🔥 MASUK KE AI PENUTUP
      isClosing = true;

      await fadeController.reverse();

      setState(() {});

      fadeController.forward();

      speak(closingText);
    }
  }

  void showFinishDialog() {
    tts.stop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text("✨ Relaksasi Selesai"),
        content: const Text(
          "Relaksasi Anda telah selesai.\n\nTubuh Anda kini lebih tenang dan rileks 🌿",
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

    double progress = isClosing
        ? 1
        : (step + 1) / steps.length;

    return Scaffold(
      backgroundColor: const Color(0xffeef6f2),

      appBar: AppBar(
        title: const Text("Relaksasi Pemindaian Tubuh"),
        centerTitle: true,
        elevation: 0,
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

                /// 🔥 ANIMASI NAFAS
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
                          Icons.self_improvement,
                          size: 60,
                          color: Color(0xFF6FBF8F),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                const Text(
                  "Relaksasi Tubuh",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor: Colors.grey.shade300,
                  color: const Color(0xFF6FBF8F),
                ),

                const SizedBox(height: 30),

                /// 🔥 TEXT DINAMIS (STEP / CLOSING)
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
                      isClosing ? closingText : steps[step],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Text(
                  isClosing
                      ? "Nikmati ketenangan ini sejenak..."
                      : "Dengarkan dan rasakan setiap bagian tubuhmu...",
                  style: const TextStyle(
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