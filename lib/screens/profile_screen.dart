// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../models/course_model.dart';
import 'personal_details_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Azizbek Tursunov";
  String userRole = "Flutter Dasturchi | Talaba";
  String userImage = "https://picsum.photos/id/64/200/200";

  @override
  Widget build(BuildContext context) {
    // REJIMNI ANIQLASH
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    int courseCount = myEnrolledCourses.length;
    int hoursSpent = courseCount * 12;
    String rating = "4.8"; 

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              
              // --- 1. PROFIL RASMI VA EDIT TUGMASI ---
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.indigo, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundImage: NetworkImage(userImage),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).scaffoldBackgroundColor, 
                                width: 3
                              ),
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 18),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      userName,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userRole,
                      style: TextStyle(color: subTextColor, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- 2. STATISTIKA ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard(courseCount.toString(), "Kurslar", isDark),
                    _buildStatCard("$hoursSpent soat", "O'qildi", isDark),
                    _buildStatCard(rating, "Reyting", isDark),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- 3. MENU RO'YXATI ---
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor, // Dinamik rang
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? Colors.grey[800]! : Colors.transparent),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.08), 
                      blurRadius: 15,
                      offset: const Offset(0, 5)
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      Icons.person_outline, 
                      "Shaxsiy ma'lumotlar",
                      textColor: textColor,
                      onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalDetailsScreen()));
                      }
                    ),
                    Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200], indent: 20, endIndent: 20),
                    
                    _buildMenuItem(Icons.payment, "To'lovlar tarixi", textColor: textColor),
                    Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200], indent: 20, endIndent: 20),
                    
                    _buildMenuItem(
                      Icons.settings_outlined, 
                      "Sozlamalar",
                      textColor: textColor,
                      onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                      }
                    ),
                    Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200], indent: 20, endIndent: 20),
                    
                    _buildMenuItem(Icons.help_outline, "Yordam markazi", textColor: textColor),
                    Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200], indent: 20, endIndent: 20),
                    
                    _buildMenuItem(Icons.logout, "Chiqish", color: Colors.red),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, bool isDark) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
      child: Column(
        children: [
          Text(
            value, 
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Color color = Colors.black87, Color? textColor, VoidCallback? onTap}) {
    final finalColor = (color == Colors.red) ? Colors.red : (textColor ?? Colors.black87);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color == Colors.red) ? Colors.red.withOpacity(0.1) : Colors.indigo.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Icon(icon, color: color == Colors.red ? Colors.red : Colors.indigo, size: 22),
      ),
      title: Text(title, style: TextStyle(color: finalColor, fontWeight: FontWeight.w600, fontSize: 15)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title bosildi")));
      },
    );
  }
}