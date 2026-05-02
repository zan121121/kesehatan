import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {

  int pageIndex = 0;
  late AnimationController _controller;

  List<bool> showItems = [false, false, false, false, false];

  final TextStyle titleStyle = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.teal,
  );

  final TextStyle descStyle = const TextStyle(
    fontSize: 13,
    color: Colors.black87,
    height: 1.4,
  );

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    /// animasi muncul satu-satu
    for (int i = 0; i < showItems.length; i++) {
      Future.delayed(Duration(milliseconds: 400 * i), () {
        if (mounted) {
          setState(() {
            showItems[i] = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextPage() async {
    if (pageIndex < 2) {
      setState(() {
        pageIndex++;
        resetAnimation();
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("first_open", false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  /// reset animasi tiap pindah page
  void resetAnimation() {
    for (int i = 0; i < showItems.length; i++) {
      showItems[i] = false;
    }

    for (int i = 0; i < showItems.length; i++) {
      Future.delayed(Duration(milliseconds: 400 * i), () {
        if (mounted) {
          setState(() {
            showItems[i] = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// BACKGROUND
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFA8E6CF),
                      Color(0xFFDCEDC1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),

          /// MAIN CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [

                  const SizedBox(height: 20),

                  /// PAGE CONTENT
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: getPage(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6FBF8F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: nextPage,
                      child: Text(
                        pageIndex == 2 ? "Mulai Sekarang" : "Lanjut",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// ================= PAGE CONTROL =================
  Widget getPage() {
    if (pageIndex == 0) return intro();
    if (pageIndex == 1) return flowChat();
    return edukasi();
  }

  /// ================= PAGE 1 =================
  Widget intro() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.4),
          ),
          child: Image.asset(
            "assets/Icons/hearts.png",
            width: 80,
            height: 80,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "RuangSadar",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),

        const SizedBox(height: 10),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Aplikasi untuk membantu menjaga kesehatan mental dengan cara sederhana, terstruktur, dan mudah digunakan setiap hari.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }

  /// ================= PAGE 2 (CHAT FLOW) =================
  Widget flowChat() {
    final steps = [
      ["Hari ini saya merasa cemas...", true],
      ["Silakan isi jurnal dan lakukan tes mental", false],
      ["Sistem sedang menganalisis kondisi kamu...", false],
      ["Mood kamu menurun dalam beberapa hari terakhir", false],
      ["Kami sarankan meditasi atau bantuan profesional", false],
    ];

    return Column(
      children: [

        const SizedBox(height: 10),

        const Text(
          "Simulasi Cara Kerja Aplikasi",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),

        const SizedBox(height: 10),

        Expanded(
          child: ListView.builder(
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final isUser = steps[index][1] as bool;

              return AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: showItems[index] ? 1 : 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 400),
                  offset: showItems[index]
                      ? Offset.zero
                      : isUser
                          ? const Offset(-0.5, 0)
                          : const Offset(0.5, 0),
                  child: Row(
                    mainAxisAlignment:
                        isUser ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [

                      Container(
                        constraints: const BoxConstraints(maxWidth: 260),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser
                              ? Colors.white.withOpacity(0.6)
                              : const Color(0xFF6FBF8F),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isUser ? Icons.person : Icons.smart_toy,
                              size: 16,
                              color: isUser ? Colors.black54 : Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                steps[index][0] as String,
                                style: TextStyle(
                                  color: isUser
                                      ? Colors.black87
                                      : Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// ================= PAGE 3 =================
  Widget edukasi() {
    final cbtPoints = [
      ["Identifikasi Pikiran", "Mengenali pikiran otomatis negatif."],
      ["Uji Realitas Pikiran", "Menilai apakah pikiran benar atau tidak."],
      ["Perilaku Positif", "Melakukan tindakan sehat."],
      ["Monitoring Mood", "Melihat pola emosi dari waktu ke waktu."],
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const Icon(Icons.health_and_safety,
            size: 80, color: Colors.teal),

        const SizedBox(height: 15),

        Text("CBT (Cognitive Behavioral Therapy)", style: titleStyle),

        const SizedBox(height: 20),

        ...List.generate(cbtPoints.length, (index) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: showItems[index] ? 1 : 0,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cbtPoints[index][0],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    cbtPoints[index][1],
                    style: descStyle,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}