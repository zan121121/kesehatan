import 'package:flutter/material.dart';
import 'database_helper.dart';

class SecurityPage extends StatefulWidget {
  final String email;

  const SecurityPage({super.key, required this.email});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {

  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  Future<void> changePassword() async {
    final db = await DatabaseHelper.instance.database;

    final user = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [widget.email, oldPass.text],
    );

    if (user.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password lama salah ❌")),
      );
      return;
    }

    if (newPass.text != confirmPass.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Konfirmasi password tidak cocok ❌")),
      );
      return;
    }

    await DatabaseHelper.instance
        .updatePassword(widget.email, newPass.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password berhasil diubah ✅")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keamanan Akun"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: oldPass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password Lama",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: newPass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password Baru",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: confirmPass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Konfirmasi Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6FBF8F),
              ),
              onPressed: changePassword,
             child: const Text(
  "Simpan",
  style: TextStyle(
    color: Colors.white,
  ),
),
            )
          ],
        ),
      ),
    );
  }
}