// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Google paketi
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllerlar
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  bool _isLogin = true; // Login yoki Registratsiya
  bool _isLoading = false;

  // Telefon rejimi uchun
  bool _isPhoneMode = false;
  bool _codeSent = false;
  String _verificationId = "";

  // --- 1. GOOGLE BILAN KIRISH (TUZATILGAN KOD) ---
  // --- GOOGLE BILAN KIRISH (TUZATILGAN) ---
  // --- GOOGLE BILAN KIRISH (TUZATILGAN) ---
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      // 1. Google obyektini yaratamiz
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // 2. Google oynasini ochish
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Agar foydalanuvchi oynani yopib qo'ysa
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      // 3. Kalitlarni olish
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 4. Firebase uchun ruxsatnoma (Credential) yasash
      // DIQQAT: Bu qator "signInWithCredential" dan OLDIN turishi SHART!
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 5. Tizimga kirish (Endi credential tayyor)
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // 6. Bazaga yozish (Yangi "user" roli bilan)
      if (userCredential.user != null) {
        await _createUserInFirestore(userCredential.user!);
      }

      // 7. Muvaffaqiyatli o'tish
      _goToHome();

    } catch (e) {
      _showError("Google xatosi: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _createUserInFirestore(User user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // 1. Tekshiramiz: Bu odam bazada bormi?
    final docSnapshot = await userDoc.get();

    // 2. Agar yo'q bo'lsa -> Yangi "user" qilib yozamiz
    if (!docSnapshot.exists) {
      await userDoc.set({
        'email': user.email,
        'role': 'user', // <--- AVTOMATIK ODDIY USER BO'LADI
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // --- 2. EMAIL BILAN KIRISH ---
  Future<void> _submitEmail() async {
    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
      if (_isLogin) {
        // Login qilganda shart emas (chunki u allaqachon bazada bor)
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // --- REGISTRATSIYA QILGANDA ---
        final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // --- YANGI: BAZAGA YOZISH ---
        if (userCredential.user != null) {
          await _createUserInFirestore(userCredential.user!);
        }
      }
      _goToHome();
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Xatolik");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- 3. TELEFON (SMS) ---
  Future<void> _verifyPhone() async {
    setState(() => _isLoading = true);
    String phone = _phoneController.text.trim();
    if (!phone.startsWith('+')) phone = "+998$phone";

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          _goToHome();
        },
        verificationFailed: (FirebaseAuthException e) {
          _showError("SMS xatosi: ${e.message}");
          setState(() => _isLoading = false);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _codeSent = true;
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("SMS yuborildi!")));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      _showError("Xato: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOTP() async {
    setState(() => _isLoading = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      _goToHome();
    } catch (e) {
      _showError("Kod noto'g'ri");
      setState(() => _isLoading = false);
    }
  }

  void _goToHome() {
    if (mounted) {
      // Login oynasini butunlay yopib, Bosh sahifani ochadi
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false, // Orqaga qaytish yo'lini yopib tashlaydi
      );
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.school, size: 80, color: Colors.white),
                const SizedBox(height: 10),
                const Text("Edu App", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Text(
                        _isPhoneMode
                            ? (_codeSent ? "Kodni kiriting" : "Telefon raqam")
                            : (_isLogin ? "Xush kelibsiz!" : "Ro'yxatdan o'tish"),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 20),

                      if (_isPhoneMode) ...[
                        if (!_codeSent)
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: "Telefon (90 123 45 67)",
                              prefixText: "+998 ",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          )
                        else
                          TextField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: "SMS Kod",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                      ] else ...[
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Parol",
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isLoading
                              ? null
                              : (_isPhoneMode
                              ? (_codeSent ? _verifyOTP : _verifyPhone)
                              : _submitEmail),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                            _isPhoneMode
                                ? (_codeSent ? "TASDIQLASH" : "SMS YUBORISH")
                                : (_isLogin ? "KIRISH" : "RO'YXATDAN O'TISH"),
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      if (!_isPhoneMode) ...[
                        const Text("— Yoki —", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // GOOGLE TUGMASI
                            _socialButton(
                              icon: Icons.g_mobiledata,
                              color: Colors.red,
                              onTap: _signInWithGoogle,
                            ),
                            const SizedBox(width: 20),
                            // TELEFON TUGMASI
                            _socialButton(
                              icon: Icons.phone,
                              color: Colors.green,
                              onTap: () {
                                setState(() {
                                  _isPhoneMode = true;
                                  _codeSent = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (_isPhoneMode) {
                              _isPhoneMode = false;
                              _codeSent = false;
                            } else {
                              _isLogin = !_isLogin;
                            }
                          });
                        },
                        child: Text(
                          _isPhoneMode
                              ? "Email orqali kirish"
                              : (_isLogin ? "Akkauntingiz yo'qmi? Ro'yxatdan o'ting" : "Akkaunt bormi? Kirish"),
                          style: const TextStyle(color: Colors.indigo),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(icon, size: 30, color: color),
      ),
    );
  }
}