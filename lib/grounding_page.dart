import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GroundingPage extends StatefulWidget {
  const GroundingPage({super.key});

  @override
  State<GroundingPage> createState() => _GroundingPageState();
}

class _GroundingPageState extends State<GroundingPage>
    with SingleTickerProviderStateMixin {

  int step = 0;

  final steps = [
    "Sebutkan 5 hal yang kamu lihat di sekitarmu.",
    "Sebutkan 4 hal yang bisa kamu sentuh.",
    "Sebutkan 3 suara yang bisa kamu dengar.",
    "Sebutkan 2 aroma yang bisa kamu rasakan.",
    "Sebutkan 1 hal yang kamu syukuri hari ini."
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
    tts.setSpeechRate(0.45); // pelan & calming
    tts.setPitch(1.0);

    /// setup animasi (naik turun pelan)
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    scaleAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    /// 🔥 langsung bacakan step pertama
    speak(steps[step]);
  }

  Future speak(String text) async {
    await tts.stop(); // biar ga numpuk
    await tts.speak(text);
  }

  void nextStep(){

    if(step < steps.length - 1){

      setState(() {
        step++;
      });

      /// 🔥 suara tiap step
      speak(steps[step]);

    }else{

      tts.stop();

      showDialog(
        context: context,
        builder: (_)=>AlertDialog(
          title: const Text("Latihan Selesai"),
          content: const Text(
              "Kamu sudah menyelesaikan latihan grounding dengan baik 🌿"),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Kembali"),
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
        title: const Text("Latihan Grounding"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      backgroundColor: const Color(0xfff3f6f5),

      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// 🔥 ICON + ANIMASI GERAK HALUS
              AnimatedBuilder(
                animation: scaleAnim,
                builder: (context, child) {
                  return Transform.scale(
                    scale: scaleAnim.value,
                    child: const Icon(
                      Icons.spa,
                      size: 80,
                      color: Color(0xFF6FBF8F),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Latihan Fokus Pikiran",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// Progress latihan
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey,
                color: const Color(0xFF6FBF8F),
              ),

              const SizedBox(height: 30),

              /// Instruksi latihan
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