import 'package:flutter/material.dart';
import 'education_detail_page.dart';
import 'home_page.dart';
import 'test_intro_page.dart';
import 'profile_page.dart';
import 'maps_page.dart';

class EducationPage extends StatelessWidget {
  final String email;

  const EducationPage({super.key, required this.email});
final List<Map<String, dynamic>> categories = const [
  {
    "title": "Pengantar Psikologi",
    "icon": Icons.school,
    "color": Colors.blue,
  },
  {
    "title": "Gangguan Kecemasan (Anxiety)",
    "icon": Icons.sentiment_very_dissatisfied,
    "color": Colors.red,
  },
  {
    "title": "Depresi & Mood Disorder",
    "icon": Icons.cloud,
    "color": Colors.indigo,
  },
  {
    "title": "Stres & Respon Psikologis",
    "icon": Icons.warning_amber,
    "color": Colors.orange,
  },
  {
    "title": "Terapi Kognitif (CBT Dasar)",
    "icon": Icons.psychology,
    "color": Colors.deepPurple,
  },
  {
    "title": "Distorsi Kognitif",
    "icon": Icons.visibility_off,
    "color": Colors.brown,
  },
  {
    "title": "Regulasi Emosi (Emotional Regulation)",
    "icon": Icons.emoji_emotions,
    "color": Colors.pink,
  },
  {
    "title": "Kepribadian & Teori Psikologi",
    "icon": Icons.person,
    "color": Colors.teal,
  },
  {
    "title": "Motivasi & Perilaku Manusia",
    "icon": Icons.insights,
    "color": Colors.amber,
  },
  {
    "title": "Psikologi Klinis & Assessment",
    "icon": Icons.assignment,
    "color": Colors.green,
  },
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),

      /// 🔥 APPBAR
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Materi Kesehatan Mental"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      /// 🔥 FAB MAPS
      floatingActionButton: FloatingActionButton(
        tooltip: "Peta",
        backgroundColor: const Color(0xFF6FBF8F),
        child: const Icon(Icons.map),
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) {
return MapsPage(email: email);              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final scale = Tween(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  ),
                );

                final fade =
                    Tween(begin: 0.0, end: 1.0).animate(animation);

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

      /// 🔥 NAVBAR
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
              navItem(context, Icons.assignment, "Ujian"),

              const SizedBox(width: 40),

              navItem(context, Icons.menu_book, "Materi", isActive: true),
              navItem(context, Icons.person, "Akun"),
            ],
          ),
        ),
      ),

      /// 🔥 BODY
     body: Padding(
  padding: const EdgeInsets.all(10),
  child: GridView.builder(
    physics: const BouncingScrollPhysics(), // ✔ tetap bisa scroll smooth
    itemCount: categories.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // 🔥 3 KOLOM (lebih kecil & tidak besar)
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.85, // 🔥 bikin lebih compact
    ),
    itemBuilder: (context, i) {
      final item = categories[i];

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EducationDetailPage(data: item),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12), // 🔽 lebih soft & kecil
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item["icon"],
                  size: 26, // 🔥 kecil biar tidak “ngegantung besar”
                  color: item["color"],
                ),
                const SizedBox(height: 6),
                Text(
                  item["title"],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9.5, // 🔥 super compact tapi masih kebaca
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
),
    );
  }

  /// 🔥 NAVBAR FUNCTION
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
        }

        else if (label == "Ujian") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TestIntroPage(email: email),
            ),
          );
        }

        else if (label == "Materi") {
          // stay
        }

        else if (label == "Akun") {
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