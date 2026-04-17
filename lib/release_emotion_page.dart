import 'package:flutter/material.dart';

class ReleaseEmotionPage extends StatefulWidget {
  const ReleaseEmotionPage({super.key});

  @override
  State<ReleaseEmotionPage> createState() => _ReleaseEmotionPageState();
}

class _ReleaseEmotionPageState extends State<ReleaseEmotionPage> {

  final TextEditingController controller = TextEditingController();
  bool released = false;

  void releaseEmotion() {
    if (controller.text.isEmpty) return;

    setState(() {
      released = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),
      appBar: AppBar(
        title: const Text("Lepaskan Emosi"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              "Tuliskan apa yang sedang kamu rasakan",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Aku merasa...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6FBF8F),
              ),
              onPressed: releaseEmotion,
              child: const Text("Lepaskan"),
            ),

            const SizedBox(height: 30),

            AnimatedOpacity(
              opacity: released ? 1 : 0,
              duration: const Duration(seconds: 2),
              child: const Text(
                "Perasaanmu sudah kamu lepaskan 🤍",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}