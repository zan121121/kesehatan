import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [

          /// 🔥 TENTANG APLIKASI
          settingItem(
            context,
            icon: Icons.info,
            title: "Tentang Aplikasi",
            subtitle: "Aplikasi kesehatan mental & self healing",
          ),

          /// 🔥 VERSI APP
          settingItem(
            context,
            icon: Icons.system_update,
            title: "Versi Aplikasi",
            subtitle: "v1.0.0",
          ),

          /// 🔥 PRIVACY
          settingItem(
            context,
            icon: Icons.privacy_tip,
            title: "Kebijakan Keamanan",
            subtitle: "Lihat kebijakan aplikasi",
          ),

          /// 🔥 TERMS
          settingItem(
            context,
            icon: Icons.description,
            title: "Syarat & Ketentuan",
            subtitle: "Aturan penggunaan aplikasi",
          ),

          /// 🔥 KONTAK
          settingItem(
            context,
            icon: Icons.support_agent,
            title: "Kontak Developer",
            subtitle: "timpengembang@gmail.com",
          ),
        ],
      ),
    );
  }

  /// 🔥 STYLE BOX
  BoxDecoration boxStyle() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 5)
      ],
    );
  }

  /// 🔥 ITEM TEMPLATE
  Widget settingItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle}) {

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: boxStyle(),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(subtitle),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}