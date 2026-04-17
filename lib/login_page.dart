import 'package:flutter/material.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'database_helper.dart';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  final email = TextEditingController();
  final password = TextEditingController();

  late AnimationController _controller;

  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();

    email.clear();
    password.clear();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email & Password wajib diisi")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      bool success = await DatabaseHelper.instance.login(
        email.text.trim(),
        password.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_email", email.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login berhasil")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(email: email.text.trim()),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email atau password salah")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  /// INPUT STYLE (TEXT HITAM FIX)
  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black), // FIX

      hintStyle: const TextStyle(color: Colors.black),

      prefixIcon: Icon(icon, color: Colors.teal),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal.shade200),
        borderRadius: BorderRadius.circular(12),
      ),

      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.teal),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFA8E6CF),
                  Color(0xFFDFF5EA),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Positioned(top: 100, left: 40, child: bubble(100)),
          Positioned(bottom: 120, right: 30, child: bubble(140)),

          SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(60),
                          ),
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            child: Image.asset(
                              "assets/Icons/hearts.png",
                              width: 55,
                              height: 55,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "RuangSadar",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Text(
                            "Mulai perjalanan mental yang lebih sehat",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [

                      /// EMAIL (TEXT HITAM)
                      TextField(
                        controller: email,
                        style: const TextStyle(color: Colors.black),
                        decoration: inputStyle("Email", Icons.email),
                      ),

                      const SizedBox(height: 15),

                      /// PASSWORD (TEXT HITAM)
                      TextField(
                        controller: password,
                        obscureText: obscurePassword,
                        style: const TextStyle(color: Colors.black),
                        decoration: inputStyle("Password", Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.teal,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ForgotPasswordPage(),
                              ),
                            );

                            email.clear();
                            password.clear();
                            setState(() {});
                          },
                          child: const Text(
                            "Lupa Password?",
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6FBF8F),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: isLoading ? null : loginUser,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Masuk",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),

                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegisterPage(),
                            ),
                          );

                          email.clear();
                          password.clear();
                          setState(() {});
                        },
                        child: const Text(
                          "Belum punya akun? Daftar",
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bubble(double size) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(10 * _controller.value, 20 * _controller.value),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}