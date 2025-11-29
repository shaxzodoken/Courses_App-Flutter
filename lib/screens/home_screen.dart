// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../components/section_header.dart';
import '../components/category_selector.dart';
import '../components/course_cards.dart';
import 'profile_screen.dart';
import 'my_courses_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Sahifalar ro'yxati
  final List<Widget> _pages = [
    const HomeContent(),         // 0: Asosiy
    const MyCoursesScreen(),     // 1: Darslarim
    const Center(child: Text("Chat sahifasi (Tez orada)")), // 2: Chat
    const ProfileScreen(),       // 3: Profil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tungi rejimni aniqlash
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Body qismi (Scaffold background main.dart dan keladi)
      body: _pages[_selectedIndex],

      // --- PASTKI MENYU (Professional Dizayn) ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black45 : Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent, // Konteyner rangi ishlaydi
          elevation: 0, // Soyani konteynerga berdik
          
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Bosh sahifa"),
            BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: "Darslarim"),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          ],
        ),
      ),
    );
  }
}

// --- ASOSIY KONTENT (HOME) ---
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _searchQuery = "";
  String _selectedCategory = "Barchasi";

  List<Course> get _filteredCourses {
    return allCourses.where((course) {
      final matchesSearch = course.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == "Barchasi" || course.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayCourses = _filteredCourses;
    
    // Ranglar
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. HEADER QISMI ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.indigo, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage("https://picsum.photos/id/64/200/200"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Xush kelibsiz, 👋", style: TextStyle(color: secondaryTextColor, fontSize: 14)),
                      Text("Talaba", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                         BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)
                      ]
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_outlined, color: textColor),
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. QIDIRUV (SEARCH BAR) ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, // Dinamik fon
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
                border: Border.all(color: isDark ? Colors.grey[800]! : Colors.transparent),
              ),
              child: TextField(
                style: TextStyle(color: textColor),
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: secondaryTextColor),
                  hintText: "Kurslarni qidirish...",
                  hintStyle: TextStyle(color: secondaryTextColor),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // --- 3. KATEGORIYALAR ---
            CategorySelector(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() => _selectedCategory = category);
              },
            ),
            const SizedBox(height: 20),

            // --- 4. MASHHUR KURSLAR ---
            if (displayCourses.isNotEmpty) ...[
              SectionHeader(title: "Mashhur Kurslar 🔥", onSeeAll: () {}),
              SizedBox(
                height: 280, // Biroz kattalashtirdik soyalar uchun
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 20),
                  itemCount: displayCourses.length,
                  itemBuilder: (context, index) {
                    return CourseCardVertical(course: displayCourses[index]);
                  },
                ),
              ),
            ],

            // --- 5. NATIJALAR (LIST) ---
            const SizedBox(height: 10),
            SectionHeader(title: "Barcha darslar", onSeeAll: () {}),

            displayCourses.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(Icons.search_off, size: 60, color: secondaryTextColor),
                          const SizedBox(height: 10),
                          Text("Hech narsa topilmadi", style: TextStyle(color: secondaryTextColor)),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: displayCourses.length,
                    itemBuilder: (context, index) {
                      return CourseCardHorizontal(course: displayCourses[index]);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}