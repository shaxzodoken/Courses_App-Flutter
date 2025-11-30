// lib/models/course_model.dart
class Course {
  final String? id;
  final String title;
  final String instructor;
  final String rating;
  final String image;
  final String videoUrl;
  final String category;
  final String price;

  Course({
    this.id,
    required this.title,
    required this.instructor,
    required this.rating,
    required this.image,
    required this.videoUrl,
    required this.category,
    required this.price,
  });
}

// Barcha kurslar (Do'kon)
final List<Course> allCourses = [];

List<Course> myEnrolledCourses = [];
List<Course> myCompletedCourses = [];