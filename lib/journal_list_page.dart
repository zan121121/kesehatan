import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class JournalListPage extends StatefulWidget {
  final String email;

  const JournalListPage({super.key, required this.email});

  @override
  State<JournalListPage> createState() => _JournalListPageState();
}

class _JournalListPageState extends State<JournalListPage> {
  List<Map<String, dynamic>> data = [];
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final result =
        await DatabaseHelper.instance.getReflectionHistory(widget.email);

    setState(() {
      data = result.reversed.toList();
    });
  }

  String format(String date) {
    try {
      final parsed = DateTime.tryParse(date);
      if (parsed != null) {
        return DateFormat("EEEE, dd MMM yyyy • HH:mm").format(parsed);
      }
      return date;
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF6FBF8F),
        title: const Text("Jurnal Kamu 🌿"),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (context, i) {
          final item = data[i];
          final isExpanded = expandedIndex == i;

          final journalText = item['journal'] ?? '';
          final mood = int.tryParse(item['mood'].toString()) ?? 0;

          String getInsight() {
            if (mood < 40) {
              return "Kamu sedang sangat lelah secara emosional.";
            } else if (mood < 70) {
              return "Kamu sedang naik turun, itu normal.";
            } else {
              return "Kondisi kamu cukup stabil 👍";
            }
          }

          String getSolution() {
            if (mood < 40) {
              return "Istirahat, tarik napas dalam, jangan paksa diri. Kamu aman.";
            } else if (mood < 70) {
              return "Coba journaling lagi, jalan santai, dan kurangi beban pikiran.";
            } else {
              return "Pertahankan kebiasaan baikmu. Kamu sudah di jalur yang bagus.";
            }
          }

          return GestureDetector(
            onTap: () {
              setState(() {
                expandedIndex = isExpanded ? null : i;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// DATE
                  Text(
                    format(item['date']),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// JOURNAL TEXT
                  Text(
                    journalText,
                    maxLines: isExpanded ? null : 3,
                    overflow:
                        isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 10),

                  /// CHIPS (SAFE FROM OVERFLOW)
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _chip("Mood $mood", Colors.teal),
                      _chip(item['insight'], Colors.blue),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// EXPAND DETAIL (NEW VALUE)
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const SizedBox(),
                    secondChild: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "💭 Insight",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(getInsight()),

                          const SizedBox(height: 10),

                          const Text(
                            "💡 Solusi",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(getSolution()),

                          const SizedBox(height: 10),

                          const Text(
                            "🌿 Healing Message",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Kamu tidak harus sempurna. Pelan-pelan saja, kamu sedang bertumbuh.",
                          ),
                        ],
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      isExpanded ? "Tutup ▲" : "Lihat detail ▼",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6FBF8F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// CHIP UI
  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}