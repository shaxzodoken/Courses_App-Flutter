// lib/components/course_cards.dart
import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../screens/course_detail_screen.dart';

// Katta Karta (Vertikal)
class CourseCardVertical extends StatelessWidget {
  final Course course;

  const CourseCardVertical({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Hozir qora rejimdami yoki yo'q?
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseDetailScreen(course: course)),
        );
      },
      child: Container(
        width: 240, 
        margin: const EdgeInsets.only(left: 20, bottom: 10, top: 5),
        decoration: BoxDecoration(
          // --- MUHIM O'ZGARISH: RANG MAVZUGA QARAB O'ZGARADI ---
          color: Theme.of(context).cardColor, 
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(course.image, height: 130, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.category, style: const TextStyle(color: Colors.indigo, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  // Matn rangi ham o'zgaradi
                  Text(course.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      Text(" ${course.rating}", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(width: 10),
                      Text(course.price, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Kichik Karta (Gorizontal)
class CourseCardHorizontal extends StatelessWidget {
  final Course course;

  const CourseCardHorizontal({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Hozir qora rejimdami yoki yo'q?
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseDetailScreen(course: course)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // --- MUHIM O'ZGARISH ---
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(course.image, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
                  const SizedBox(height: 5),
                  Text("O'qituvchi: ${course.instructor}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.play_circle_outline, size: 16, color: Colors.indigo),
                      const SizedBox(width: 4),
                      Text("${course.category} kursi", style: const TextStyle(color: Colors.indigo, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}