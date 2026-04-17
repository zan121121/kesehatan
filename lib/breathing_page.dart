import 'package:flutter/material.dart';
import 'dart:async';

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> animation;

  String text = "Tarik Napas";

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

    controller.repeat(reverse: true);

    Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        text = text == "Tarik Napas"
            ? "Hembuskan Napas"
            : "Tarik Napas";
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),

      appBar: AppBar(
        title: const Text("Latihan Pernapasan"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.air,
              size: 60,
              color: Color(0xFF6FBF8F),
            ),

            const SizedBox(height: 20),

            const Text(
              "Ikuti Ritme Pernapasan",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Tarik napas perlahan saat lingkaran membesar\n"
              "dan hembuskan saat lingkaran mengecil.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {

                return Container(
                  width: animation.value,
                  height: animation.value,

                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF6FBF8F),
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
            )

          ],
        ),
      ),
    );
  }
}