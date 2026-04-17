import 'package:flutter/material.dart';

class LetGoPage extends StatefulWidget {
  const LetGoPage({super.key});

  @override
  State<LetGoPage> createState() => _LetGoPageState();
}

class _LetGoPageState extends State<LetGoPage> {

  final TextEditingController controller = TextEditingController();
  bool sudahDilepas = false;

  void lepaskanPikiran() {
    if (controller.text.isEmpty) return;

    setState(() {
      sudahDilepas = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Melepas Pikiran"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      backgroundColor: const Color(0xfff3f6f5),

      body: SingleChildScrollView( // ✅ FIX OVERFLOW
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              const Text(
                "Tuliskan pikiran yang sedang mengganggumu\nlalu lepaskan perlahan 🌿",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controller,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Tuliskan apa yang kamu rasakan...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: lepaskanPikiran,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6FBF8F),
                ),
                child: const Text(
                  "Lepaskan Pikiran",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 30),

              if (sudahDilepas)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Pikiran itu sudah kamu lepaskan.\nSekarang tarik napas perlahan dan biarkan ia pergi 🌿",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )

            ],
          ),
        ),
      ),
    );
  }
}