import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'database_helper.dart';

class MoodChartPage extends StatelessWidget {
  final String email;

  const MoodChartPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f7f6),

      appBar: AppBar(
        backgroundColor: const Color(0xFF5DBB93),
        title: const Text("Grafik Mood"),
      ),

      body: FutureBuilder(
        future: DatabaseHelper.instance.getMoodHistory(email),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Map<String, dynamic>> data =
              snapshot.data as List<Map<String, dynamic>>;

          if (data.isEmpty) {
            return const Center(
              child: Text("Belum ada data mood"),
            );
          }

          /// ================= KATEGORI =================
          int baik = 0;
          int sedang = 0;
          int buruk = 0;

          for (var item in data) {
            int score = item['score'];

            if (score >= 70) {
              baik++;
            } else if (score >= 40) {
              sedang++;
            } else {
              buruk++;
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// ================= PIE CHART =================
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 60,
                    sections: [
                      pieItem(baik, "Baik", Colors.green),
                      pieItem(sedang, "Sedang", Colors.orange),
                      pieItem(buruk, "Buruk", Colors.red),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ================= LEGEND =================
              legendItem("Baik", Colors.green),
              legendItem("Sedang", Colors.orange),
              legendItem("Buruk", Colors.red),
            ],
          );
        },
      ),
    );
  }

  /// ================= PIE ITEM =================
  PieChartSectionData pieItem(int value, String title, Color color) {
    return PieChartSectionData(
      color: color,
      value: value.toDouble(),
      title: value == 0 ? "" : "$title\n$value",
      radius: 80,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  /// ================= LEGEND =================
  Widget legendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 15,
            height: 15,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}