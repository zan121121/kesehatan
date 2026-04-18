import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LetGoPage extends StatefulWidget {
  const LetGoPage({super.key});

  @override
  State<LetGoPage> createState() => _LetGoPageState();
}

class _LetGoPageState extends State<LetGoPage> {

  final TextEditingController controller = TextEditingController();
  final FlutterTts tts = FlutterTts();

  bool sudahDilepas = false;
  String responAI = "";

  @override
  void initState() {
    super.initState();

    tts.setLanguage("id-ID");
    tts.setSpeechRate(0.45);
    tts.setPitch(1.0);
  }

  /// 🔥 LOGIC AI (berdasarkan keyword)
  String generateResponse(String input) {
    String text = input.toLowerCase();

    if (text.contains("capek") || text.contains("lelah")) {
      return "Sepertinya kamu sedang sangat lelah. Tidak apa-apa untuk beristirahat sejenak. Kamu sudah melakukan yang terbaik hari ini.";
    } 
    else if (text.contains("sedih") || text.contains("kecewa")) {
      return "Perasaan sedih itu valid. Tidak apa-apa merasakannya. Beri dirimu waktu untuk memproses semuanya dengan perlahan.";
    } 
    else if (text.contains("marah") || text.contains("kesal")) {
      return "Rasa marah itu wajar. Coba tarik napas perlahan dan lepaskan emosi itu sedikit demi sedikit.";
    } 
    else if (text.contains("takut") || text.contains("cemas") || text.contains("khawatir")) {
      return "Kamu tidak sendirian. Rasa cemas itu bisa datang, tapi kamu tetap bisa mengendalikannya. Fokus pada napasmu sekarang.";
    } 
    else if (text.contains("gagal") || text.contains("tidak bisa")) {
      return "Kegagalan bukan akhir dari segalanya. Itu adalah bagian dari proses belajar. Kamu masih punya banyak kesempatan.";
    } 
    else if (text.contains("sendiri") || text.contains("kesepian")) {
      return "Meskipun terasa sepi, kamu tidak benar-benar sendiri. Ada orang yang peduli padamu, termasuk dirimu sendiri.";
    } 
    else if (text.contains("stress") || text.contains("tertekan")) {
      return "Kamu sedang menghadapi banyak hal. Coba lepaskan sedikit demi sedikit. Tidak semua harus diselesaikan sekarang.";
    } 
    else {
      return "Terima kasih sudah berbagi. Menuliskan perasaan adalah langkah yang baik. Sekarang tarik napas perlahan dan biarkan pikiran itu pergi.";
    }
  }

  Future speak(String text) async {
    await tts.stop();
    await tts.speak(text);
  }

  void lepaskanPikiran() {

    if (controller.text.isEmpty) return;

    String hasil = generateResponse(controller.text);

    setState(() {
      sudahDilepas = true;
      responAI = hasil;
    });

    /// 🔥 SUARA AI
    speak(hasil);
  }

  @override
  void dispose() {
    controller.dispose();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Melepas Pikiran"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      backgroundColor: const Color(0xfff3f6f5),

      body: SingleChildScrollView(
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
                  child: Column(
                    children: [

                      const Text(
                        "Respon untukmu 💬",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        responAI,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),

                    ],
                  ),
                )

            ],
          ),
        ),
      ),
    );
  }
}