
import 'package:flutter/material.dart';
import 'package:myapp/providers/category_provider.dart';
import 'package:provider/provider.dart';

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final TextEditingController newCategoryController = TextEditingController();

    void showAddCategoryDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add New Category'),
            content: TextField(
              controller: newCategoryController,
              decoration: const InputDecoration(hintText: 'Category Name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (newCategoryController.text.isNotEmpty) {
                    categoryProvider.addCategory(newCategoryController.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
      ),
      body: ReorderableListView(
        onReorder: categoryProvider.reorderCategories,
        children: [
          for (final category in categoryProvider.categories)
            ListTile(
              key: ValueKey(category),
              title: Text(category),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => categoryProvider.removeCategory(category),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddCategoryDialog,
        child: const Icon(Icons.add),
        tooltip: 'Add Category',
      ),
    );
  }
}
