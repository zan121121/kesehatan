import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'database_helper.dart';
import 'breathing_page.dart';
import 'grounding_page.dart';
import 'bodyscan_page.dart';
import 'letgo_page.dart';

class HealingPage extends StatefulWidget {
  final String email;

  const HealingPage({super.key, required this.email});

  @override
  State<HealingPage> createState() => _HealingPageState();
}

class _HealingPageState extends State<HealingPage> {

  int moodScore = 0;
  String recommendation = "";

  final AudioPlayer player = AudioPlayer();

  String? currentSound;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    final moods = await DatabaseHelper.instance.getLast2Mood(widget.email);

    if (moods.isNotEmpty) {
      moodScore = moods.first;

      if (moodScore < 40) {
        recommendation =
            "Hari ini terasa berat. Mari mulai dengan latihan napas perlahan.";
      } 
      else if (moodScore < 70) {
        recommendation =
            "Perasaanmu naik turun. Sedikit latihan relaksasi bisa membantu.";
      } 
      else {
        recommendation =
            "Kondisi kamu cukup stabil. Latihan ini bisa membantu menjaga keseimbangan.";
      }
    }

    setState(() {});
  }

  Future<void> playSound(String path) async {

    if (currentSound == path && isPlaying) {
      await player.stop();
      setState(() {
        isPlaying = false;
        currentSound = null;
      });
    } else {

      await player.stop();
      await player.setReleaseMode(ReleaseMode.loop);
      await player.play(AssetSource(path));

      setState(() {
        isPlaying = true;
        currentSound = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6FBF8F),
        title: const Text("Latihan Pemulihan"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// STATUS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6FBF8F),
                    Color(0xFFA8E6CF)
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Latihan Psikologi Virtual 🌿",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    recommendation,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// PRACTICE
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              physics: const NeverScrollableScrollPhysics(),

              children: [

                practiceCard("🫁","Latihan Napas",(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BreathingPage(),
                    ),
                  );
                }),

                practiceCard("🌿","Menenangkan Diri",(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GroundingPage(),
                    ),
                  );
                }),

                practiceCard("🧠","Pemindaian Tubuh",(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BodyScanPage(),
                    ),
                  );
                }),

                practiceCard("🌊","Melepas Pikiran",(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LetGoPage(),
                    ),
                  );
                }),

              ],
            ),

            const SizedBox(height: 30),

            /// SUARA TENANG
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Suara Menenangkan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Column(
              children: [

                soundButton("🌲 Suara Hutan Tenang", "sounds/musik1.mp3"),
                soundButton("🌊 Suara Laut", "sounds/musik2.mp3"),
                soundButton("🌧️ Suara Hujan", "sounds/musik3.mp3"),

              ],
            )

          ],
        ),
      ),
    );
  }

  /// PRACTICE CARD
  Widget practiceCard(String icon,String title,VoidCallback onTap){

    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(icon,style: const TextStyle(fontSize: 40)),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )

          ],
        ),
      ),
    );
  }

  /// SOUND BUTTON
  Widget soundButton(String title,String file){

    bool playing = currentSound == file && isPlaying;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),

        child: Row(
          children: [

            IconButton(
              icon: Icon(
                playing ? Icons.stop : Icons.play_arrow,
              ),
              onPressed: (){
                playSound(file);
              },
            ),

            const SizedBox(width: 10),

            Text(title)

          ],
        ),
      ),
    );
  }
}