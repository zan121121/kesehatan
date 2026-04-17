import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

import 'reflect_page.dart';
import 'test_page.dart';

class ChallengePage extends StatefulWidget {
  final String email;

  const ChallengePage({super.key, required this.email});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Map<String, bool> completed = {};
  Map<String, bool> claimed = {};

  bool loading = true;

  final List<Map<String, dynamic>> challenges = [
    {
      "id": "daily_checkin",
      "title": "Daily Check-in",
      "desc": "Langsung klaim reward harian",
      "coin": 20,
      "type": "checkin",
    },
    {
      "id": "reflect",
      "title": "Reflection Journal",
      "desc": "Tulis refleksi diri hari ini",
      "coin": 10,
      "type": "reflect",
    },
    {
      "id": "test_mental",
      "title": "Mental Health Test",
      "desc": "Selesaikan tes mental (reward besar)",
      "coin": 50,
      "type": "test",
    },
    {
      "id": "daily_mood",
      "title": "Daily Mood",
      "desc": "Cek mood otomatis (langsung klaim)",
      "coin": 20,
      "type": "mood",
    },
  ];

  @override
  void initState() {
    super.initState();
    loadStatus();
  }

  // ================= LOAD STATUS =================
  Future<void> loadStatus() async {
    final db = DatabaseHelper.instance;

    Map<String, bool> tempCompleted = {};
    Map<String, bool> tempClaimed = {};

    for (var item in challenges) {
      String id = item["id"];
      String type = item["type"];

      if (type == "reflect") {
        final data = await db.getReflectionHistory(widget.email);
        tempCompleted[id] = data.any(
          (e) => e["date"].toString().split(" ")[0] == today,
        );
      } 
      else if (type == "test") {
        tempCompleted[id] =
            await db.hasClaimedToday(widget.email, type, today);
      } 
      else if (type == "mood") {
        tempCompleted[id] =
            await db.checkTodayMood(widget.email, today);
      } 
      else if (type == "checkin") {
        tempCompleted[id] = true; // always available
      }

      tempClaimed[id] =
          await db.hasClaimedToday(widget.email, type, today);
    }

    setState(() {
      completed = tempCompleted;
      claimed = tempClaimed;
      loading = false;
    });
  }

  // ================= OPEN PAGE ONLY FOR 2 MISSION =================
  Future<void> openMission(String id) async {
    if (id == "reflect") {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ReflectPage(email: widget.email)),
      );
    } 
    else if (id == "test_mental") {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TestPage(email: widget.email)),
      );
    }

    await loadStatus();
  }

  // ================= DIRECT CLAIM (CHECKIN + MOOD) =================
  Future<void> claimDirect(String id, int coin, String type) async {
    final db = DatabaseHelper.instance;

    bool alreadyClaimed =
        await db.hasClaimedToday(widget.email, type, today);

    if (alreadyClaimed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sudah claim hari ini"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await db.addPoint(widget.email, type, today);

    setState(() {
      claimed[id] = true;
      completed[id] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("+$coin Koin 🪙")),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),
      appBar: AppBar(
        title: const Text("Tantangan Sistem"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      body: ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, i) {
          final item = challenges[i];
          final id = item["id"];
          final type = item["type"];

          final isDone = completed[id] == true;
          final isClaimed = claimed[id] == true;

          return Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(item["desc"],
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),

                Text(
                  "🪙 ${item["coin"]}",
                  style: const TextStyle(
                    color: Color(0xFF6FBF8F),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6FBF8F),
                      ),
                      onPressed: isClaimed
                          ? null
                          : () {
                              if (type == "checkin" || type == "mood") {
                                claimDirect(id, item["coin"], type);
                              } else {
                                openMission(id);
                              }
                            },
                      child: Text(
                        isClaimed
                            ? "Sudah Klaim"
                            : (type == "checkin" || type == "mood"
                                ? "Claim"
                                : "Mulai"),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    if (isClaimed)
                      const Text(
                        "Selesai",
                        style: TextStyle(
                          color: Color(0xFF6FBF8F),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else if (!isDone && type != "checkin" && type != "mood")
                      const Text(
                        "Belum selesai",
                        style: TextStyle(color: Colors.red),
                      )
                    else if (isDone && type != "checkin" && type != "mood")
                      const Text(
                        "Siap klaim",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}