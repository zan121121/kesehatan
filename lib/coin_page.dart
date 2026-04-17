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
  int coin = 0;
  bool isLoading = true;

  final List<Map<String, dynamic>> rewards = [
    {
      "title": "Voucher Belanja",
      "subtitle": "Minimal reward",
      "coin": 100,
      "icon": Icons.shopping_bag,
      "available": true
    },
    {
      "title": "Pulsa 50K",
      "subtitle": "Top up instan",
      "coin": 500,
      "icon": Icons.phone_android,
      "available": true
    },
    {
      "title": "Headset Gaming",
      "subtitle": "Barang menarik",
      "coin": 1200,
      "icon": Icons.headphones,
      "available": true
    },
    {
      "title": "Smartwatch",
      "subtitle": "Premium item",
      "coin": 2500,
      "icon": Icons.watch,
      "available": true
    },
    {
      "title": "Uang Tunai 5 Juta",
      "subtitle": "Hadiah utama",
      "coin": 5000,
      "icon": Icons.attach_money,
      "available": true
    },
    {
      "title": "Uang Ratusan Juta",
      "subtitle": "Coming soon",
      "coin": 10000,
      "icon": Icons.workspace_premium,
      "available": false
    },
  ];

  @override
  void initState() {
    super.initState();
    loadCoin();
  }

  Future<void> loadCoin() async {
    final total = await DatabaseHelper.instance.getTotalPoint(widget.email);

    if (!mounted) return;
    setState(() {
      coin = total;
      isLoading = false;
    });
  }

  /// ==============================
  /// 🔥 REDEEM COIN FUNCTION
  /// ==============================
  void redeemReward(Map<String, dynamic> reward) {
    if (!reward["available"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item belum tersedia")),
      );
      return;
    }

    if (coin < reward["coin"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Koin tidak mencukupi")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Penukaran"),
          content: Text(
            "Apakah kamu yakin ingin menukar ${reward["title"]} dengan ${reward["coin"]} Koin?",
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),

            TextButton(
              onPressed: () async {

                /// 1. tutup dialog
                Navigator.pop(context);

                /// 2. kurangi coin di database
                await DatabaseHelper.instance.useCoin(
                  widget.email,
                  reward["coin"],
                );

                /// 3. refresh coin di page ini
                await loadCoin();

                /// 4. kirim signal ke HomePage (INI PENTING)
                Navigator.pop(context, true);

                /// 5. notif sukses
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Penukaran ${reward["title"]} berhasil",
                    ),
                  ),
                );
              },
              child: const Text(
                "Ya, Tukar",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
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
        title: const Text("Koin & Reward"),
        backgroundColor: const Color(0xFF6FBF8F),
        elevation: 0,
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
                const Icon(Icons.monetization_on,
                    size: 45, color: Colors.amber),
                const SizedBox(height: 8),
                const Text(
                  "Total Koin",
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  "$coin",
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

          /// ================= LIST REWARD =================
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: rewards.length,
              itemBuilder: (context, index) {
                final reward = rewards[index];

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
                      )
                    ],
                  ),
                  child: Row(
                    children: [

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          reward["icon"],
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reward["title"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              reward["subtitle"],
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey),
                            ),
                            Text(
                              "${reward["coin"]} Koin",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                      reward["available"]
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6FBF8F),
                              ),
                              onPressed: () => redeemReward(reward),
                              child: const Text(
  "Tukar",
  style: TextStyle(
    color: Colors.white,
  ),
),
                          )
                          : const Text(
                              "Coming Soon",
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