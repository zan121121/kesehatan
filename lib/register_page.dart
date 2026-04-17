import 'package:flutter/material.dart';
import 'database_helper.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {

  final user = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirmPass = TextEditingController();

  late AnimationController _controller;

  bool hidePass = true;
  bool hideConfirm = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    user.dispose();
    email.dispose();
    pass.dispose();
    confirmPass.dispose();
    super.dispose();
  }

  /// 🔥 REGISTER FUNCTION
  void registerUser() async {
    if (user.text.isEmpty ||
        email.text.isEmpty ||
        pass.text.isEmpty ||
        confirmPass.text.isEmpty) {
      showMsg("Semua field wajib diisi");
      return;
    }

    /// 🔥 VALIDASI EMAIL HARUS GMAIL
    if (!email.text.endsWith("@gmail.com")) {
      showMsg("Email harus menggunakan @gmail.com");
      return;
    }

    /// 🔥 VALIDASI PASSWORD SAMA
    if (pass.text != confirmPass.text) {
      showMsg("Password tidak sama");
      return;
    }

    /// 🔥 VALIDASI PASSWORD KUAT
    String password = pass.text;

    if (password.length < 8) {
      showMsg("Password minimal 8 karakter");
      return;
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      showMsg("Harus ada simbol (!@# dll)");
      return;
    }

    /// CEK EMAIL
    bool exists =
        await DatabaseHelper.instance.checkEmail(email.text);

    if (exists) {
      showMsg("Email sudah terdaftar");
      return;
    }

    /// SIMPAN
    await DatabaseHelper.instance
        .register(user.text, email.text, pass.text);

    showMsg("Registrasi berhasil");

    Navigator.pop(context);
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

          /// 🌿 BACKGROUND
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(Color(0xFFA8E6CF), Color(0xFFDCEDC1), _controller.value)!,
                      Color.lerp(Color(0xFFB2DFDB), Color(0xFFC8E6C9), _controller.value)!,
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

          /// 📱 CONTENT
          SingleChildScrollView(
            child: Column(
              children: [

                /// HEADER
                Container(
                  height: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(60),
                          ),
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.35),
                            ),
                            child: Icon(Icons.person_add,
                                size: 60, color: Colors.teal[800]),
                          ),

                          SizedBox(height: 10),

                          Text(
                          "Daftar Akun",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                          Text(
                            "Mulai perjalanan sehat mentalmu",
                            style: TextStyle(
                              color: Colors.teal[700],
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
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// USERNAME
                      TextField(
                        controller: user,
                        decoration: inputStyle("Username", Icons.person),
                      ),

                      SizedBox(height: 15),

                      /// EMAIL
                      TextField(
                        controller: email,
                        decoration: inputStyle("Email", Icons.email),
                      ),

                      SizedBox(height: 15),

                      /// PASSWORD
                      TextField(
                        controller: pass,
                        obscureText: hidePass,
                        decoration: inputStyle("Password", Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              hidePass ? Icons.visibility_off : Icons.visibility,
                              color: Colors.teal,
                            ),
                            onPressed: () {
                              setState(() => hidePass = !hidePass);
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 5),

                      /// 🔥 PASSWORD HINT
                      Text(
                        "Minimal 8 karakter dan simbol",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),

                      SizedBox(height: 15),

                      /// CONFIRM PASSWORD
                      TextField(
                        controller: confirmPass,
                        obscureText: hideConfirm,
                        decoration: inputStyle("Konfirmasi Password", Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              hideConfirm ? Icons.visibility_off : Icons.visibility,
                              color: Colors.teal,
                            ),
                            onPressed: () {
                              setState(() => hideConfirm = !hideConfirm);
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      /// BUTTON
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6FBF8F),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: registerUser,
                        child: Text("Daftar",style: TextStyle(
      color: Colors.white, // 🔥 INI FIX TEXT PUTIH
      fontWeight: FontWeight.bold,
      ),
                        ),
                        
                      ),

                      SizedBox(height: 10),

                      /// BACK LOGIN
                      TextButton(
                        child: Text(
                          "Sudah punya akun? Login",
                          style: TextStyle(color: Colors.teal[800]),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
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
      prefixIcon: Icon(icon, color: Colors.teal[800]),
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