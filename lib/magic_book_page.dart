import 'package:flutter/material.dart';
import 'dart:math';

class MagicBookPage extends StatefulWidget {
  const MagicBookPage({super.key});

  @override
  State<MagicBookPage> createState() => _MagicBookPageState();
}

class _MagicBookPageState extends State<MagicBookPage> {

  final List<String> quotes = [
    "Kamu lebih kuat dari yang kamu pikirkan.",
    "Istirahat juga bagian dari perjalanan.",
    "Hari buruk tidak berarti hidupmu buruk.",
    "Pelan-pelan juga tidak apa-apa.",
    "Kamu layak merasa damai."
  ];

  String currentQuote = "";

  void generateQuote() {
    final random = Random();
    setState(() {
      currentQuote = quotes[random.nextInt(quotes.length)];
    });
  }

  @override
  void initState() {
    super.initState();
    generateQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),
      appBar: AppBar(
        title: const Text("Magic Book"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Icon(Icons.menu_book, size: 60, color: Colors.green),

              const SizedBox(height: 20),

              Text(
                currentQuote,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: generateQuote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6FBF8F),
                ),
                child: const Text("Halaman Baru"),
              )
            ],
          ),
        ),
      ),
    );
  }
}