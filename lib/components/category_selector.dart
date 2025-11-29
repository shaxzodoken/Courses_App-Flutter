// lib/components/category_selector.dart
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory; // Hozir tanlangan kategoriya
  final Function(String) onCategorySelected; // Bosilganda nima bo'lishi kerak

  CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories = ["Barchasi", "English", "IT", "Math", "Russian"];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () => onCategorySelected(category), // Bosilganda xabar beradi
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Chip(
                label: Text(category),
                backgroundColor: isSelected ? Colors.indigo : Colors.white,
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                side: BorderSide.none,
                elevation: 2,
              ),
            ),
          );
        },
      ),
    );
  }
}