import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  List<String> _categories = [
    'Food',
    'Entertainment',
    'Transport',
    'Miscellaneous',
    'Rent',
  ];

  List<String> get categories => _categories;

  CategoryProvider() {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCategories = prefs.getStringList('categories');
    if (savedCategories != null) {
      _categories = savedCategories;
    } else {
      // If no categories are saved, save the default ones.
      await prefs.setStringList('categories', _categories);
    }
    notifyListeners();
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories', _categories);
  }

  void addCategory(String category) {
    if (category.isNotEmpty && !_categories.contains(category)) {
      _categories.add(category);
      _saveCategories();
      notifyListeners();
    }
  }

  void removeCategory(String category) {
    if (_categories.length > 1) {
      // Prevent deleting the last category
      _categories.remove(category);
      _saveCategories();
      notifyListeners();
    }
  }

  void reorderCategories(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final String item = _categories.removeAt(oldIndex);
    _categories.insert(newIndex, item);
    _saveCategories();
    notifyListeners();
  }
}
