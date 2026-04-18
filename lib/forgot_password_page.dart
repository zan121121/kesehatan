import 'package:flutter/material.dart';
import 'login_page.dart';
import 'database_helper.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {

  final email = TextEditingController();
  final kode = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  late AnimationController _controller;

  bool kodeTerkirim = false;

  bool hidePass = true;
  bool hideConfirm = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    email.dispose();
    kode.dispose();
    newPass.dispose();
    confirmPass.dispose();
    super.dispose();
  }

  void kirimKode() {
    if (email.text.isEmpty) {
      showMsg("Masukkan email terlebih dahulu");
      return;
    }

    setState(() {
      kodeTerkirim = true;
    });

    showMsg("Kode verifikasi dikirim (simulasi)");
  }

  void resetPassword() async {
    if (email.text.isEmpty) {
      showMsg("Email wajib diisi");
      return;
    }

    if (newPass.text.isEmpty || confirmPass.text.isEmpty) {
      showMsg("Password baru wajib diisi");
      return;
    }

    /// 🔥 VALIDASI PASSWORD
    String password = newPass.text;

    bool hasMinLength = password.length >= 8;
    bool hasSymbol =
        RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(password);

    if (!hasMinLength || !hasSymbol) {
      showMsg("Password minimal 8 karakter dan harus ada simbol");
      return;
    }

    if (newPass.text != confirmPass.text) {
      showMsg("Password tidak sama");
      return;
    }

    bool exists =
        await DatabaseHelper.instance.checkEmail(email.text);

    if (!exists) {
      showMsg("Email tidak ditemukan");
      return;
    }

    await DatabaseHelper.instance.updatePassword(
      email.text,
      newPass.text,
    );

    showMsg("Password berhasil diubah");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// BACKGROUND
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(
                          const Color(0xFFA8E6CF),
                          const Color(0xFFDCEDC1),
                          _controller.value)!,
                      Color.lerp(
                          const Color(0xFFB2DFDB),
                          const Color(0xFFC8E6C9),
                          _controller.value)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),

          Positioned(top: 100, left: 40, child: bubble(100)),
          Positioned(bottom: 120, right: 30, child: bubble(140)),

          /// CONTENT
          SingleChildScrollView(
            child: Column(
              children: [

                /// HEADER
                SizedBox(
                  height: 260,
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
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.35),
                            ),
                            child: Icon(Icons.lock_reset,
                                size: 60, color: Colors.teal[800]),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "Reset Password",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            "Amankan kembali akunmu dengan mudah",
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

                /// FORM
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    children: [

                      /// EMAIL
                      TextField(
                        controller: email,
                        decoration: inputStyle("Email", Icons.email),
                      ),

                      const SizedBox(height: 15),

                      /// BUTTON KIRIM
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6FBF8F),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 45),
                        ),
                        onPressed: kirimKode,
                        child: const Text("Kirim Kode"),
                      ),

                      if (kodeTerkirim) ...[

                        const SizedBox(height: 15),

                        TextField(
                          controller: kode,
                          decoration:
                              inputStyle("Kode Verifikasi", Icons.security),
                        ),

                        const SizedBox(height: 15),

                        /// PASSWORD BARU
                        TextField(
                          controller: newPass,
                          obscureText: hidePass,
                          decoration: inputStyle("Password Baru", Icons.lock)
                              .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                hidePass
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.teal,
                              ),
                              onPressed: () {
                                setState(() => hidePass = !hidePass);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        /// 🔥 TEXT HINT
                        const Text(
                          "Minimal 8 karakter dan simbol",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),

                        const SizedBox(height: 15),

                        /// CONFIRM PASSWORD
                        TextField(
                          controller: confirmPass,
                          obscureText: hideConfirm,
                          decoration:
                              inputStyle("Konfirmasi Password", Icons.lock)
                                  .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                hideConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.teal,
                              ),
                              onPressed: () {
                                setState(() => hideConfirm = !hideConfirm);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// SAVE BUTTON
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6FBF8F),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: resetPassword,
                          child: const Text("Simpan Password"),
                        ),

                        const SizedBox(height: 10),

                        /// BACK LOGIN
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => LoginPage()),
                            );
                          },
                          child: const Text(
                            "← Kembali ke Login",
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ]
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

  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.teal),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal.shade200),
        borderRadius: BorderRadius.circular(12),
      ),

      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal),
        borderRadius: BorderRadius.circular(12),
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
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        );
      },
    );
  }
}