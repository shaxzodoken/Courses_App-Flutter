// lib/screens/personal_details_screen.dart
import 'package:flutter/material.dart';
import '../models/course_model.dart';

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Tungi rejimni aniqlash
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent, // Orqa fon shaffof
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Shaxsiy ma'lumotlar", 
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Saqlash logikasi
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("O'zgartirishlar saqlandi! ✅"),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                )
              );
            }, 
            child: const Text("Saqlash", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold))
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- 1. KATTA RASM VA KAMERA TUGMASI ---
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4), // Oq hoshiya (border) uchun
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.indigo, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage("https://picsum.photos/id/64/200/200"),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 3),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 35),

            // --- 2. ASOSIY MA'LUMOTLAR ---
            _buildInfoTile("To'liq ism", "Azizbek Tursunov", Icons.person_outline, context),
            _buildInfoTile("Email", "azizbek@gmail.com", Icons.email_outlined, context),
            _buildInfoTile("Telefon", "+998 90 123 45 67", Icons.phone_outlined, context),
            _buildInfoTile("Parol", "********", Icons.lock_outline, context, isPassword: true),
            
            const SizedBox(height: 25),
            
            // --- 3. MOLIYA VA STATISTIKA ---
            Align(
              alignment: Alignment.centerLeft, 
              child: Text(
                "Moliya va Statistika", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)
              )
            ),
            const SizedBox(height: 15),
            
            _buildInfoTile("Ulanilgan karta", "8600 **** **** 1234", Icons.credit_card, context),
            _buildInfoTile("Jami kurslar", "${myEnrolledCourses.length} ta kurs", Icons.school_outlined, context),
            _buildInfoTile("Tugatilgan", "${myCompletedCourses.length} ta kurs", Icons.check_circle_outline, context),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon, BuildContext context, {bool isPassword = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Dinamik fon
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.transparent), // Tungi rejimda chegara
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.06), 
            blurRadius: 10,
            offset: const Offset(0, 4)
          )
        ],
      ),
      child: Row(
        children: [
          // Ikonka foni
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.indigo.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(12)
            ),
            child: Icon(icon, color: isDark ? Colors.white70 : Colors.indigo, size: 24),
          ),
          const SizedBox(width: 15),
          
          // Matnlar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: subTextColor, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  value, 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                ),
              ],
            ),
          ),
          
          // Parol ko'zi yoki tahrirlash ikonkasini qo'shsa bo'ladi
          if (isPassword)
             Icon(Icons.remove_red_eye_outlined, color: subTextColor),
        ],
      ),
    );
  }
}