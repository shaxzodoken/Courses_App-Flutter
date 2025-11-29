// lib/models/course_model.dart
class Course {
  final String title;
  final String instructor;
  final String rating;
  final String image;
  final String category;
  final String price;

  Course({
    required this.title,
    required this.instructor,
    required this.rating,
    required this.image,
    required this.category,
    required this.price,
  });
}

// Barcha kurslar (Do'kon)
final List<Course> allCourses = [
  Course(title: "Ingliz Tili: Noldan Advancedgacha", instructor: "Aziz Rahimov", rating: "4.9", category: "English", price: "Bepul", image: "https://picsum.photos/id/1/300/200"),
  Course(title: "IELTS 7.5+ Strategiyasi", instructor: "Malika Karimova", rating: "5.0", category: "English", price: "150\$", image: "https://picsum.photos/id/20/300/200"),
  Course(title: "Flutter Bilan Mobil Dasturlash", instructor: "Sardor Islomov", rating: "4.8", category: "IT", price: "Bepul", image: "https://picsum.photos/id/3/300/200"),
  Course(title: "Rus Tili So'zlashuv", instructor: "Elena Vasileva", rating: "4.5", category: "Russian", price: "50\$", image: "https://picsum.photos/id/4/300/200"),
  Course(title: "Matematika: Abituriyentlar uchun", instructor: "Jamshid aka", rating: "4.7", category: "Math", price: "Bepul", image: "https://picsum.photos/id/5/300/200"),
];

List<Course> myEnrolledCourses = [];
List<Course> myCompletedCourses = [];