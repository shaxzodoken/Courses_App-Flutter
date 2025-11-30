// lib/screens/add_course_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Baza bilan ishlash uchun

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  // Formalar uchun boshqaruvchilar
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _instructorController = TextEditingController();
  final _videoController = TextEditingController();
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
  final ValueNotifier<bool> adminModeNotifier = ValueNotifier(false);
  
  bool _isLoading = false; // Yuklanayotganda aylanib turishi uchun

  // Kursni bazaga yozish funksiyasi
  Future<void> _saveCourse() async {
    if (_titleController.text.isEmpty || _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Iltimos, asosiy maydonlarni to'ldiring")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. FIREBASEGA JO'NATISH
      await FirebaseFirestore.instance.collection('courses').add({
        'title': _titleController.text,
        'category': _categoryController.text, // Masalan: IT, English
        'price': _priceController.text, // Masalan: 150$ yoki Bepul
        'image': _imageController.text, // Rasm linki
        'videoUrl': _videoController.text,
        'instructor': _instructorController.text, // O'qituvchi ismi
        'rating': "5.0", // Boshlanishiga hammaga 5 baho
        'createdAt': FieldValue.serverTimestamp(), // Qo'shilgan vaqti
      });

      // 2. MUVAFFAQIYATLI XABAR
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kurs muvaffaqiyatli qo'shildi! ✅")));
        Navigator.pop(context); // Orqaga qaytish
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Xatolik: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yangi Kurs Qo'shish")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField("Kurs Nomi", _titleController, icon: Icons.title),
            _buildTextField("Kategoriya (IT, English...)", _categoryController, icon: Icons.category),
            _buildTextField("Narxi (Masalan: 200\$)", _priceController, icon: Icons.attach_money),
            _buildTextField("O'qituvchi Ismi", _instructorController, icon: Icons.person),
            _buildTextField("Rasm Linki (URL)", _imageController, icon: Icons.image),
            _buildTextField("Video Linki (YouTube)", _videoController, icon: Icons.video_library),
            
            const SizedBox(height: 10),
            const Text(
              "Eslatma: Rasm linki uchun Google'dan rasm topib, 'Copy Image Address' qilib shu yerga tashlang.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 30),

            // SAQLASH TUGMASI
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _saveCourse,
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Bazaga Saqlash", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}