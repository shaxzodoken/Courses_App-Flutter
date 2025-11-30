// lib/screens/home_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../components/section_header.dart';
import '../components/category_selector.dart';
import '../components/course_cards.dart';
import '../main.dart';
import 'profile_screen.dart';
import 'my_courses_screen.dart';
import 'add_course_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    super.initState();
    _checkAdminRole(); // Ilova ochilishi bilan tekshiramiz
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _checkAdminRole() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Bazadan shu odamni qidiramiz
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Agar u "users" ro'yxatida bo'lsa va roli "admin" bo'lsa
      if (userDoc.exists && userDoc.data()?['role'] == 'admin') {
        adminModeNotifier.value = true; // Admin rejimini yoqamiz!
      } else {
        adminModeNotifier.value = false; // Aks holda o'chiramiz
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tungi rejimni aniqlash
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Body qismi (Scaffold background main.dart dan keladi)
      body: _pages[_selectedIndex],

      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: adminModeNotifier, // Pultni eshitamiz
        builder: (context, isAdmin, child) {
          // Agar Admin bo'lmasa -> Tugma yo'q (null)
          if (!isAdmin) return const SizedBox(); 
          
          // Agar Admin bo'lsa -> (+) tugmasi chiqadi
          return FloatingActionButton(
            backgroundColor: Colors.orange,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCourseScreen()));
            },
          );
        },
      ),

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
// lib/screens/home_screen.dart (HomeContent qismi)
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _searchQuery = "";
  String _selectedCategory = "Barchasi";

  @override
  Widget build(BuildContext context) {
    // 1. FIREBASE MA'LUMOTLARINI TAYYORLASH
    final user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? "Foydalanuvchi";
    final String? photoUrl = user?.photoURL;
    final String email = user?.email ?? "";

    // Ism bo'lmasa, emailni kesib olamiz
    final String displayNameFinal = (displayName == "Foydalanuvchi" && email.isNotEmpty)
        ? email.split('@')[0]
        : displayName;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER QISMI (YANGILANDI) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.indigo, width: 2)
                      ),
                      child: CircleAvatar(
                        radius: 24,
                        // --- 2. RASM O'ZGARDI ---
                        // Agar Google rasm bo'lsa o'shani, bo'lmasa eskisini qo'yamiz
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl)
                            : const NetworkImage("https://picsum.photos/id/64/200/200"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Xush kelibsiz, 👋", style: TextStyle(color: secondaryTextColor, fontSize: 14)),
                      // --- 3. ISM O'ZGARDI ---
                      Text(
                          displayNameFinal, // "Talaba" o'rniga haqiqiy ism
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- QIDIRUV ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.grey[800]! : Colors.transparent),
                boxShadow: [BoxShadow(color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1), blurRadius: 10)],
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

            // --- KATEGORIYALAR ---
            CategorySelector(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) => setState(() => _selectedCategory = category),
            ),
            const SizedBox(height: 20),

            // --- FIREBASE KURSLAR ---
            SectionHeader(title: "Barcha Kurslar (Online) 🌐", onSeeAll: () {}),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('courses').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Xatolik yuz berdi!"));
                }

                var docs = snapshot.data!.docs;

                var filteredDocs = docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  String title = (data['title'] ?? "").toString().toLowerCase();
                  String category = (data['category'] ?? "").toString();

                  bool matchesSearch = title.contains(_searchQuery.toLowerCase());
                  bool matchesCategory = _selectedCategory == "Barchasi" || category == _selectedCategory;

                  return matchesSearch && matchesCategory;
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(child: Text("Hozircha kurslar yo'q"));
                }

                return SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      var data = filteredDocs[index].data() as Map<String, dynamic>;

                      Course course = Course(
                        id: filteredDocs[index].id,
                        title: data['title'] ?? "Nomsiz",
                        category: data['category'] ?? "General",
                        image: data['image'] ?? "https://picsum.photos/200/300",
                        price: data['price'] ?? "Bepul",
                        rating: data['rating'] ?? "0.0",
                        instructor: data['instructor'] ?? "Admin",
                        // Video URL ni olishni ham qo'shdik:
                        videoUrl: data['videoUrl'] ?? "https://www.youtube.com/watch?v=fq4N0hgOWzU",
                      );

                      return CourseCardVertical(course: course);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}