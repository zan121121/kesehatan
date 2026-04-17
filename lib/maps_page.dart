import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_page.dart';
import 'education_page.dart';
import 'profile_page.dart';
import 'test_intro_page.dart';

class MapsPage extends StatefulWidget {
  final String email;

  const MapsPage({super.key, required this.email});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  int currentIndex = 4;

  Future<void> openMaps() async {
    final url =
        "https://www.google.com/maps/search/?api=1&query=psikiater+terdekat";
    final uri = Uri.parse(url);

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void fakeMapsButton() {}

  void goTo(int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage(email: widget.email)),
        (route) => false,
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TestIntroPage(email: widget.email),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EducationPage(email: widget.email),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfilePage(email: widget.email),
        ),
      );
    }

    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),

      /// ================= APPBAR (NO BACK BUTTON) =================
      appBar: AppBar(
        automaticallyImplyLeading: false, // ❌ HAPUS TOMBOL BACK
        backgroundColor: const Color(0xFF6FBF8F),
        title: const Text("Temukan Psikiater Terdekat"),
        centerTitle: true,
      ),

      /// ================= BODY =================
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.health_and_safety,
                size: 90,
                color: Color(0xFF6FBF8F),
              ),

              const SizedBox(height: 20),

              const Text(
                "Cari Psikiater Terdekat di Sekitarmu",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Klik tombol untuk membuka Google Maps",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              /// ================= BUTTON =================
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6FBF8F), // SAMAKAN
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25, vertical: 12),
                ),
                onPressed: openMaps,
                child: const Text(
                  "Buka Google Maps",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),

      /// ================= FLOATING BUTTON =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6FBF8F),
  child: const Icon(Icons.map),
  onPressed: fakeMapsButton,     ),

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
              navItem(Icons.home, "Beranda", 0),
              navItem(Icons.assignment, "Ujian", 1),

              const SizedBox(width: 40),

              navItem(Icons.menu_book, "Materi", 2),
              navItem(Icons.person, "Akun", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(IconData icon, String label, int index) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => goTo(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive
                ? const Color(0xFF6FBF8F)
                : Colors.green[700],
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