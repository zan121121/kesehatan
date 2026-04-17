import 'package:flutter/material.dart';

class BodyScanPage extends StatefulWidget {
  const BodyScanPage({super.key});

  @override
  State<BodyScanPage> createState() => _BodyScanPageState();
}

class _BodyScanPageState extends State<BodyScanPage> {

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

  void nextStep() {

    if (step < steps.length - 1) {

      setState(() {
        step++;
      });

    } 
    else {

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

              const Icon(
                Icons.self_improvement,
                size: 80,
                color: Color(0xFF6FBF8F),
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

              /// Progress latihan

              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
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

              /// Tombol lanjut

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