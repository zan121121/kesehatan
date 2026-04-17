import 'package:flutter/material.dart';

class GroundingPage extends StatefulWidget {
  const GroundingPage({super.key});

  @override
  State<GroundingPage> createState() => _GroundingPageState();
}

class _GroundingPageState extends State<GroundingPage> {

  int step = 0;

  final steps = [

    "Sebutkan 5 hal yang kamu lihat di sekitarmu.",

    "Sebutkan 4 hal yang bisa kamu sentuh.",

    "Sebutkan 3 suara yang bisa kamu dengar.",

    "Sebutkan 2 aroma yang bisa kamu rasakan.",

    "Sebutkan 1 hal yang kamu syukuri hari ini."
  ];

  void nextStep(){

    if(step < steps.length - 1){

      setState(() {
        step++;
      });

    }else{

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

              const Icon(
                Icons.spa,
                size: 80,
                color: Color(0xFF6FBF8F),
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