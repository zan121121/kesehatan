import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import 'database_helper.dart';
import 'coin_page.dart';
import 'edit_profile_page.dart';
import 'security_page.dart';
import 'settings_page.dart';
import 'help_page.dart';
import 'login_page.dart';

import 'home_page.dart';
import 'education_page.dart';
import 'test_intro_page.dart';
import 'maps_page.dart';

class ProfilePage extends StatefulWidget {
  final String email;

  const ProfilePage({super.key, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int coin = 0;
  String username = "";
  bool isLoading = true;

  File? _image;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadProfile();
    loadImage(); // ✅ LOAD FOTO SAAT BUKA APP
  }

  /// ================= LOAD FOTO PROFIL =================
  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString("profile_image_${widget.email}");

    if (path != null && File(path).existsSync()) {
      setState(() {
        _image = File(path);
      });
    }
  }

  /// ================= PICK + SAVE FOTO =================
  Future<void> pickImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        "profile_image_${widget.email}",
        pickedFile.path,
      );

      setState(() {
        _image = file;
      });
    }
  }

  Future<void> loadProfile() async {
    final db = await DatabaseHelper.instance.database;

    final user = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [widget.email],
      limit: 1,
    );

    final totalCoin =
        await DatabaseHelper.instance.getTotalPoint(widget.email);

    String tempUsername = widget.email.split("@")[0];

    if (user.isNotEmpty) {
      final data = user.first;
      final dbUsername = data['username'];

      if (dbUsername != null &&
          dbUsername.toString().trim().isNotEmpty) {
        tempUsername = dbUsername.toString();
      }
    }

    if (!mounted) return;

    setState(() {
      username = tempUsername;
      coin = totalCoin;
      isLoading = false;
    });
  }

  Future<void> confirmLogout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Keluar Akun"),
        content: const Text("Apakah kamu yakin ingin keluar dari akun ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Keluar",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("user_email");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
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
        automaticallyImplyLeading: false,
        title: const Text("Akun Saya"),
        backgroundColor: const Color(0xFF6FBF8F),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6FBF8F),
        child: const Icon(Icons.map),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MapsPage(email: widget.email),
            ),
          );
        },
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      body: Column(
        children: [

          /// ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF6FBF8F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [

                /// ================= FOTO PROFIL (CLICKABLE + SAVE) =================
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(
                              Icons.person,
                              size: 55,
                              color: Color(0xFF6FBF8F),
                            )
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  widget.email,
                  style: const TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.monetization_on,
                          color: Colors.amber),
                      const SizedBox(width: 5),
                      Text(
                        "$coin Koin",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// ================= MENU =================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [

                menuItem(Icons.person, "Edit Akun"),
                menuItem(Icons.lock, "Keamanan Akun"),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xffe7f4ee),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.card_giftcard,
                          color: Colors.green),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "Tukar Koin",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6FBF8F),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CoinPage(
                                email: widget.email,
                                currentCoin: coin,
                              ),
                            ),
                          ).then((_) => loadProfile());
                        },
                        child: const Text(
                          "Tukar",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                menuItem(Icons.settings, "Pengaturan"),
                menuItem(Icons.help, "Bantuan"),
                menuItem(Icons.logout, "Keluar Akun", isLogout: true),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: const Color(0xffe4f4ec),
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(context, Icons.home, "Beranda"),
              navItem(context, Icons.assignment, "Ujian"),
              const SizedBox(width: 40),
              navItem(context, Icons.menu_book, "Materi"),
              navItem(context, Icons.person, "Akun", isActive: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(
    BuildContext context,
    IconData icon,
    String label, {
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (label == "Beranda") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(email: widget.email),
            ),
            (route) => false,
          );
        } else if (label == "Ujian") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TestIntroPage(email: widget.email),
            ),
          );
        } else if (label == "Materi") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EducationPage(email: widget.email),
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: isActive ? Colors.green : Colors.green[700]),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget menuItem(IconData icon, String title, {bool isLogout = false}) {
    return GestureDetector(
      onTap: () async {
        if (title == "Keluar Akun") {
          confirmLogout();
        } else if (title == "Edit Akun") {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditProfilePage(email: widget.email),
            ),
          );
          loadProfile();
        } else if (title == "Keamanan Akun") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SecurityPage(email: widget.email),
            ),
          );
        } else if (title == "Pengaturan") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsPage()),
          );
        } else if (title == "Bantuan") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HelpPage()),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5)
          ],
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isLogout ? Colors.red : Colors.green),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isLogout ? Colors.red : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16)
          ],
        ),
      ),
    );
  }
}