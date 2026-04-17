import 'package:flutter/material.dart';
import 'test_page.dart';
import 'education_page.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'maps_page.dart';

class TestIntroPage extends StatelessWidget {
  final String email;

  const TestIntroPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),

      /// ================= APPBAR (SEPERTI EDUCATION PAGE) =================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Tes Kesehatan Mental"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      /// ================= FLOATING BUTTON MAPS =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6FBF8F),
        child: const Icon(Icons.map),
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) {
                return MapsPage(email: email);
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final scale = Tween(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  ),
                );

                final fade = Tween(begin: 0.0, end: 1.0).animate(animation);

                return FadeTransition(
                  opacity: fade,
                  child: ScaleTransition(scale: scale, child: child),
                );
              },
            ),
          );
        },
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      /// ================= NAVBAR =================
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: const Color(0xffe4f4ec),
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(context, Icons.home, "Halaman"),
              navItem(context, Icons.assignment, "Ujian", isActive: true),
              const SizedBox(width: 40),
              navItem(context, Icons.menu_book, "Materi"),
              navItem(context, Icons.person, "Akun"),
            ],
          ),
        ),
      ),

      /// ================= BODY (SUDAH CLEAN SEPERTI EDUCATION PAGE STYLE) =================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.psychology,
                  size: 70,
                  color: Color(0xFF6FBF8F),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Tes Kesehatan Mental",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Tes ini akan membantu mengetahui kondisi mental kamu.\n"
                  "Pastikan kamu mengisi dengan jujur ya 😊",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6FBF8F),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TestPage(email: email),
                      ),
                    );
                  },
                  child: const Text(
                    "Mulai Ujian",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navItem(
    BuildContext context,
    IconData icon,
    String label, {
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (label == "Halaman") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(email: email),
            ),
            (route) => false,
          );
        } else if (label == "Ujian") {
          // stay
        } else if (label == "Materi") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EducationPage(email: email),
            ),
          );
        } else if (label == "Akun") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfilePage(email: email),
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.green : Colors.green[700],
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}