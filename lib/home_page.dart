import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ActivityReportPage.dart';
import 'database_helper.dart';
import 'meditation_page.dart';
import 'reflect_page.dart';
import 'healing_page.dart';
import 'psychologist_page.dart';
import 'alert_page.dart';
import 'challenge_page.dart';
import 'education_page.dart';
import 'profile_page.dart';
import 'maps_page.dart';
import 'detail_article_page.dart';
import 'test_intro_page.dart';



final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
class HomePage extends StatefulWidget {
  final String email;

  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> with RouteAware {

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
}
@override
void dispose() {
  routeObserver.unsubscribe(this);
  super.dispose();
}

@override
void didPopNext() {
  loadCoin(); // auto refresh coin saat balik dari CoinPage
}



  int totalCoin = 0;

  @override
void initState() {
  super.initState();
  loadCoin();

  // 🔥 TAMBAHAN BARU (auto refresh setelah 1 detik)
  Future.delayed(const Duration(seconds: 1), () {
    loadCoin();
  });
}

Future<void> loadCoin() async {
  final coin = await DatabaseHelper.instance.getTotalPoint(widget.email);

  if (!mounted) return;
  setState(() {
    totalCoin = coin;
  });
}
  String getDateInfo() {
    final now = DateTime.now();
    final hari = DateFormat('EEEE', 'id_ID').format(now);
    final tanggal = DateFormat('dd MMMM yyyy', 'id_ID').format(now);
    final jam = DateFormat('HH:mm').format(now);
    return "$hari • $tanggal • $jam";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 🔥 biar navbar gak naik turun
      backgroundColor: const Color(0xfff3f6f5),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6FBF8F),
        child: const Icon(Icons.map),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
builder: (_) => MapsPage(email: widget.email),          ),
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

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
              navItem(context, Icons.menu_book, "Materi"),
              navItem(context, Icons.person, "Akun"),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            headerSection(),
            const SizedBox(height: 15),

            // 🔥 TITLE SECTION FEATURE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Beranda Utama",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            featureGrid(context),
            const SizedBox(height: 20),
            newsSection(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget headerSection() {
    return Container(
      padding: const EdgeInsets.all(25),
      height: 260,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA8E6CF), Color(0xFF6FBF8F)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [

          // 🪙 COIN UI
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white),
              ),
              child: Row(
                children: [
                  Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                  SizedBox(width: 5),
                    Text(
                    "$totalCoin",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.waving_hand, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Halo!",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 5),

              Text(
                widget.email,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),

              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        getDateInfo(),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Jaga kesehatan mentalmu hari ini 💚",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= FEATURE GRID =================
  Widget featureGrid(BuildContext context) {
 final features = [
  {"icon": Icons.edit_note, "title": "Jurnal"},
  {"icon": Icons.self_improvement, "title": "Meditasi"},
  {"icon": Icons.insights, "title": "Laporan Data"},
  {"icon": Icons.favorite, "title": "pemulihan"},
  {"icon": Icons.location_on, "title": "Psikolog"},
  {"icon": Icons.warning, "title": "Peringatan Mood"},
  {"icon": Icons.emoji_events, "title": "Tantangan"},
];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: features.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => openFeature(context, features[index]["title"] as String),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xffe7f4ee),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(features[index]["icon"] as IconData,
                      color: Colors.green),
                ),
                const SizedBox(height: 8),
                Text(
                  features[index]["title"] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void openFeature(BuildContext context, String title) {
    Widget page;

    switch (title) {
        case "pemulihan":
        page = HealingPage(email: widget.email);
        break;
      case "Jurnal":
      page = ReflectPage(email: widget.email);
      break;
      case "Meditasi":
        page = const MeditationPage();
        break;
      case "Tes Mental":
        page = TestIntroPage(email: widget.email);
        break;
        case "Laporan Data":
        page = ActivityReportPage(email: widget.email);
        break;
      case "Psikolog":
        page = const PsychologistPage();
        break;
      case "Peringatan Mood":
        page = AlertPage(email: widget.email);
        break;
      case "Tantangan":
      page = ChallengePage(email: widget.email);
      break;
      default:
        return;
   }
    Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => page),
).then((_) {
  loadCoin(); // 🔥 INI YANG WAJIB BIAR LANGSUNG UPDATE
}); // 🔥 INI FIX REALTIME
  }
  // ================= NEWS + SUCCESS =================
  Widget newsSection(BuildContext context) {
  final successStories = [
    [
      "Pemulihan dari Burnout Akademik yang Berat",
      "Studi kasus seorang mahasiswa yang berhasil pulih setelah mengalami kelelahan mental akibat tekanan akademik berkepanjangan.",
    ],
    [
      "Kembali Produktif Setelah Burnout di Dunia Kerja",
      "Perjalanan seorang pekerja kantoran yang berhasil membangun kembali keseimbangan hidup dan kesehatan mentalnya.",
    ],
    [
      "Proses Pemulihan Anxiety dan Emotional Exhaustion",
      "Bagaimana terapi mandiri dan mindfulness membantu mengurangi gejala kecemasan berat dan kelelahan emosional.",
    ],
    [
      "Membangun Kembali Motivasi Setelah Mental Breakdown",
      "Kisah pemulihan seseorang yang kehilangan motivasi hidup akibat tekanan hidup yang berlebihan.",
    ],
  ];

  final leaderboard = [
    ["Alya Putri", "2450 🪙"],
    ["Rizky Pratama", "1980 🪙"],
    ["Nadia Salsabila", "1760 🪙"],
    ["Anda", "$totalCoin 🪙"],
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Cerita Perjalanan Mereka",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 210, // 🔥 dinaikin dikit biar aman semua device
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: successStories.length,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8)
                  ],
                ),

                /// 🔥 FIX OVERFLOW DISINI
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Icon(Icons.verified, color: Colors.green),

                    const SizedBox(height: 10),

                    /// TITLE (BATASIN)
                    Text(
                      successStories[index][0],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// DESC FLEXIBLE (INI KUNCI)
                    Expanded(
                      child: Text(
                        successStories[index][1],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),

                    /// BUTTON FIX (AMAN SEMUA HP)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailArticlePage(
                                title: successStories[index][0],
                                content: successStories[index][1],
                              ),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            "Baca selengkapnya →",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          "Peringkat koin",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 15),

        Column(
          children: leaderboard.map((e) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e[0],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Koin: ${e[1]}"),
                    ],
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}

  // ================= NAV =================
  Widget navItem(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == "Ujian") {
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TestIntroPage(email: widget.email),
        ),
      );
        } else if (label == "Materi") {
          Navigator.push(context,
              MaterialPageRoute(
  builder: (_) => EducationPage(email: widget.email),
)
          );
        } else if (label == "Akun") {
  Navigator.push(context,
      MaterialPageRoute(
      builder: (_) => ProfilePage(email: widget.email),
    ), 
  );
}
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green[700]),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
