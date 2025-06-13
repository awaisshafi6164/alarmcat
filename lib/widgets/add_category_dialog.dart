import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/alarm_category.dart'; // Import AlarmCategory

class AddCategoryDialog extends StatefulWidget {
  final Function(String name, String? emoji) onCategoryAdded;
  final AlarmCategory? existingCategory;

  const AddCategoryDialog({
    super.key,
    required this.onCategoryAdded,
    this.existingCategory,
  });

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emojiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingCategory != null) {
      _nameController.text = widget.existingCategory!.name;
      _emojiController.text = widget.existingCategory!.emoji ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      String? emoji = _emojiController.text.trim();
      String? categoryLabel = _nameController.text.trim();
      final db = await DatabaseHelper().db;
      if (widget.existingCategory != null) {
        // Edit existing category
        await db.update(
          'categories',
          {'name': categoryLabel, 'emoji': emoji.isNotEmpty ? emoji : null},
          where: 'name = ?',
          whereArgs: [widget.existingCategory!.name],
        );
        // Also update alarms with old category name to new name
        await db.update(
          'alarms',
          {'category': categoryLabel},
          where: 'category = ?',
          whereArgs: [widget.existingCategory!.name],
        );
      } else {
        // Add new category (check for duplicate)
        final existing = await db.query(
          'categories',
          where: 'name = ?',
          whereArgs: [categoryLabel],
        );
        if (existing.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category already exists.')),
          );
          return;
        }
        await db.insert('categories', {
          'name': categoryLabel,
          'emoji': emoji.isNotEmpty ? emoji : null,
          'enabled': 1,
        });
      }
      widget.onCategoryAdded(categoryLabel, emoji.isNotEmpty ? emoji : null);
      Navigator.of(context).pop();
    }
  }

  Future<void> deleteCategory() async {
    if (widget.existingCategory == null) return;
    final db = await DatabaseHelper().db;
    // Delete all alarms for this category
    await db.delete(
      'alarms',
      where: 'category = ?',
      whereArgs: [widget.existingCategory!.name],
    );
    // Delete the category
    await db.delete(
      'categories',
      where: 'name = ?',
      whereArgs: [widget.existingCategory!.name],
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existingCategory == null ? 'Add New Category' : 'Edit Category',
      ),
      content: SingleChildScrollView(
        // Added SingleChildScrollView for smaller screens
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  hintText: 'e.g., Work, Study',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emojiController,
                decoration: const InputDecoration(
                  labelText: 'Emoji (optional)',
                  hintText: 'e.g., 👍, 🚀',
                  border: OutlineInputBorder(),
                ),
                maxLength:
                    2, // Allow for emoji + skin tone modifier if any, or just one char
                validator: (value) {
                  // Optional: Add validation for emoji format if needed,
                  // but for simplicity, we'll allow any short string.
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.existingCategory == null ? 'Add' : 'Save'),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Theme.of(context).cardColor,
      titleTextStyle: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
    );
  }
}
