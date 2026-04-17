import 'package:flutter/material.dart';
import 'database_helper.dart';

class EditProfilePage extends StatefulWidget {
  final String email;

  const EditProfilePage({super.key, required this.email});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final TextEditingController usernameController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final db = await DatabaseHelper.instance.database;

    final user = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [widget.email],
      limit: 1,
    );

    if (user.isNotEmpty) {
      usernameController.text = user.first['username'].toString();
    }

    setState(() => isLoading = false);
  }

  Future<void> updateProfile() async {
    final db = await DatabaseHelper.instance.database;

    await db.update(
      'users',
      {'username': usernameController.text},
      where: 'email = ?',
      whereArgs: [widget.email],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile berhasil diupdate ✅")),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6FBF8F),
              ),
              onPressed: updateProfile,
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