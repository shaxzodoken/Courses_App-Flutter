// lib/screens/my_courses_screen.dart
import 'package:flutter/material.dart';
import '../models/course_model.dart';
import 'course_detail_screen.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  
  // Kursni o'chirish
  void _deleteCourse(Course course, bool isCompletedTab) {
    setState(() {
      if (isCompletedTab) {
        myCompletedCourses.remove(course);
      } else {
        myEnrolledCourses.remove(course);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Kurs ro'yxatdan o'chirildi"),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Kursni tugatish
  void _completeCourse(Course course) {
    setState(() {
      myEnrolledCourses.remove(course);
      myCompletedCourses.add(course);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Tabriklaymiz! Kurs tugatildi 🎉"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent, // Orqa fon shaffof (scaffold rangi)
          title: Text(
            "Mening Darslarim", 
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 22)
          ),
          centerTitle: false,
          bottom: TabBar(
            labelColor: Colors.indigo,
            unselectedLabelColor: isDark ? Colors.grey[500] : Colors.grey,
            indicatorColor: Colors.indigo,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: const [
              Tab(text: "Jarayonda"),
              Tab(text: "Tugatilgan"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1-TAB: JARAYONDA
            _buildList(myEnrolledCourses, isCompletedTab: false),
            
            // 2-TAB: TUGATILGAN
            _buildList(myCompletedCourses, isCompletedTab: true),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Course> courses, {required bool isCompletedTab}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompletedTab ? Icons.verified_outlined : Icons.video_library_outlined, 
              size: 80, 
              color: isDark ? Colors.grey[800] : Colors.grey[300]
            ),
            const SizedBox(height: 15),
            Text(
              isCompletedTab ? "Hali hech qaysi kurs tugatilmagan" : "Sizda faol kurslar yo'q",
              style: TextStyle(color: subTextColor, fontSize: 16),
            ),
            if (!isCompletedTab)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Bosh sahifadan kurs tanlang",
                  style: TextStyle(color: Colors.indigo.withOpacity(0.7), fontSize: 14),
                ),
              )
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => CourseDetailScreen(course: course))
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, // Dinamik rang
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.grey[800]! : Colors.transparent),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.08), 
                  blurRadius: 10,
                  offset: const Offset(0, 4)
                )
              ],
            ),
            child: Row(
              children: [
                // --- 1. Rasm ---
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(course.image, width: 85, height: 85, fit: BoxFit.cover),
                ),
                const SizedBox(width: 15),
                
                // --- 2. Matnlar ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Text(
                          course.category, 
                          style: const TextStyle(color: Colors.indigo, fontSize: 10, fontWeight: FontWeight.bold)
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        course.title, 
                        maxLines: 2, 
                        overflow: TextOverflow.ellipsis, 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)
                      ),
                      const SizedBox(height: 10),
                      
                      // Progress Bar yoki Status
                      if (!isCompletedTab) 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: 0.4, 
                                color: Colors.indigo, 
                                // Tungi rejimda progress orqa foni qorayadi
                                backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200], 
                                minHeight: 6
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("40% tugatildi", style: TextStyle(fontSize: 10, color: subTextColor))
                          ],
                        )
                      else 
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 14),
                            const SizedBox(width: 4),
                            Text("Sertifikat olindi", style: TextStyle(color: Colors.green.shade600, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        )
                    ],
                  ),
                ),

                // --- 3. Boshqaruv Tugmalari ---
                Column(
                  children: [
                    // O'chirish
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 22),
                      tooltip: "O'chirish",
                      onPressed: () => _deleteCourse(course, isCompletedTab),
                    ),
                    
                    // Tugatish (Faqat jarayonda bo'lsa)
                    if (!isCompletedTab)
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 22),
                        tooltip: "Tugatdim",
                        onPressed: () => _completeCourse(course),
                      ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}