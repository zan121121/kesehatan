import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> animation;

  final FlutterTts tts = FlutterTts();

  String text = "Tarik Napas";
  Timer? timer;

  bool isStarted = false;

  /// 🔥 JUMLAH SIKLUS (REALISTIS)
  int cycle = 0;
  final int maxCycle = 8; // ⭐ ideal calming

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    animation = Tween<double>(begin: 150, end: 230).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    /// 🔊 TTS
    tts.setLanguage("id-ID");
    tts.setSpeechRate(0.4);
    tts.setPitch(1.0);
  }

  /// 🔥 START
  void startBreathing() {
    if (isStarted) return;

    setState(() {
      isStarted = true;
      cycle = 0;
    });

    controller.repeat(reverse: true);

    speak("Mulai tarik napas perlahan");

    timer = Timer.periodic(const Duration(seconds: 4), (timer) {

      setState(() {
        text = text == "Tarik Napas"
            ? "Hembuskan Napas"
            : "Tarik Napas";
      });

      /// 🔥 HITUNG 1 SIKLUS (tarik + hembus = 1)
      if (text == "Tarik Napas") {
        cycle++;
      }

      /// 🔊 SUARA
      speak(text);

      /// 🔥 AUTO STOP
      if (cycle >= maxCycle) {
        finishBreathing();
      }
    });
  }

  /// 🔥 STOP NORMAL
  void stopBreathing() {
    controller.stop();
    timer?.cancel();
    tts.stop();

    setState(() {
      isStarted = false;
      text = "Tarik Napas";
      cycle = 0;
    });
  }

  /// 🔥 SELESAI OTOMATIS
  void finishBreathing() async {
    timer?.cancel();
    controller.stop();

    await speak(
      "Latihan pernapasan selesai. "
      "Sekarang tubuhmu lebih tenang dan pikiranmu lebih rileks 🌿",
    );

    setState(() {
      isStarted = false;
      text = "Selesai";
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("✨ Selesai"),
        content: const Text(
          "Kamu telah menyelesaikan latihan pernapasan.\n\n"
          "Rasakan ketenangan di dalam tubuhmu 🌿",
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
              ),
              child: const Text(
                "Tutup",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future speak(String msg) async {
    await tts.stop();
    await tts.speak(msg);
  }

  @override
  void dispose() {
    controller.dispose();
    timer?.cancel();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffeef6f2),

      appBar: AppBar(
        title: const Text("Latihan Pernapasan"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.air,
              size: 70,
              color: Color(0xFF6FBF8F),
            ),

            const SizedBox(height: 20),

            const Text(
              "Ikuti Ritme Pernapasan",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Siklus: $cycle / $maxCycle",
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 40),

            /// 🔥 ANIMASI LINGKARAN
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Container(
                  width: animation.value,
                  height: animation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6FBF8F),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            /// 🔥 BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6FBF8F),
                minimumSize: const Size(150, 50),
              ),
              onPressed: isStarted ? stopBreathing : startBreathing,
              child: Text(
                isStarted ? "Berhenti" : "Mulai",
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}