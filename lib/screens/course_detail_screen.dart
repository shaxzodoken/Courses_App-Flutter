// lib/screens/course_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/course_model.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late YoutubePlayerController _controller;
  bool isEnrolled = false;

  @override
  void initState() {
    super.initState();
    // 1. Kurs allaqachon bormi?
    isEnrolled = myEnrolledCourses.contains(widget.course);

    // 2. Video sozlamalari
    const videoUrl = "https://www.youtube.com/watch?v=fq4N0hgOWzU";
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _enrollCourse() {
    setState(() {
      myEnrolledCourses.add(widget.course);
      isEnrolled = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.course.title} darslaringizga qo'shildi!"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tungi rejimni aniqlash
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      // Background scaffolddan olinadi (main.dart da sozlangan)
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. VIDEO PLEYER QISMI ---
            Stack(
              children: [
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.indigo,
                  topActions: [
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        _controller.metadata.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                // Orqaga qaytish tugmasi
                Positioned(
                  top: 10,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),

            // --- 2. KURS MA'LUMOTLARI ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Sarlavha
                  Text(
                    widget.course.title,
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: textColor
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Kategoriya va O'qituvchi
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.course.category,
                          style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text("•  ${widget.course.instructor}", style: TextStyle(color: secondaryTextColor)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Narx va Reyting bloki
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor, // Dinamik rang
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Narxi", style: TextStyle(color: secondaryTextColor, fontSize: 12)),
                            Text(
                              widget.course.price,
                              style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(height: 30, width: 1, color: Colors.grey[300]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Reyting", style: TextStyle(color: secondaryTextColor, fontSize: 12)),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.orange, size: 16),
                                Text(" ${widget.course.rating}", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                              ],
                            ),
                          ],
                        ),
                        Container(height: 30, width: 1, color: Colors.grey[300]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Davomiyligi", style: TextStyle(color: secondaryTextColor, fontSize: 12)),
                            Text("12 soat", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Tavsif
                  Text("Kurs haqida", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Text(
                    "Bu kurs orqali siz noldan boshlab professional darajagacha o'rganasiz. Darslar amaliy mashg'ulotlarga boy va real loyihalar asosida tuzilgan.",
                    style: TextStyle(color: secondaryTextColor, height: 1.5, fontSize: 15),
                  ),
                  const SizedBox(height: 25),

                  // Darslar ro'yxati
                  Text("Darslar mundarijasi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 15),
                  
                  _buildLessonItem("1. Kirish va o'rnatish", "12:30", false, context),
                  _buildLessonItem("2. Asosiy tushunchalar", "15:45", !isEnrolled, context),
                  _buildLessonItem("3. O'zgaruvchilar", "20:10", !isEnrolled, context),
                  _buildLessonItem("4. Amaliy mashg'ulot", "45:00", !isEnrolled, context),
                  _buildLessonItem("5. Yakuniy imtihon", "60:00", !isEnrolled, context),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),

      // --- PASTKI TUGMA (Bottom Bar) ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, // Oq yoki Qora (Avtomatik)
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black45 : Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
          border: Border(top: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!)),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnrolled ? Colors.green : Colors.indigo,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          onPressed: isEnrolled 
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Dars davom etmoqda...")));
              } 
            : _enrollCourse,
          child: Text(
            isEnrolled ? "Darsni davom ettirish" : "Kursga yozilish",
            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonItem(String title, String duration, bool isLocked, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Dinamik rang
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isLocked 
                ? (isDark ? Colors.grey[800] : Colors.grey[200]) // Qulflangan rang
                : Colors.indigo.withOpacity(0.1), // Ochiq rang
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isLocked ? Icons.lock : Icons.play_arrow_rounded,
            color: isLocked ? Colors.grey : Colors.indigo,
            size: 24,
          ),
        ),
        title: Text(
          title, 
          style: TextStyle(
            fontWeight: FontWeight.w600, 
            color: isLocked ? Colors.grey : (isDark ? Colors.white : Colors.black87)
          )
        ),
        subtitle: Text(duration, style: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[600], fontSize: 12)),
        trailing: isLocked 
          ? null 
          : const Icon(Icons.check_circle, color: Colors.green, size: 20),
        onTap: () {
          if (isLocked) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                 content: const Text("Bu darsni ko'rish uchun kursga yoziling!"),
                 behavior: SnackBarBehavior.floating,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
               )
             );
          } else {
            // Video o'zgartirish logikasi
          }
        },
      ),
    );
  }
}