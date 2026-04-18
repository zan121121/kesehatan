import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BodyScanPage extends StatefulWidget {
  const BodyScanPage({super.key});

  @override
  State<BodyScanPage> createState() => _BodyScanPageState();
}

class _BodyScanPageState extends State<BodyScanPage>
    with SingleTickerProviderStateMixin {

  int step = 0;

  final steps = [
    "Pejamkan mata sejenak dan tarik napas perlahan. Rasakan tubuhmu mulai tenang.",
    "Fokuskan perhatian pada kepala dan wajahmu. Lepaskan ketegangan yang ada.",
    "Sekarang rasakan bahu dan lehermu. Biarkan semuanya terasa lebih ringan.",
    "Perhatikan dada dan pernapasanmu. Rasakan udara masuk dan keluar dengan lembut.",
    "Rasakan perut dan punggungmu menjadi lebih rileks.",
    "Sekarang arahkan perhatian ke kaki dan telapak kakimu.",
    "Rasakan seluruh tubuhmu sekarang lebih tenang dan rileks."
  ];

  /// 🔥 TTS
  final FlutterTts tts = FlutterTts();

  /// 🔥 ANIMASI
  late AnimationController controller;
  late Animation<double> scaleAnim;

  @override
  void initState() {
    super.initState();

    /// setup suara
    tts.setLanguage("id-ID");
    tts.setSpeechRate(0.45);
    tts.setPitch(1.0);

    /// animasi halus (zoom in-out)
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    scaleAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    /// 🔥 bacakan step pertama
    speak(steps[step]);
  }

  Future speak(String text) async {
    await tts.stop();
    await tts.speak(text);
  }

  void nextStep() {

    if (step < steps.length - 1) {

      setState(() {
        step++;
      });

      /// 🔥 suara tiap step
      speak(steps[step]);

    } else {

      tts.stop();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Latihan Selesai"),
          content: const Text(
              "Tubuhmu sekarang lebih rileks. Terima kasih sudah meluangkan waktu untuk dirimu sendiri 🌿"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Selesai"),
            )
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double progress = (step + 1) / steps.length;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Relaksasi Pemindaian Tubuh"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      backgroundColor: const Color(0xfff3f6f5),

      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// 🔥 ICON ANIMASI
              AnimatedBuilder(
                animation: scaleAnim,
                builder: (context, child) {
                  return Transform.scale(
                    scale: scaleAnim.value,
                    child: const Icon(
                      Icons.self_improvement,
                      size: 80,
                      color: Color(0xFF6FBF8F),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Latihan Relaksasi Tubuh",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey,
                color: const Color(0xFF6FBF8F),
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  steps[step],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6FBF8F),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Lanjutkan",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // 🔥 FIX PUTIH
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}