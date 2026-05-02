import 'package:flutter/material.dart';
import 'database_helper.dart';

class CoinPage extends StatefulWidget {
  final String email;
  final int currentCoin;

  const CoinPage({
    super.key,
    required this.email,
    required this.currentCoin,
  });

  @override
  State<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  int points = 0;
  bool isLoading = true;

  /// ================= REWARD SYSTEM (RS / PSIKOLOG PARTNER REALISTIS) =================
  final List<Map<String, dynamic>> rewards = [
    {
      "title": "Sesi Check-in Konseling (15 Menit)",
      "subtitle": "Konsultasi ringan dengan konselor partner",
      "points": 100,
      "icon": Icons.support_agent,
      "available": true
    },
    {
      "title": "Diskon Sesi Psikolog",
      "subtitle": "Potongan biaya konsultasi profesional",
      "points": 200,
      "icon": Icons.local_offer,
      "available": true
    },
    {
      "title": "Prioritas Jadwal Konsultasi",
      "subtitle": "Akses antrian lebih cepat dengan psikolog",
      "points": 300,
      "icon": Icons.schedule,
      "available": true
    },
    {
      "title": "Sesi Relaksasi Terpandu",
      "subtitle": "Latihan relaksasi bersama tenaga profesional",
      "points": 400,
      "icon": Icons.self_improvement,
      "available": true
    },
    {
      "title": "Voucher Healing Session",
      "subtitle": "Sesi healing individu atau group therapy",
      "points": 600,
      "icon": Icons.favorite,
      "available": true
    },
    {
      "title": "Program Pendampingan Mental",
      "subtitle": "Pendampingan lanjutan bersama konselor",
      "points": 800,
      "icon": Icons.health_and_safety,
      "available": true
    },

    /// 🔥 COMING SOON (SPECIAL PARTNER RS)
    {
      "title": "Program Terapi Intensif RS Partner",
      "subtitle": "Program healing intensif bersama rumah sakit rekanan",
      "points": 1200,
      "icon": Icons.local_hospital,
      "available": false
    },
  ];

  @override
  void initState() {
    super.initState();
    loadPoints();
  }

  Future<void> loadPoints() async {
    final total =
        await DatabaseHelper.instance.getTotalPoint(widget.email);

    if (!mounted) return;
    setState(() {
      points = total;
      isLoading = false;
    });
  }

  void redeemReward(Map<String, dynamic> item) {
    if (!item["available"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Program ini sedang dalam pengembangan"),
        ),
      );
      return;
    }

    if (points < item["points"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Points kamu belum cukup"),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tukar Reward Self-Healing"),
        content: Text(
          "Gunakan ${item["points"]} Points untuk mengakses:\n\n${item["title"]} ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Nanti dulu"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              await DatabaseHelper.instance.useCoin(
                widget.email,
                item["points"],
              );

              await loadPoints();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Berhasil mengakses: ${item["title"]}",
                  ),
                ),
              );
            },
            child: const Text(
              "Tukar",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff3f6f5),

      appBar: AppBar(
        title: const Text("Self-Healing Rewards"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      body: Column(
        children: [

          /// ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              color: Color(0xFF6FBF8F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.favorite,
                  size: 45,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Total Points Perjalanan Healing",
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  "$points",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// ================= LIST =================
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: rewards.length,
              itemBuilder: (context, index) {
                final item = rewards[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [

                      Icon(
                        item["icon"],
                        color: const Color(0xFF6FBF8F),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item["subtitle"],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text("${item["points"]} Points"),
                          ],
                        ),
                      ),

                      item["available"]
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6FBF8F),
                              ),
                              onPressed: () => redeemReward(item),
                              child: const Text(
                                "Tukar",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : const Text(
                              "Segera Hadir",
                              style: TextStyle(color: Colors.grey),
                            )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}